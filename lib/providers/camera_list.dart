import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:makia_ai/models/http_exception.dart';
import 'package:makia_ai/models/camera.dart';
import 'package:makia_ai/models/component.dart';

/*
    Provides and manages a list of Cameras
 */
class CameraList with ChangeNotifier {
  var jwt_token;
  List<Camera> _recentCameras = [];
  List<Camera> _cameras = [
    // Camera(
    //   deviceName: 'Camera 1',
    //   project: 'ÖBB-Zugkreuzung',
    //   location: 'Seewalchen',
    //   imageURL: 'https://health.api.makia.ml/device/cba67193-daa5-4f69-bbd8-ee0601c008d0/image',
    //   status: "ONLINE",
    //   components: [
    //     Component(
    //       componentName: "Raspbery Pi 4",
    //       notes: "Semaf Electronics",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //     Component(
    //       componentName: "Raspi Cam HQ",
    //       notes: "Semaf Electronics",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //     Component(
    //       componentName: "Raspi Cam HQ 6mm Objektiv",
    //       notes: "Semaf Electronics",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //     Component(
    //       componentName: "Gehäuse - weiß - klein - Ring",
    //       notes: "Semaf Electronics",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //     Component(
    //       componentName: "Gehäusehalterung (Eck)",
    //     ),
    //     Component(
    //       componentName: "Edge TPU",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //     Component(
    //       componentName: "Gehäusedichtung - weiß - klein",
    //       notes: "Semaf Electronics",
    //     ),
    //     Component(
    //       componentName: "Speicherkarte 32 GB",
    //       notes: "Semaf Electronics",
    //       buyDate: "2021-05-06T22:00:00.000Z",
    //       montageDate: "2021-05-17T22:00:00.000Z",
    //     ),
    //   ],
    // ),
    // Camera(
    //   deviceName: 'Camera 1',
    //   project: 'ÖBB-Zugkreuzung',
    //   location: 'Seekirchen',
    //   status: "OFFLINE",
    // ),
    // Camera(
    //   deviceName: 'Camera 2',
    //   project: 'ÖBB-Zugkreuzung',
    //   location: 'Seewalchen',
    //   status: "WARNING",
    // ),
    // Camera(
    //   deviceName: 'Camera 1',
    //   project: 'ÖBB-Zugkreuzung',
    //   location: 'Eugendorf',
    //   status: "OFFLINE",
    // ),
    // Camera(
    //   deviceName: 'Camera 2',
    //   project: 'Straßenkreuzung',
    //   location: 'Eugendorf',
    //   status: "ONLINE",
    //   imageURL: 'https://health.api.makia.ml/device/cba67193-daa5-4f69-bbd8-ee0601c008d0/image',
    // ),
    // Camera(
    //   deviceName: 'Camera 3',
    //   project: 'Straßenkreuzung',
    //   location: 'Eugendorf',
    //   status: "MOVED",
    // ),
    // Camera(
    //   deviceName: 'Camera 1',
    //   project: 'Straßenkreuzung',
    //   location: 'Obertrum',
    //   status: "OFFLINE",
    // ),
  ];

  /// Returns the list of Cameras
  List<Camera> get cameras {
    return [..._cameras];
  }

  /// Returns a list containing the last selected Cameras
  List<Camera> get getRecentCameras {
    return [..._recentCameras];
  }

  /// Returns the jwt-token of the Server Authentification
  String get getJwtToken {
    return jwt_token;
  }

  /// Method which adds [currentCamera] to the list of recent Cameras
  void addToRecentCamerasList(Camera currentCamera) {
    if (!_recentCameras.contains(currentCamera)) {
      _recentCameras.insert(0, currentCamera);
    } else {
      _recentCameras.remove(currentCamera);
      _recentCameras.insert(0, currentCamera);
    }
  }

  /// Method to clear the list of Cameras
  void clearCameraList() {
    _cameras.clear();
  }

  /// Method sets [serverUsername] and [serverPassword] to the Shared Preferences, to access them later
  Future<void> setUsernameAndPassword(String serverUsername, String serverPassword) async {
    final prefs = await SharedPreferences.getInstance();

    final serverData = json.encode({
      'username': serverUsername,
      'password': serverPassword,
    });

    // Store userData in the Preferences, to access it later
    prefs.setString('serverData', serverData);
  }

  /// Method which send the POST-Request to the Backend, to get the jwt-token
  /// which is used to authenticate the user on the server of the backend
  Future<String> postRequest() async {
    final login_url = Uri.parse('https://health.api.makia.ml/login');
    final prefs = await SharedPreferences.getInstance();
    Map bodyData;

    if (prefs.containsKey('serverData')) {
      final extractedServerData = json.decode(prefs.getString('serverData')) as Map<String, Object>;

      bodyData = {
        'username': extractedServerData['username'],
        'password': extractedServerData['password'],
      };

      print("Username: ${extractedServerData['username']}, and Password: ${extractedServerData['password']}");
    }

    //encode Map to JSON
    var body = json.encode(bodyData);

    var response = await http.post(
      login_url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode >= 400) {
      throw HttpException(message: 'Could not post-Request to Server didn\'t work!');
    }

    jwt_token = response.body;

    return response.body;
  }

