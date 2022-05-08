import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/providers/drawer_provider.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/widgets/projects/available_projects.dart';
import 'package:makia_ai/widgets/profile_card.dart';
import 'package:makia_ai/widgets/cameras/recent_cameras.dart';
import 'package:makia_ai/widgets/search_field.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Project Screen of the App
 */
class ProjectsScreen extends StatefulWidget {
  static const routeName = "/projects-screen";

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

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

  Future<void> _refreshData(BuildContext context) async {
    try {
      await Provider.of<CameraList>(context, listen: false).fetchAndSet();
    } catch (error) {
      _flushBar.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            AvailableProjects(),
                            const SizedBox(height: defaultPadding),
                            RecentCameras(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!ExecutingDevice.isMobile(context)) const SizedBox(width: defaultPadding),
                  if (!ExecutingDevice.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: (MediaQuery.of(context).size.height),
                        decoration: BoxDecoration(
                          color: isDarkMode ? darkModeSecondaryColor : lightModeSecondaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/makiaAI_name_vertical.png',
                          height: (MediaQuery.of(context).size.height),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
    Class to Display the Header of the Project Screen
 */
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!ExecutingDevice.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<DrawerProvider>().controlDrawer,
            padding: const EdgeInsets.only(
              right: defaultPadding,
            ),
          ),
        if (!ExecutingDevice.isMobile(context))
          Text(
            "Makia AI",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!ExecutingDevice.isMobile(context)) Spacer(flex: ExecutingDevice.isDesktop(context) ? 2 : 1),
        SearchField(),
        ProfileCard()
      ],
    );
  }
}
