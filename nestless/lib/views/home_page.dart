import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/top_bar.dart';

import 'package:nestless/views/search_page.dart';
import 'package:nestless/views/profile_page.dart';
import 'package:nestless/views/add_bird_page.dart';
import 'package:nestless/views/settings_page.dart';

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

  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      ProfilePage(
        auth: widget.auth,
        uid: widget.userId,
      ),
      SearchPage(
        auth: widget.auth,
        uid: widget.userId,
      ),
      AddBirdPage(
        auth: widget.auth,
        uid: widget.userId,
      ),
      SettingsPage(
        auth: widget.auth,
        userId: widget.userId,
        onSignedOut: widget.onSignedOut,
        onSignedIn: widget.onSignedIn,
      ),
    ];
    return Scaffold(
      appBar: TopBar(
        title: 'HOME',
        appBar: AppBar(),
        auth: widget.auth,
        onSignOut: widget.onSignedOut,
        userId: widget.userId,
        onSignIn: widget.onSignedIn,
        hasSignOut: false,
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
