import 'package:flutter/material.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/login_signup_dialog.dart';
import 'package:nestless/widgets/theme_switch.dart';
import 'package:nestless/widgets/top_bar.dart';

class SignUpPage extends StatefulWidget {
  final String title;

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final String userId;

  const SignUpPage(
      {Key? key,
      required this.title,
      required this.auth,
      required this.onSignedIn,
      required this.onSignedOut,
      required this.userId})
      : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool isDark;
  late Image backgroundImage;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    isDark = brightness == Brightness.dark;

    // Set background image
    backgroundImage = isDark
        ? const Image(
            image: AssetImage('assets/images/night2.gif'),
          )
        : const Image(
            image: AssetImage('assets/images/day.gif'),
          );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage.image,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopBar(
          appBar: AppBar(),
          title: widget.title,
          auth: widget.auth,
          onSignOut: widget.onSignedOut,
          onSignIn: widget.onSignedIn,
          userId: widget.userId,
          hasThemeToggle: false,
          opacity: 0.4,
        ),
        // Show signup dialog
        body: LoginSignupDialog(
          auth: widget.auth,
          onSignedIn: widget.onSignedIn,
          onSignedOut: widget.onSignedOut,
          userId: widget.userId,
          isLogin: false,
        ),
        floatingActionButton: const FadeAnimation(1.5, ThemeSwitch()),
      ),
    );
  }
}
