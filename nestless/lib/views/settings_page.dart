import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/theme_switch.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/widgets/sign_out_button.dart';

class SettingsPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final String userId;

  const SettingsPage(
      {Key? key,
      required this.auth,
      required this.onSignedOut,
      required this.userId,
      required this.onSignedIn})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 30),
              Container(
                  width: 110,
                  child:
                      const Text("SETTINGS:", style: TextStyle(fontSize: 20))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        // const Text("Light / Dark Mode:", style: TextStyle(fontSize: 18)),
                        // const SizedBox(height: 10),
                        // const FadeAnimation(1.5, ThemeSwitch()),
                        // const SizedBox(height: 10),
                        const Text("Sign Out:", style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: SignOutButton(
                              auth: widget.auth,
                              onSignedOut: widget.onSignedOut,
                              userId: widget.userId,
                              onSignedIn: widget.onSignedIn,
                            )),
                        const SizedBox(height: 40),
                        const Text("Version Information:",
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Container(
                            height: 320,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 3,
                                )),
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text("Version:\n1.0.0\n\n"),
                                      Text(
                                          "Permissions:\nCamera\nYour Location (GPS)\n\n"),
                                      Text(
                                          "Android Phone:\nPixel 4 API 31 (Google Play)\n\n"),
                                      Text(
                                          "Developers:\nColin Rebelo\nEric CB-Lamontagne\nGabriel Hoeher\nHayden Macintyre\nKenta Hattori")
                                    ])))
                      ]))
            ])),
        floatingActionButton: const FadeAnimation(1.5, ThemeSwitch()));
  }
}
