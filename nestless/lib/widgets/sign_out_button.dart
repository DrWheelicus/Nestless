import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';

class SignOutButton extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  const SignOutButton({Key? key, required this.auth, required this.onSignedOut})
      : super(key: key);

  @override
  _SignOutButtonState createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
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
        _signOut();
      },
      icon: const Icon(Icons.exit_to_app, color: Colors.white),
      label: const Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
