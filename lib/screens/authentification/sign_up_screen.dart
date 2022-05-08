import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tinycolor/tinycolor.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/models/http_exception.dart';
import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/screens/authentification/log_in_screen.dart';
import 'package:makia_ai/widgets/input_field.dart';

/*
    Renders the Sign-Up Screen of the App
 */
class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _passwordVisible;
  bool _confirmPasswordVisible;
  bool _isLoading = false;
  Map<String, String> _authData = {
    'email': '',
    'displayName': '',
    'password': '',
  };

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double padding = !ExecutingDevice.isMobile(context) ? defaultPadding * 20 : defaultPadding;

    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/welcome_main_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: defaultPadding * 3.5,
                  left: defaultPadding,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 33.0,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      'Makia -AI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 41,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Please Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 90),
                    InputField(
                      textInputType: TextInputType.emailAddress,
                      labelText: ' E -Mail ',
                      hintText: 'Enter your E-Mail',
                      suffixIcon: Icon(
                        Icons.email_outlined,
                        color: primaryColor,
                      ),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onChanged: (value) => _authData['email'] = value,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    InputField(
                      textInputType: TextInputType.text,
                      labelText: ' Display Name ',
                      hintText: 'Enter your Display Name',
                      suffixIcon: Icon(
                        Icons.person_outline,
                        color: primaryColor,
                      ),
                      onChanged: (value) => _authData['displayName'] = value,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Display Name is too short!';
                        }
                      },
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    InputField(
                      obscureText: !_passwordVisible,
                      // This will obscure the text dynamically
                      controller: _passwordController,
                      textInputType: TextInputType.text,
                      labelText: ' Password ',
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on the _passwordVisible state, choose the icon
                          _passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          // Update the state, i.e.: toogle the state of the _passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      onChanged: (value) => _authData['password'] = value,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    InputField(
                      obscureText: !_confirmPasswordVisible,
                      textInputType: TextInputType.text,
                      labelText: ' Confirm Password ',
                      hintText: 'Confirm your Password',
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on the _confirmPasswordVisible state, choose the icon
                          _confirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          // Update the state, i.e.: toogle the state of the _confirmPasswordVisible variable
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    if (_isLoading)
                      Container(
                        height: 58,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: defaultPadding * 3.5,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(
                          right: padding,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: _singUp,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(defaultRadius * 4),
                              ),
                              primary: TinyColor(primaryColor).brighten(8).color,
                              padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding,
                                horizontal: defaultPadding * 2,
                              ),
                              elevation: 0.0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              'Sign Up'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: defaultPadding * 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an Account?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            'Log In'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: TinyColor(primaryColor).brighten(8).color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error occured!'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }

  void _singUp() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email'].trim(), _authData['password'].trim(), context)
          .whenComplete(() {
        Provider.of<Auth>(context, listen: false).setAccountInfo(_authData['displayName'].trim(), context);
      });
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This E-Mail Address already exists.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is an invalid E-Mail Address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This Password is too weak.';
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later.';

      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
