import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/top_bar.dart';

import 'package:nestless/views/search_page.dart';
import 'package:nestless/views/profile_page.dart';
import 'package:nestless/views/add_bird_page.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final VoidCallback onSignedIn;

  const HomePage(
      {Key? key,
      required this.auth,
      required this.onSignedOut,
      required this.userId,
      required this.onSignedIn})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*ProfilePage(),*/ /*SearchPage(),*/ /*AddBirdPage(),*/ /*SettingsPage()*/
  final List<Widget> _pages = [
    const ProfilePage(id: "colinator0@hotmail.com"), const SearchPage(), const AddBirdPage(), const SearchPage()
  ];
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'HOME',
        appBar: AppBar(),
        auth: widget.auth,
        onSignOut: widget.onSignedOut,
        userId: widget.userId,
        onSignIn: widget.onSignedIn,
        hasSignOut: true,
        hasBack: false,
      ),
      body: Center(
        child: _pages[_pageIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 50.0,
        items: const <Widget>[
          Icon(Icons.portrait_rounded, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Theme.of(context).bottomAppBarColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).canvasColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          log("Page $index");
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
