import 'package:flutter/material.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/login_signup_dialog.dart';
import 'package:nestless/widgets/theme_switch.dart';
import 'package:nestless/widgets/top_bar.dart';

class LoginPage extends StatefulWidget {
  final String title;

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final String userId;

  final bool isLinkLogin;

  const LoginPage(
      {Key? key,
      required this.title,
      required this.auth,
      required this.onSignedIn,
      required this.onSignedOut,
      required this.userId,
      required this.isLinkLogin})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isDark;
  late Image backgroundImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the theme from the context
    var brightness = Theme.of(context).brightness;
    isDark = brightness == Brightness.dark;

    // Set the background image
    backgroundImage = isDark
        ? const Image(
            image: AssetImage('assets/images/night.gif'),
          )
        : const Image(
            image: AssetImage('assets/images/day.gif'),
          );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          // Set the proper image
          image: backgroundImage.image,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TopBar(
            title: "LOGIN",
            appBar: AppBar(),
            hasBack: false,
            hasSignOut: false,
            auth: widget.auth,
            onSignOut: widget.onSignedOut,
            onSignIn: widget.onSignedIn,
            userId: widget.userId,
            opacity: 0.4,
          ),
          body: LoginSignupDialog(
            isLogin: true,
            auth: widget.auth,
            onSignedIn: widget.onSignedIn,
            onSignedOut: widget.onSignedOut,
            userId: widget.userId,
            // ! Always initially set to false
            isLinkLogin: widget.isLinkLogin,
          ),
          floatingActionButton: const FadeAnimation(1.5, ThemeSwitch())),
    );
  }

  // Clean up the controller when the widget is disposed
  // (e.g. when the route is popped or the app is closed)
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
