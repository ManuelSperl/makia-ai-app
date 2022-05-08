import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/cameras/camera_detail_screen.dart';
import 'package:makia_ai/widgets/icon_card.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Recent-Cameras Widget
 */
class RecentCameras extends StatefulWidget {
  @override
  State<RecentCameras> createState() => _RecentCamerasState();
}

class _RecentCamerasState extends State<RecentCameras> {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  static List<Camera> recentCameras;

  DataRow _buildRecentCamerasDataRow(Camera recentCamera) {
    return DataRow(
      onSelectChanged: (bool selected) {
        if (selected) {
          Navigator.of(context).pushNamed(
            CameraDetailScreen.routeName,
            arguments: {
              'selectedCamera': recentCamera,
              'returnToHomeScreen': true,
            },
          );
        }
      },
      cells: [
        DataCell(
          Row(
            children: [
              IconCard(
                height: 30,
                width: 30,
                cardColor: primaryColor.withOpacity(0.8),
                borderRadius: 5,
                icon: Icons.videocam_outlined,
                iconColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                ),
                child: Text(recentCamera.project ?? 'null'),
              )
            ],
          ),
        ),
        DataCell(
          Text(recentCamera.location ?? 'null'),
        ),
        DataCell(
          Text(recentCamera.deviceName ?? 'null'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    recentCameras = Provider.of<CameraList>(context, listen: false).getRecentCameras;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Cameras',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              columnSpacing: defaultPadding,
              horizontalMargin: 0.0,
              columns: [
                DataColumn(
                  label: Text(
                    'Project',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Location',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Camera',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              rows: List.generate(
                recentCameras.length,
                (index) => _buildRecentCamerasDataRow(recentCameras[index]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
