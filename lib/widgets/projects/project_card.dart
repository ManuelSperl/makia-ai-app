import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/locations/locations_screen.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/icon_card.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Project-Card Widget
 */
class ProjectCard extends StatelessWidget {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  final String selectedProject;

  ProjectCard({
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    final camerasData = Provider.of<CameraList>(context);
    final camerasList = camerasData.cameras;

    var numberOfAvailableLocations = 0;
    var locationsListForProject = [];

    for (var i = 0; i < camerasList.length; i++) {
      if (camerasList[i].project == selectedProject) {
        if (!locationsListForProject.contains(camerasList[i].location)) {
          locationsListForProject.add(camerasList[i].location);
        }
      }
    }

    numberOfAvailableLocations = locationsListForProject.length;

    //print("Locations for this Project: $locationsListForProject");
    //print("Available Locations: $numberOfAvailableLocations");
    //print("\n");

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          LocationsScreen.routeName,
          arguments: selectedProject,
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
                  icon: Icons.villa_outlined,
                  iconColor: primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: isDarkMode ? Colors.white54 : lightModeTextColor,
                  tooltip: 'Helper-Text',
                  onPressed: () {},
                ),
              ],
            ),
            Text(
              selectedProject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Divider(
              color: primaryColor.withOpacity(0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (ExecutingDevice.isDesktop(context)) ? "Number of Locations:" : "Numb. Locations:",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: isDarkMode ? Colors.white70 : lightModeTextColor,
                      ),
                ),
                Text(
                  "${numberOfAvailableLocations}",
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
