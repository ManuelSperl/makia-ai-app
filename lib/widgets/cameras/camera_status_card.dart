import 'package:flutter/material.dart';

import 'package:makia_ai/models/camera.dart';

/*
    Renders the Camera-Status-Card Widget
 */
class CameraStatusCard extends StatelessWidget {
  final Camera selectedCamera;

  const CameraStatusCard({
    this.selectedCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 85,
      decoration: BoxDecoration(
        border: Border.all(
          color: _setBorderColor(selectedCamera.status),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          selectedCamera.status,
          style: TextStyle(
            color: _setBorderColor(selectedCamera.status),
          ),
        ),
      ),
    );
  }

  Color _setBorderColor(String cameraStatus) {
    if (cameraStatus == 'ONLINE') {
      return Colors.green;
    }
    if (cameraStatus == 'WARNING') {
      return Colors.orange;
    }
    if (cameraStatus == 'OFFLINE') {
      return Colors.red;
    }
    if (cameraStatus == 'MOVED') {
      return Colors.purpleAccent;
    }

    return Colors.white;
  }
}
