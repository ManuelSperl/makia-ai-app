import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Loading-Dialog Widget
 */
class LoadingDialog extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 130,
      ),
      elevation: 0,
      content: Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
        ),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
