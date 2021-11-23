import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nestless/utils/config.dart';
import 'package:nestless/views/login_page.dart';

void main() async {
  await Hive.initFlutter();
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
      print("Theme Change Detected");
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
        primarySwatch: Colors.lightGreen,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightGreen,
        primaryColor: Colors.deepPurple[300],
      ),
      themeMode: setTheme.setTheme(),
      home: LoginPage(
        title: "LOGIN",
      ),
    );
  }
}
