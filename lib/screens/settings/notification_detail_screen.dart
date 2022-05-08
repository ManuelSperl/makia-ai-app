import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/icon_widget.dart';
import 'package:makia_ai/widgets/main_drawer.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart' as mySettingsScreen;

/*
    Renders the Notification-Detail Screen of the App
 */
class NotificationDetailScreen extends StatelessWidget {
  final isDarkMode = Settings.getValue(mySettingsScreen.SettingsScreen.keyDarkMode, true);

  static const keyNews = 'key-news';
  static const keyActivity = 'key-activity';
  static const keyNewsletter = 'key-newsletter';
  static const keyAppUpdates = 'key-appUpdates';

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
                    const SizedBox(height: defaultPadding),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsGroup(
                          title: 'General',
                          children: [
                            _buildNews(),
                            _buildActivity(),
                            _buildNewsletter(),
                            _buildAppUpdates(),
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

  Widget _buildNews() => SwitchSettingsTile(
        settingKey: keyNews,
        title: 'News for you',
        leading: IconWidget(
          icon: Icons.message_outlined,
          color: primaryColor,
        ),
      );

  Widget _buildActivity() => SwitchSettingsTile(
        settingKey: keyActivity,
        title: 'Account Activity',
        leading: IconWidget(
          icon: Icons.person_outline,
          color: Colors.orangeAccent,
        ),
      );

  Widget _buildNewsletter() => SwitchSettingsTile(
        settingKey: keyNewsletter,
        title: 'Newsletter',
        leading: IconWidget(
          icon: Icons.text_snippet_outlined,
          color: Colors.redAccent,
        ),
      );

  Widget _buildAppUpdates() => SwitchSettingsTile(
        settingKey: keyAppUpdates,
        title: 'App Updates',
        leading: IconWidget(
          icon: Icons.update,
          color: Colors.greenAccent,
        ),
      );
}

/*
    Class to Display the Header of the Notification Detail Screen
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
                'Notifications',
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
                        Navigator.of(context).pop();
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
