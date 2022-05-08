import 'package:flutter/material.dart';

/*
    Class to choose on which Device the App starts
 */
class ExecutingDevice extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  ExecutingDevice({
    @required this.mobile,
    @required this.desktop,
  });

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 850;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    if (_size.width >= 1100) {
      return desktop;
    }
    else {
      return mobile;
    }
  }
}