  /// Method to reach the different backends by means of the specified [route]
  /// using the [jwt_token] for Authenficiation on the Server
  Future<List<dynamic>> getRequest(String route, String jwt_token) async {
    final url = Uri.parse('https://health.api.makia.ml${route}');

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + jwt_token,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode >= 400) {
      throw HttpException(message: 'Could not get (${route})\'s data!');
    }

    var jsonData = jsonDecode(response.body) as List<dynamic>;

    return jsonData;
  }

  /// Method to fetch and set all the Informations needed for the single Cameras
  Future<void> fetchAndSet() async {
    List<Camera> loadedCameras = [];

    try {
      var jwt_token = await postRequest();

      var deviceData = await getRequest('/device', jwt_token);

      for (int i = 0; i < deviceData.length; i++) {
        loadedCameras.add(
          Camera(
            locationId: deviceData[i]['locationId'],
            deviceName: deviceData[i]['name'],
            deviceId: deviceData[i]['_id'],
            status: deviceData[i]['status'],
            componentNames: [],
            components: [],
          ),
        );

        await fetchAndSetProjectData(loadedCameras, jwt_token);

        await fetchAndSetLocationData(loadedCameras, jwt_token);

        await fetchAndSetInventoryData(loadedCameras, jwt_token);
      }

      await fetchAndSetImageURL(loadedCameras);

      loadedCameras.forEach((element) {
        print("--------------------------------");
        print("Project    = ${element.project}");
        print("ProjectID  = ${element.projectId}");
        print("Location   = ${element.location}");
        print("LocationID = ${element.locationId}");
        print("DeviceName = ${element.deviceName}");
        print("DeviceID   = ${element.deviceId}");
        print("Status     = ${element.status}");
        print("ComponentN.= ${element.componentNames}");
        print("Image      = ${element.imageURL}");
        element.components.forEach((element) {
          print("ComponentName = ${element.componentName}");
          if (element.notes != null && element.notes != "") {
            print("   Notes       = ${element.notes}");
          }
          if (element.buyDate != null && element.buyDate != "") {
            print("   BuyDate     = ${element.buyDate}");
          }
          if (element.montageDate != null && element.montageDate != "") {
            print("   MontageDate = ${element.montageDate}");
          }
        });
      });

      // set the loaded-Cameras to the general Camera-List
      _cameras = loadedCameras;

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

  /// Method to fetch and set the Projects Data to the [loadedCameras] List
  Future<void> fetchAndSetProjectData(List<Camera> loadedCameras, String jwt_token) async {
    var projectData = await getRequest('/project', jwt_token);

    for (int i = 0; i < projectData.length; i++) {
      loadedCameras.forEach((element) {
        if (element.projectId == projectData[i]['_id']) {
          element.project = projectData[i]['name'];
        }
      });
    }
  }

  /// Method to fetch and set the Locations Data to the [loadedCameras] List
  Future<void> fetchAndSetLocationData(List<Camera> loadedCameras, String jwt_token) async {
    var locationData = await getRequest('/location', jwt_token);

    for (int i = 0; i < locationData.length; i++) {
      loadedCameras.forEach((element) {
        if (element.locationId == locationData[i]['_id']) {
          element.location = locationData[i]['name'];
          element.projectId = locationData[i]['projectId'];
        }
      });
    }
  }

  /// Method to fetch and set the Inventory Data to the [loadedCameras] List (of each single Cameras)
  Future<void> fetchAndSetInventoryData(List<Camera> loadedCameras, String jwt_token) async {
    var inventoryData = await getRequest('/inventory', jwt_token);

    for (int i = 0; i < inventoryData.length; i++) {
      loadedCameras.forEach((element) {
        if (element.deviceId == inventoryData[i]['deviceId']) {
          if (!element.componentNames.contains(inventoryData[i]['name'])) {
            element.componentNames.add(inventoryData[i]['name']);
          }

          if (element.components.length < element.componentNames.length) {
            element.components.add(Component(
              componentName: inventoryData[i]['name'],
              notes: inventoryData[i]['notes'],
              buyDate: inventoryData[i]['buyDate'],
              montageDate: inventoryData[i]['montageDate'],
            ));
          }
        }
      });
    }
  }

  /// Method to fetch and set the ImageURL to the [loadedCameras] List,
  /// of each single Camera, if the Camera-Status is ONLINE
  void fetchAndSetImageURL(List<Camera> loadedCameras) {
    loadedCameras.forEach((element) async {
      if (element.status == 'ONLINE') {
        element.imageURL = 'https://health.api.makia.ml/device/${element.deviceId}/image';
      }
    });
  }
}
