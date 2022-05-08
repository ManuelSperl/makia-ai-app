import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:makia_ai/models/http_exception.dart';

/*
    Class handles signing up, logging in, updating and deleting Users in Firebase
 */
class Auth with ChangeNotifier {
  final updateUrl = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyDLYVtyfefraUycN7YvHSIB7NU9iNPn6nI',
  );
  final deleteUrl = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyDLYVtyfefraUycN7YvHSIB7NU9iNPn6nI',
  );
  final lookUpUrl = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyDLYVtyfefraUycN7YvHSIB7NU9iNPn6nI',
  );

  String _token; // expires after an amount of time (in Firebase after 1 Hour)
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;
  Map<String, String> _userVerificationData;

  /// Returns if the User is authenticated or not
  bool get isAuth {
    return token != null;
  }

  /// Returns the Authentification-Token
  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }

    return null;
  }

  /// Returns the UserID
  String get userId {
    return _userID;
  }

  /// Returns the User Verification Data, with which the User Logged in
  Map<String, String> get userVerificationData {
    return _userVerificationData;
  }

  /// Method to create a new User-Account via Firebase, or Log In into an existing one
  /// [email] and [password], with which the user wants to sign up OR log in
  /// [urlSegment] to differ the specific Firebase Sign Up OR Log In URLs
  Future<void> _authenticate(String email, String password, String urlSegment, BuildContext context) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyDLYVtyfefraUycN7YvHSIB7NU9iNPn6nI',
    );

    _userVerificationData = {
      'userEmail': email,
      'userPassword': password,
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userID = responseData['lokalId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();

      // Because we have two Screens (Welcome and (Login/Signup))
      // and the secound needs to be poped on sucessfull authentication
      Navigator.of(context).pop();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String(),
        'userEmail': email,
        'userPwd': password,
      });

      // Store userData in the Preferences, to access it later
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  /// Method to Sign Up a new User on Firebase
  /// [email] and [password] with which the User signs up
  Future<void> signUp(String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signUp', context);
  }

  /// Method to Log In a User from Firebase
  /// [email] and [password] with which the User try's to log in
  Future<void> logIn(String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signInWithPassword', context);
  }

  /// Method which try's to Auto Log In an User, so that the User doesn't
  /// have to Log In everytime the App starts
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      // No valid Token
      return false;
    }

    _token = extractedUserData['token'];
    _userID = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _userVerificationData = {
      'userEmail': extractedUserData['userEmail'],
      'userPassword': extractedUserData['userPwd'],
    };

    notifyListeners();
    _autoLogout();

    return true;
  }

  /// Metho to log out the current User
  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();

    // Clears the userData prefs on the Device
    prefs.remove('userData');

    notifyListeners();
  }

  /// Method to automatically log out the current User, if the Authentification token has expired
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      logout,
    );
  }

  /// Method to get all the Information from the Account of the current User
  /// gets all the Information from Firebase
  Future<List> getAccountInfo(BuildContext context) async {
    try {
      final response = await http.post(
        lookUpUrl,
        body: json.encode(
          {'idToken': _token},
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      notifyListeners();

      return responseData['users'];

    } catch (error) {
      throw error;
    }
  }

  /// Method to set new Account Information of the current User
  /// sends all the new Information to Firebase
  Future<void> setAccountInfo(String displayName, BuildContext context) async {
    try {
      final response = await http.post(
        updateUrl,
        body: json.encode(
          {
            'idToken': _token,
            'displayName': displayName,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Method to update the [displayName] of the current User
  /// sends the new [displayname] to Firebase
  Future<void> updateDisplayName(String displayName, BuildContext context) async {
    try {
      final response = await http.post(
        updateUrl,
        body: json.encode(
          {
            'idToken': _token,
            'displayName': displayName,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Method to update the [email] of the current User
  /// sends the new [email] to Firebase
  Future<void> updateEmail(String email, BuildContext context) async {
    try {
      final response = await http.post(
        updateUrl,
        body: json.encode(
          {
            'idToken': _token,
            'email': email,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Method to update the [password] of the current User
  /// sends the new [password] to Firebase
  Future<void> updatePassword(String password, BuildContext context) async {
    try {
      final response = await http.post(
        updateUrl,
        body: json.encode(
          {
            'idToken': _token,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Method to delet the Account, of the current User, from Firebase
  Future<void> deleteAccount(BuildContext context) async {
    try {
      final response = await http.post(
        deleteUrl,
        body: json.encode(
          {
            'idToken': _token,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      final prefs = await SharedPreferences.getInstance();

      // Clears userData and serverData prefs
      prefs.remove('userData');
      prefs.remove('serverData');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
