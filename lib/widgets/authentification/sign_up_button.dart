import 'package:flutter/material.dart';

import 'package:tinycolor/tinycolor.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/screens/authentification/sign_up_screen.dart';

/*
    Renders the Sign-Up-Button Widget
 */
class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double paddingHorizontal = !ExecutingDevice.isMobile(context) ? defaultPadding * 20 : defaultPadding * 2;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: defaultPadding * 1.3,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SignUpScreen.routeName);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius * 4),
          ),
          primary: TinyColor(primaryColor).brighten(8).color,
          padding: const EdgeInsets.all(25),
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
