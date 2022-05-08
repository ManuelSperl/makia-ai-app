import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/cameras/cameras_screen.dart';
import 'package:makia_ai/widgets/icon_card.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Location-Card Widget
 */
class LocationCard extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  final String selectedLocation;
  final String selectedProject;

  LocationCard({
    this.selectedLocation,
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    final camerasData = Provider.of<CameraList>(context);
    final camerasList = camerasData.cameras;

    var numberOfAvailableCameras = 0;
    var camerasListForProjectAndLocation = [];

    print("Location: $selectedLocation");

    for (var i = 0; i < camerasList.length; i++) {
      if (camerasList[i].project == selectedProject && camerasList[i].location == selectedLocation) {
        if (!camerasListForProjectAndLocation.contains(camerasList[i].deviceName)) {
          camerasListForProjectAndLocation.add(camerasList[i].deviceName);
        }
      }
    }

    numberOfAvailableCameras = camerasListForProjectAndLocation.length;

    print("Cameras for this Project/Location: $camerasListForProjectAndLocation");
    print("Number of Available Cameras: $numberOfAvailableCameras");
    print("\n");

    return GestureDetector(
      onTap: () {
        print(selectedLocation + " | " + selectedProject);
        Navigator.of(context).pushNamed(
          CamerasScreen.routeName,
          arguments: {
            'project': selectedProject,
            'location': selectedLocation,
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
                  icon: Icons.location_on_outlined,
                  iconColor: primaryColor,
                ),
                Text(
                  selectedLocation,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: isDarkMode ? Colors.white54 : lightModeTextColor,
                  tooltip: 'Helper-Text',
                  onPressed: () {},
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
                  "Number of Cameras:",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: isDarkMode ? Colors.white70 : lightModeTextColor,
                      ),
                ),
                Text(
                  "${numberOfAvailableCameras}",
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
