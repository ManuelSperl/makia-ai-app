import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as flutterSettings;

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/providers/auth.dart';
import 'package:makia_ai/providers/camera_list.dart';
import 'package:makia_ai/providers/drawer_provider.dart';
import 'package:makia_ai/screens/cameras/camera_detail_screen.dart';
import 'package:makia_ai/screens/cameras/cameras_screen.dart';
import 'package:makia_ai/screens/locations/locations_screen.dart';
import 'package:makia_ai/screens/authentification/log_in_screen.dart';
import 'package:makia_ai/screens/main_screen.dart';
import 'package:makia_ai/screens/settings/settings_screen.dart';
import 'package:makia_ai/screens/authentification/sign_up_screen.dart';
import 'package:makia_ai/screens/settings/user_settings_screen.dart';
import 'package:makia_ai/screens/splash_screen.dart';
import 'package:makia_ai/screens/authentification/welcome_screen.dart';
import 'package:makia_ai/widgets/search_field.dart';

Future main() async {
  await flutterSettings.Settings.init(cacheProvider: flutterSettings.SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();

  // deactivates Landscape-Mode on the Devices
  services.SystemChrome.setPreferredOrientations([
    services.DeviceOrientation.portraitUp,
    services.DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DrawerProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CameraList(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CameraSearch(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => flutterSettings.ValueChangeObserver<bool>(
          cacheKey: SettingsScreen.keyDarkMode,
          defaultValue: true, // -> darkMode defaultValue
          builder: (_, isDarkMode, __) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Makia AI',
            theme: isDarkMode
                ? ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: darkModeBgColor,
                    accentColor: primaryColor,
                    errorColor: errorColor,
                    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
                      bodyColor: Colors.white,
                    ),
                    canvasColor: darkModeSecondaryColor,
                  )
                : ThemeData.light().copyWith(
                    scaffoldBackgroundColor: lightModeBgColor,
                    accentColor: primaryColor,
                    errorColor: errorColor,
                    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
                      bodyColor: lightModeTextColor,
                    ),
                    canvasColor: lightModeSecondaryColor,
                  ),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : WelcomeScreen(),
                  ),
            routes: {
              MainScreen.routeName: (ctx) => MainScreen(),
              LocationsScreen.routeName: (ctx) => LocationsScreen(),
              CamerasScreen.routeName: (ctx) => CamerasScreen(),
              CameraDetailScreen.routeName: (ctx) => CameraDetailScreen(),
              SettingsScreen.routeName: (ctx) => SettingsScreen(),
              SignUpScreen.routeName: (ctx) => SignUpScreen(),
              LogInScreen.routeName: (ctx) => LogInScreen(),
              UserSettingsScreen.routeName: (ctx) => UserSettingsScreen(),
            },
          ),
        ),
      ),
    );
  }
}
