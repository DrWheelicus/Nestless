import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/top_bar.dart';

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
          hasSignOut: true),
      body: const Center(
        child: Text('Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
