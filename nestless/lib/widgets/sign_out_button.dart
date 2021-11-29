import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/views/login_page.dart';
import 'package:page_transition/page_transition.dart';

class SignOutButton extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final String userId;

  const SignOutButton(
      {Key? key,
      required this.auth,
      required this.onSignedOut,
      required this.userId,
      required this.onSignedIn})
      : super(key: key);

  @override
  _SignOutButtonState createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  // Sign out the user
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Sign out the user
        _signOut();
        // Navigate to the login page
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.topToBottom,
                child: LoginPage(
                    title: 'LOGIN',
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    isLinkLogin: false,
                    userId: widget.userId,
                    onSignedIn: widget.onSignedIn)));
      },
      icon: const Icon(Icons.exit_to_app, color: Colors.white),
      label: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
