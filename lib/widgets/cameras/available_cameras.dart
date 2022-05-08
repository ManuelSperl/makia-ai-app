import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/cameras/camera_card.dart';

/*
    Class displaying the Available Cameras
 */
class AvailableCameras extends StatelessWidget {
  final String selectedProject;
  final String selectedLocation;

  AvailableCameras({
    this.selectedProject,
    this.selectedLocation,
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
            text: "${selectedLocation}'s ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          TextSpan(text: 'available Cameras:'),
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
          mobile: CamerasCardGridView(
            cameraList: camerasList,
            crossAxisCount: _size.width < 650 ? 1 : 4,
            childAspectRatio: _size.width < 650 ? 2.9 : 1.3,
            selectedProject: selectedProject,
            selectedLocation: selectedLocation,
          ),
          desktop: CamerasCardGridView(
            cameraList: camerasList,
            childAspectRatio: _size.width < 1400 ? 1.1 : 2.5,
            selectedProject: selectedProject,
            selectedLocation: selectedLocation,
          ),
        )
      ],
    );
  }
}

/*
    Renders the Camera-Card-Grid-View Widget
 */
class CamerasCardGridView extends StatelessWidget {
  final List<Camera> cameraList;
  final int crossAxisCount;
  final double childAspectRatio;
  final String selectedProject;
  final String selectedLocation;

  const CamerasCardGridView({
    this.cameraList,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
    this.selectedProject,
    this.selectedLocation,
  });

  @override
  Widget build(BuildContext context) {
    final List<Camera> availableCamerasList = [];

    for (var i = 0; i < cameraList.length; i++) {
      if (!availableCamerasList.contains(cameraList[i].deviceName)) {
        if (selectedProject == cameraList[i].project && selectedLocation == cameraList[i].location) {
          if (cameraList[i] != null) {
            availableCamerasList.add(cameraList[i]);
            print(cameraList[i].deviceName);
          }
        }
      }
    }
    //print('Available Cameras: $availableCamerasList');

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: availableCamerasList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (ctx, index) => CameraCard(
        selectedCamera: availableCamerasList[index] ?? 'No Camera Name set',
        selectedProject: selectedProject,
      ),
    );
  }
}
