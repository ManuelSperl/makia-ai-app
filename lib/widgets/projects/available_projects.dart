import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/loading_dialog.dart';
import 'package:makia_ai/widgets/projects/project_card.dart';
import 'package:makia_ai/widgets/authentification/server_verification_pop_up.dart';

/*
    Class displaying the Available Projects
 */
class AvailableProjects extends StatefulWidget {
  @override
  State<AvailableProjects> createState() => _AvailableProjectsState();
}

class _AvailableProjectsState extends State<AvailableProjects> {

  final _flushBar = Flushbar(
    backgroundColor: Colors.redAccent,
    title: 'Error',
    message: 'Something with the Server-Request went wrong!',
    duration: Duration(seconds: 6),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(defaultPadding),
    padding: const EdgeInsets.all(10.5),
  );

  @override
  Widget build(BuildContext context) {
    final camerasData = Provider.of<CameraList>(context);
    final camerasList = camerasData.cameras;
    final Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Begin of the Subheader with the Refresh-Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Projects',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical: defaultPadding / (ExecutingDevice.isMobile(context) ? 2 : 1),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: () {
                _showLoadingSpinnerWhileLoading();
              },
            ),
          ],
        ),
        SizedBox(height: defaultPadding), // End of the Subheader
        camerasList.isEmpty // check if we have already fetched data before
            ? Padding(
                padding: const EdgeInsets.only(
                  left: defaultPadding * 1.5,
                  right: defaultPadding * 1.5,
                  top: defaultPadding * 1.5,
                  bottom: defaultPadding * 2,
                ),
                child: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / (ExecutingDevice.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text('Server Verification'),
                  onPressed: () {
                    _getServerData();
                  },
                ),
              )
            : ExecutingDevice(
                mobile: ProjectsCardGridView(
                  cameraList: camerasList,
                  crossAxisCount: _size.width < 650 ? 2 : 4,
                  childAspectRatio: _size.width < 650 ? 1.1 : 1.3,
                ),
                desktop: ProjectsCardGridView(
                  cameraList: camerasList,
                  childAspectRatio: _size.width < 1400 ? 1.1 : 1.5,
                ),
              )
      ],
    );
  }

  _getServerData() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('serverData')) {
      _showLoadingSpinnerWhileLoading();
    } else {
      // show Server Verification Dialog to type your Data in
      _showOpenDialog(context);
    }
  }

  Future<void> _showLoadingSpinnerWhileLoading() async {
    BuildContext dialogContext;

    try {
      // Based on the dialogContext, show the CircularProgressIndicator and pop it afterwards
      showDialog(
        context: context,
        barrierDismissible: false, // prevents outside touch
        builder: (BuildContext context) {
          dialogContext = context;
          return LoadingDialog();
        },
      );

      await Provider.of<CameraList>(context, listen: false).fetchAndSet().then((_) {
        Navigator.pop(dialogContext); // pops the dialogContext
      });
    } catch (error) {
      Navigator.pop(dialogContext); // pops the dialogContext

      _flushBar.show(context);
    }
  }

  _showOpenDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return ServerVerificationPopUp();
      },
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

  const ProjectsCardGridView({
    this.cameraList,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    final List projectsList = [];

    for (var i = 0; i < cameraList.length; i++) {
      if (!projectsList.contains(cameraList[i].project) && cameraList[i].project != null) {
        projectsList.add(cameraList[i].project);
      }
    }
    //print('Available Projects: $projectsList');

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: projectsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (ctx, index) => ProjectCard(
        selectedProject: projectsList[index] ?? 'No Project Name set',
      ),
    );
  }
}
