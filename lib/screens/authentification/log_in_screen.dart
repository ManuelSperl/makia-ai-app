import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tinycolor/tinycolor.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/models/http_exception.dart';
import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/screens/authentification/sign_up_screen.dart';
import 'package:makia_ai/widgets/input_field.dart';

/*
    Renders the Log-In Screen of the App
 */
class LogInScreen extends StatefulWidget {
  static const routeName = '/log-in';

  @override
  State<LogInScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _passwordVisible;
  bool _isLoading = false;
  String emailToReset;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    _passwordVisible = false;

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
                    const SizedBox(height: 75),
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
                      'Please Log In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 160),
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
                      obscureText: !_passwordVisible, // This will obscure the text dynamically
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
                    Padding(
                      padding: EdgeInsets.only(right: padding),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _showPasswordForgotten();
                          },
                        ),
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
                            onPressed: _logIn,
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
                              'Log In'.toUpperCase(),
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
                          'Don\'t have an Account?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            'Sign Up'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: TinyColor(primaryColor).brighten(8).color,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
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

  void _showPasswordForgotten() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forgot your Password?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Enter your E-Mail-Address, to reset your Password.'),
              const SizedBox(height: 25),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-Mail',
                  hintText: 'Enter your E-Mail-Address',
                ),
                onChanged: (value) => emailToReset = value.trim(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (emailToReset != null && emailToReset.contains('@')) {
                    Navigator.of(context).pop();
                    _showConfirmation();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "ERROR: Invaild E-Mail-Address",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                      },
                    );
                    throw ("Invalid E-Mail-Address!");
                  }
                },
                child: const Text('Reset your Password'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius / 2.5),
                  ),
                  primary: TinyColor(primaryColor).brighten(8).color,
                  padding: const EdgeInsets.all(10),
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Forgot your Password?',
          style: TextStyle(
            color: successPwdTextColor,
          ),
        ),
        content: Text(
          'We have sent you a link to $emailToReset, through which you can reset your password.',
          style: TextStyle(
            color: successPwdTextColor,
          ),
        ),
        backgroundColor: successPwdBgColor,
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

  void _logIn() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).logIn(
        _authData['email'].trim(),
        _authData['password'].trim(),
        context,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find an User with this E-Mail Address.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password.';
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
