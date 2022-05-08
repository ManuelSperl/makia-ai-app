import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';
import 'package:makia_ai/screens/settings/user_settings_screen.dart';

/*
    Renders the Profile-Card Widget
 */
class ProfileCard extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: defaultPadding,
      ),
      padding: const EdgeInsets.only(
        left: defaultPadding / 1.2,
        right: defaultPadding / 2,
        top: defaultPadding / 2,
        bottom: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
        border: Border.all(color: Colors.white10),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultRadius),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/profile_picture.png',
            height: 38,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onSelected: (item) => _handleClick(item, context),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: const Text('User Settings'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Container(
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      SizedBox(width: defaultPadding / 2),
                      const Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleClick(int item, BuildContext context) {
    switch (item) {
      case 0:
        Navigator.of(context).popAndPushNamed(
          UserSettingsScreen.routeName,
        );
        break;
      case 1:
        _logout(context);
        break;
    }
  }

  void _logout(BuildContext context) {
    // goes to the Home-Route and clears the Widget-Tree
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );

    Provider.of<CameraList>(context, listen: false).clearCameraList();
    Provider.of<Auth>(context, listen: false).logout();
  }
}
