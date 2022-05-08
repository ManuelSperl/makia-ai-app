import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/icon_widget.dart';
import 'package:makia_ai/widgets/main_drawer.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart' as mySettingsScreen;

/*
    Renders the Account-Detail Screen of the App
 */
class AccountDetailScreen extends StatelessWidget {
  final isDarkMode = Settings.getValue(mySettingsScreen.SettingsScreen.keyDarkMode, true);

  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';

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
                            const SizedBox(height: defaultPadding),
                            _buildAccountInformation(context),
                            const SizedBox(height: defaultPadding),
                            _buildPrivacy(context),
                            _buildSecurity(context),
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

  Widget _buildAccountInformation(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width - defaultPadding,
        color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: 10,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Language',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'English',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: 4,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Location',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Austria',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildPrivacy(BuildContext context) => SimpleSettingsTile(
        title: 'Privacy',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.lock_outline,
          color: primaryColor,
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clicked Privacy'),
          ),
        ),
      );

  Widget _buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: 'Security',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.security_outlined,
          color: Colors.red,
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clicked Security'),
          ),
        ),
      );
}

/*
    Class to Display the Header of the Account Detail Screen
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
                'Account Settings',
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
