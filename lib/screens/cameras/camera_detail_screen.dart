import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/screens/main_screen.dart';
import 'package:makia_ai/widgets/cameras/camera_status_card.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';

/*
    Renders the Camera-Detail Screen of the App
 */
class CameraDetailScreen extends StatefulWidget {
  static const routeName = "/camera-detail-screen";

  @override
  State<CameraDetailScreen> createState() => _CameraDetailScreenState();
}

class _CameraDetailScreenState extends State<CameraDetailScreen> {
  final isDarkMode = flutterSettings.Settings.getValue(SettingsScreen.keyDarkMode, true);
  var _isInit = true;
  Map arguments;
  Camera selectedCamera;
  bool returnToHomeScreen;

  @override
  void didChangeDependencies() {
    // only executes the following on init, and is needed because of the context for the arguments
    if (_isInit) {
      arguments = ModalRoute.of(context).settings.arguments as Map; // gives us the arguments
      selectedCamera = arguments['selectedCamera'];
      returnToHomeScreen = arguments['returnToHomeScreen'];

      if (selectedCamera == null) print("No Arguments passed!");

      if (selectedCamera.status == 'ONLINE') {
        // starts the refresh-timer for the Camera Image Refresher, when the Status is ONLINE
        _timerForRefresh();
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _timerForRefresh() {
    // 3750 Milliseconds == 3,75 Seconds
    Future.delayed(Duration(milliseconds: 3750)).then((_) {
      setState(() {
        print("Executing Image-Refresh");
      });
      _timerForRefresh();
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    String jwt_token = Provider.of<CameraList>(context, listen: false).getJwtToken;
    // print("JWT_TOKEN: $jwt_token");

    Provider.of<CameraList>(context, listen: false).addToRecentCamerasList(selectedCamera);

    Image _offlineImage = Image.asset(
      'assets/images/image_not_available.png',
      height: !ExecutingDevice.isDesktop(context)
          ? MediaQuery.of(context).size.height * (2 / 8.3)
          : MediaQuery.of(context).size.height * (1.5 / 1.8),
      fit: BoxFit.cover,
    );

    var _projectText = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle1,
        children: <TextSpan>[
          TextSpan(
            text: "Project:  ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          TextSpan(
            text: selectedCamera.project,
          ),
        ],
      ),
    );

    var _locationText = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle1,
        children: <TextSpan>[
          TextSpan(
            text: "Location:  ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          TextSpan(
            text: selectedCamera.location,
          ),
        ],
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: defaultPadding,
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: Column(
                children: [
                  Header(
                    currentCamera: selectedCamera,
                    returnToHomeScreen: returnToHomeScreen,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDarkMode ? TinyColor(darkModeSecondaryColor).lighten(1).color : lightModeSecondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: defaultPadding * 1.25),
                        Container(
                          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                          child: Text(
                            "Video-Camera Feed:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding / 1.75),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: selectedCamera.status == 'ONLINE'
                              ? _buildOnlineImage(selectedCamera, jwt_token, context)
                              : _offlineImage,
                        ),
                        const SizedBox(height: defaultPadding),
                        Container(
                          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Camera Status:  ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: primaryColor,
                                ),
                              ),
                              CameraStatusCard(
                                selectedCamera: selectedCamera,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        Container(
                          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                          child: Align(
                            child: _projectText,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        Container(
                          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                          child: Align(
                            child: _locationText,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        ComponentList(
                          selectedCamera: selectedCamera,
                        ),
                        const SizedBox(height: defaultPadding * 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image _buildOnlineImage(Camera selectedCamera, String token, BuildContext context) {
    String url = selectedCamera.imageURL + '?v=${Random().nextInt(1000)}';

    return Image.network(
      url,
      gaplessPlayback: true,
      headers: {
        "Authorization": "Bearer " + token,
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Image.asset(
          'assets/images/image_not_available.png',
          height: !ExecutingDevice.isDesktop(context)
              ? MediaQuery.of(context).size.height * (2 / 8.3)
              : MediaQuery.of(context).size.height * (1.5 / 1.8),
          fit: BoxFit.cover,
        );
      },
      height: !ExecutingDevice.isDesktop(context)
          ? MediaQuery.of(context).size.height * (2 / 8.3)
          : MediaQuery.of(context).size.height * (1.5 / 1.8),
      fit: BoxFit.cover,
    );
  }
}

/*
    Class to Display the ComponentList of a Camera
 */
class ComponentList extends StatelessWidget {
  final Camera selectedCamera;

  ComponentList({
    this.selectedCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
          child: Text(
            "Components: ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
        ),
        selectedCamera.components.isNotEmpty
            ? Column(
                children: <Widget>[
                  for (int i = 0; i < selectedCamera.components.length; i++)
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                          child: Text(
                            '        •  ${selectedCamera.components[i].componentName}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        selectedCamera.components[i].notes != null &&
                                selectedCamera.components[i].notes.isNotEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                                child: Text(
                                  '                Notes:  ${selectedCamera.components[i].notes}',
                                ),
                              )
                            : const SizedBox(),
                        selectedCamera.components[i].buyDate != null && selectedCamera.components[i].buyDate.isNotEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                                child: Text(
                                  '                BuyDate:  ${_formatedDate(selectedCamera.components[i].buyDate)}',
                                ),
                              )
                            : const SizedBox(),
                        selectedCamera.components[i].montageDate != null && selectedCamera.components[i].montageDate.isNotEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                                child: Text(
                                  '                MontageDate:  ${_formatedDate(selectedCamera.components[i].montageDate)}',
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width - (defaultPadding * 2),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "No Components installed!",
                  ),
                ),
              )
      ],
    );
  }

  /// Method to formate the Date, given by the Backend
  String _formatedDate(String buyDate) {
    String formatedDate;

    formatedDate = buyDate.substring(0, buyDate.indexOf('T'));
    formatedDate = formatedDate.replaceAll('-', '.');
    formatedDate = formatedDate.split('.').reversed.join('.');

    return formatedDate;
  }
}

/*
    Class to Display the Header of the Camera Detail Screen
 */
class Header extends StatelessWidget {
  final Camera currentCamera;
  final bool returnToHomeScreen;

  Header({
    this.currentCamera,
    this.returnToHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (returnToHomeScreen == true) {
              Navigator.of(context).popAndPushNamed(
                MainScreen.routeName,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          padding: const EdgeInsets.only(
            left: defaultPadding / 2,
            right: defaultPadding,
          ),
        ),
        Text(
          currentCamera.deviceName,
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
