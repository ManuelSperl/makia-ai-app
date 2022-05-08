import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:makia_ai/screens/settings/account_detail_screen.dart';
import 'package:makia_ai/widgets/icon_widget.dart';

/*
    Renders the Account Screen of the App
 */
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Account Setting',
      subtitle: 'Privacy, Security, Language',
      leading: IconWidget(
        icon: Icons.person_outline,
        color: Colors.green,
      ),
      child: AccountDetailScreen(),
    );
  }
}
