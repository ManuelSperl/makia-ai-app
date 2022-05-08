import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/locations/location_card.dart';

/*
    Class displaying the Available Locations
 */
class AvailableLocations extends StatelessWidget {
  final String selectedProject;

  AvailableLocations({
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    final camerasData = Provider.of<CameraList>(context);
    final camerasList = camerasData.cameras;
    final Size _size = MediaQuery.of(context).size;

    var headerText = RichText(
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        //       And Child text spans will inherit styles from parent
        style: Theme.of(context).textTheme.subtitle1,
        children: <TextSpan>[
          TextSpan(
            text: "${selectedProject}'s ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          TextSpan(text: 'available Locations:'),
        ],
      ),
    );

    return Column(
      children: [
        // Begin of the Subheader
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
              ),
              child: headerText,
            ),
          ],
        ),
        const SizedBox(height: defaultPadding), // End of the Subheader
        ExecutingDevice(
          mobile: ProjectsCardGridView(
            cameraList: camerasList,
            crossAxisCount: _size.width < 650 ? 1 : 4,
            childAspectRatio: _size.width < 650 ? 2.9 : 1.3,
            selectedProject: selectedProject,
          ),
          desktop: ProjectsCardGridView(
            cameraList: camerasList,
            childAspectRatio: _size.width < 1400 ? 1.1 : 2.5,
            selectedProject: selectedProject,
          ),
        )
      ],
    );
  }
}

/*
    Renders the Projects-Card-Grid-View Widget
 */
class ProjectsCardGridView extends StatelessWidget {
  final List<Camera> cameraList;
  final int crossAxisCount;
  final double childAspectRatio;
  final String selectedProject;

  const ProjectsCardGridView({
    this.cameraList,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    final List locationsList = [];

    for (var i = 0; i < cameraList.length; i++) {
      if (!locationsList.contains(cameraList[i].location) && cameraList[i].location != null) {
        if (selectedProject == cameraList[i].project) {
          locationsList.add(cameraList[i].location);
        }
      }
    }
    //print('Available Locations: $locationsList');

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: locationsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (ctx, index) => LocationCard(
        selectedLocation: locationsList[index] ?? 'No Location Name set',
        selectedProject: selectedProject,
      ),
    );
  }
}
