import 'package:flutter/material.dart';

import 'package:tinycolor/tinycolor.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/widgets/authentification/sign_up_button.dart';
import 'package:makia_ai/widgets/authentification/log_in_button.dart';

/*
    Renders the Welcome Screen of the App
 */
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 55),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 88,
                      backgroundColor: TinyColor(primaryColor).darken(4).color,
                      backgroundImage: AssetImage('assets/images/makiaAI_welcome_logo.png'),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Makia -AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 41,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 65),
                  SignUpButton(),
                  LogInButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
