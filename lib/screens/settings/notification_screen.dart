import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:makia_ai/screens/settings/notification_detail_screen.dart';
import 'package:makia_ai/widgets/icon_widget.dart';

/*
    Renders the Notification Screen of the App
 */
class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: 'Notifications',
      subtitle: 'Newsletter, App Updates',
      leading: IconWidget(
        icon: Icons.notifications_outlined,
        color: Colors.redAccent,
      ),
      child: NotificationDetailScreen(),
    );
  }
}
