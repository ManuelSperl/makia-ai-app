import 'package:flutter/material.dart';

/*
    Provides and manages the App Drawer
 */
class DrawerProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> _scaffoldKey;

  /// Returns the scaffoldKey
  GlobalKey<ScaffoldState> get scaffoldKey {
    return _scaffoldKey;
  }

  /// Method to set the [scaffoldKey] to the overall _scaffoldKey of the App
  void setScaffoldKey(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
  }

  /// Method which opens the App Drawer
  void controlDrawer() {
    if (!_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openDrawer();
    }
  }
}
