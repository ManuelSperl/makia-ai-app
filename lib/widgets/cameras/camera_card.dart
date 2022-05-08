import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/screens/cameras/camera_detail_screen.dart';
import 'package:makia_ai/widgets/cameras/camera_status_card.dart';
import 'package:makia_ai/widgets/icon_card.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Camera-Card Widget
 */
class CameraCard extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  final Camera selectedCamera;
  final String selectedProject;

  CameraCard({
    this.selectedCamera,
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          CameraDetailScreen.routeName,
          arguments: {
            'selectedCamera': selectedCamera,
            'returnToHomeScreen': false,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconCard(
                  height: 40,
                  width: 40,
                  cardColor: primaryColor.withOpacity(0.1),
                  borderRadius: defaultRadius,
                  icon: Icons.videocam_outlined,
                  iconColor: primaryColor,
                ),
                Text(
                  selectedCamera.deviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CameraStatusCard(
                  selectedCamera: selectedCamera,
                ),
              ],
            ),
            Divider(
              color: primaryColor.withOpacity(0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Superior Project:",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: isDarkMode ? Colors.white70 : lightModeTextColor,
                      ),
                ),
                Text(
                  selectedProject,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: isDarkMode ? Colors.white : lightModeTextColor,
                      ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
