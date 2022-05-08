import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/screens/settings/account_screen.dart';
import 'package:makia_ai/screens/main_screen.dart';
import 'package:makia_ai/screens/settings/notification_screen.dart';
import 'package:makia_ai/widgets/authentification/delete_account_pop_up.dart';
import 'package:makia_ai/widgets/icon_widget.dart';
import 'package:makia_ai/widgets/main_drawer.dart';

/*
    Renders the Settings Screen of the App
 */
class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings-screen";
  static const keyDarkMode = "key-dark-mode";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Drawer should only be opened constantly on Desktops
            if (ExecutingDevice.isDesktop(context))
              Expanded(
                // default flex = 1 -> takes 1/6 of the screen space
                child: MainDrawer(),
              ),
            Expanded(
              flex: 5, // takes 5/6 of the screen space
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Header(),
                    const SizedBox(height: defaultPadding * 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsGroup(
                          title: 'DARK MODE',
                          children: [
                            _buildDarkMode(),
                            const SizedBox(height: 32),
                          ],
                        ),
                        SettingsGroup(
                          title: 'GENERAL',
                          children: [
                            const SizedBox(height: defaultPadding),
                            AccountScreen(),
                            NotificationScreen(),
                            const SizedBox(height: defaultPadding * 2),
                            _buildDeleteAccount(context),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SettingsGroup(
                          title: 'FEEDBACK',
                          children: [
                            const SizedBox(height: 8),
                            _buildReportBug(context),
                            _buildSendFeedback(context),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkMode() => SwitchSettingsTile(
        settingKey: keyDarkMode,
        title: 'Dark Mode',
        leading: IconWidget(
          icon: Icons.dark_mode_outlined,
          color: Color(0xFF642ef3),
        ),
      );

  Widget _buildDeleteAccount(BuildContext context) => SimpleSettingsTile(
        title: 'Delete Account',
        subtitle: 'All your Data will be erased',
        leading: IconWidget(
          icon: Icons.delete_outline,
          color: Colors.pink,
        ),
        onTap: () {
          _showOpenDialogDeletion(context);
        },
      );

  Widget _buildReportBug(BuildContext context) => SimpleSettingsTile(
        title: 'Report A Bug',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.bug_report_outlined,
          color: Colors.teal,
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clicked Report A Bug'),
          ),
        ),
      );

  Widget _buildSendFeedback(BuildContext context) => SimpleSettingsTile(
        title: 'Send Feedback',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.thumb_up_alt_outlined,
          color: Colors.purple,
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clicked Send Feedback'),
          ),
        ),
      );

  _showOpenDialogDeletion(context) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAccountPopUp();
      },
    );
  }
}

/*
    Class to Display the Header of the Settings Screen
 */
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: !ExecutingDevice.isDesktop(context)
                  ? IconButton(
                      highlightColor: Colors.transparent,
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                          MainScreen.routeName,
                        );
                      },
                      padding: const EdgeInsets.only(
                        left: defaultPadding / 2,
                        right: defaultPadding,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ],
    );
  }
}
