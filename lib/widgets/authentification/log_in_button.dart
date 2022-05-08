import 'package:flutter/material.dart';

import 'package:tinycolor/tinycolor.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/screens/authentification/log_in_screen.dart';

/*
    Renders the Log-In-Button Widget
 */
class LogInButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double paddingHorizontal = !ExecutingDevice.isMobile(context) ? defaultPadding * 20 : defaultPadding * 2;

    return Container(
      margin: EdgeInsets.only(
        right: paddingHorizontal,
        left: paddingHorizontal,
        bottom: defaultPadding * 1.3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultPadding * 2.4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: primaryColor.withOpacity(0.2),
            highlightColor: primaryColor.withOpacity(0.2),
            onTap: () {
              Navigator.of(context).pushNamed(LogInScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 1.2),
              child: Text(
                'LOG IN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.5,
                  color: TinyColor(primaryColor).brighten(12).color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius * 4),
                color: Colors.transparent,
                border: Border.all(
                  color: TinyColor(primaryColor).brighten(8).color,
                  width: 4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
