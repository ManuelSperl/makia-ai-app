import 'package:flutter/material.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/screens/main_screen.dart';
import 'package:makia_ai/widgets/cameras/available_cameras.dart';
import 'package:makia_ai/widgets/main_drawer.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Camera Screen of the App
 */
class CamerasScreen extends StatelessWidget {
  static const routeName = "/cameras-screen";

  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map; // gives us the arguments

    if (arguments == null) print("No Arguments passed!");

    final selectedProject = arguments['project'];
    final selectedLocation = arguments['location'];

    print(selectedProject + " | " + selectedLocation);

    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Drawer should only be opened constantly on Desktops
            if (ExecutingDevice.isDesktop(context))
              Expanded(
                // default flex = 1 -> takes 1/6 of the screen space
                child: MainDrawer(),
              ),
            Expanded(
              flex: 5, // takes 5/6 of the screen space
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  defaultPadding,
                ),
                child: Column(
                  children: [
                    Header(
                      currentLocation: selectedLocation,
                    ),
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
                                  AvailableCameras(
                                    selectedProject: selectedProject,
                                    selectedLocation: selectedLocation,
                                  ),
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
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
    Class to Display the Header of the Camera Screen
 */
class Header extends StatelessWidget {
  final String currentLocation;

  Header({
    this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!ExecutingDevice.isDesktop(context))
          IconButton(
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.only(
              left: defaultPadding / 2,
              right: defaultPadding,
            ),
          ),
        Text(
          currentLocation,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.of(context).popAndPushNamed(
              MainScreen.routeName,
            );
          },
          padding: const EdgeInsets.only(
            left: defaultPadding / 2,
            right: defaultPadding,
          ),
        ),
      ],
    );
  }
}
