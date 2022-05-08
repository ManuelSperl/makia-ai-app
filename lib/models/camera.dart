import 'package:makia_ai/models/component.dart';

/*
    Represents an Camera
 */
class Camera {
  String project;
  String projectId;
  String location;
  String locationId;
  String deviceName;
  String deviceId;
  String status;
  String imageURL;
  List<String> componentNames = [];
  List<Component> components = [];

  Camera({
    this.project,
    this.projectId,
    this.location,
    this.locationId,
    this.deviceName,
    this.deviceId,
    this.status,
    this.imageURL,
    this.componentNames,
    this.components,
  });
}
