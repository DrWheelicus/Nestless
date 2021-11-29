import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/utils/config.dart';
import 'package:nestless/views/start_page.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

void main() async {
  // Initialize Firebase and Hive before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  // Open the Hive box to store the user's data
  box = await Hive.openBox("Nestless");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Check current theme of the app and log if changed
    setTheme.addListener(() {
      log("Theme Change Detected");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nestless',
      debugShowCheckedModeBanner: false,
      // Themes for the app
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: Colors.green[300],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple[300],
      ),
      // Check config for the current theme
      themeMode: setTheme.setTheme(),
      // Play startup animation
      home: SplashScreen.navigate(
        name: 'assets/animations/feather.riv',
        // After animation is finished, start the app
        next: (context) => StartPage(
          auth: Auth(),
        ),
        until: () => Future.delayed(const Duration(seconds: 1)),
        // Load the animation from the assets
        startAnimation: 'Animation 1',
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
