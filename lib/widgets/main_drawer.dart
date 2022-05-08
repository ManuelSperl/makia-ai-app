import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/main_screen.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';
import 'package:makia_ai/screens/settings/user_settings_screen.dart';
import 'package:makia_ai/widgets/authentification/server_verification_pop_up.dart';

/*
    Renders the Main-Drawer of the App
 */
class MainDrawer extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  Widget _buildListTile(String title, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white54 : lightModeTextColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white54 : lightModeTextColor,
        ),
      ),
      horizontalTitleGap: 0.0,
      onTap: tabHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView( // enables Scrolling, if there are too many Entries
        child: Column(
          children: [
            DrawerHeader(
              child: isDarkMode
                  ? Image.asset('assets/images/makiaAI_logo_darkMode.png')
                  : Image.asset('assets/images/makiaAI_logo_lightMode.png'),
            ),
            _buildListTile(
              "Main Screen",
              Icons.dashboard_outlined,
              () {
                Navigator.of(context).popAndPushNamed(
                  MainScreen.routeName,
                );
              },
            ),
            _buildListTile(
              "Server Verification",
              Icons.verified_user_outlined,
              () {
                _showOpenDialog(context);
              },
            ),
            _buildListTile(
              "User Settings",
              Icons.manage_accounts_outlined,
              () {
                Navigator.of(context).popAndPushNamed(
                  UserSettingsScreen.routeName,
                );
              },
            ),
            _buildListTile(
              "Settings",
              Icons.settings_outlined,
              () {
                Navigator.of(context).popAndPushNamed(
                  SettingsScreen.routeName,
                );
              },
            ),
            _buildListTile(
              "Logout",
              Icons.logout,
              () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _showOpenDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return ServerVerificationPopUp();
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pop(); // close Main-Drawer

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
