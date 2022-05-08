import 'package:flutter/material.dart';

import 'package:makia_ai/constant_values.dart';

/*
    Renders the Spash Screen of the App
 */
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Stack(
          children: [
            Center(
              child: Transform.scale(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                scale: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: defaultPadding * 3,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Makia -AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
