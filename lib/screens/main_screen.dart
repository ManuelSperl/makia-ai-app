import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:makia_ai/providers/drawer_provider.dart';
import 'package:makia_ai/executing_device.dart';
import 'package:makia_ai/screens/projects/projects_screen.dart';
import 'package:makia_ai/widgets/main_drawer.dart';

/*
    Renders the Main Screen of the App
 */
//ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  static const routeName = "/main-screen";

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldState');

  @override
  Widget build(BuildContext context) {
    Provider.of<DrawerProvider>(context, listen: false).setScaffoldKey(scaffoldKey);

    return Scaffold(
      key: context.read<DrawerProvider>().scaffoldKey,
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
              child: ProjectsScreen(),
            )
          ],
        ),
      ),
    );
  }
}
