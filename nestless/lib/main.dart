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
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
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
      themeMode: setTheme.setTheme(),
      home: SplashScreen.navigate(
        name: 'assets/animations/feather.riv',
        next: (context) => StartPage(
          auth: Auth(),
        ),
        until: () => Future.delayed(const Duration(seconds: 1)),
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
