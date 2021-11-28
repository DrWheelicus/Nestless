import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/views/home_page.dart';
import 'package:nestless/views/sign_up_page.dart';

class LoginSignupDialog extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final String userId;
  final bool isLogin;

  const LoginSignupDialog(
      {Key? key,
      required this.auth,
      required this.onSignedIn,
      required this.isLogin,
      required this.onSignedOut,
      required this.userId})
      : super(key: key);

  @override
  _LoginSignupDialogState createState() => _LoginSignupDialogState();
}

class _LoginSignupDialogState extends State<LoginSignupDialog> {
  late bool isDark;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success;
  late String? _userEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    isDark = brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeAnimation(
            1,
            GlassContainer(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.01),
                  Colors.white.withOpacity(0.35),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderColor: Colors.white,
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              height: widget.isLogin
                  ? MediaQuery.of(context).size.height * 0.55
                  : MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              elevation: 10,
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 10),
              borderRadius: BorderRadius.circular(20),
              blur: isDark ? 10 : 20,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          1.4,
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              icon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Did the birds take your Email?\nEmail can't be empty"
                                : null,
                          ),
                        ),
                        FadeAnimation(
                          1.4,
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                icon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Empty nests are always sad.\nPlease enter a password."
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeAnimation(
                      1.5,
                      AnimatedButton(
                        text: widget.isLogin ? "LOGIN" : "SIGN UP",
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Abraham',
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        selectedBackgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        selectedTextColor:
                            Theme.of(context).colorScheme.onSecondary,
                        width: MediaQuery.of(context).size.width * 0.4,
                        borderRadius: 20,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        borderWidth: 1.5,
                        onPress: () {
                          String userId = "";

                          if (_formKey.currentState!.validate()) {
                            widget.isLogin
                                ? widget.auth
                                    .signIn(_emailController.text,
                                        _passwordController.text)
                                    .then((user) {
                                    userId = user.uid;
                                    if (userId.isNotEmpty) {
                                      widget.onSignedIn();
                                      _success = true;
                                      _userEmail = user.email;
                                    } else {
                                      _success = false;
                                      // TODO: Change this to a personalized snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Login failed",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onError,
                                            ),
                                          ),
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                        ),
                                      );
                                    }
                                  })
                                : widget.auth
                                    .signUp(_emailController.text,
                                        _passwordController.text)
                                    .then(
                                    (user) {
                                      userId = user.uid;
                                      if (userId.isNotEmpty) {
                                        widget.onSignedIn();
                                        _success = true;
                                        _userEmail = user.email;
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HomePage(
                                            auth: widget.auth,
                                            onSignedOut: widget.onSignedOut,
                                            userId: userId,
                                          );
                                        }));
                                      } else {
                                        _success = false;
                                      }
                                    },
                                  );
                          }
                        },
                        transitionType: TransitionType.LEFT_TOP_ROUNDER,
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 20,
                          child: Center(
                              child: Container(
                            margin: const EdgeInsetsDirectional.only(
                                start: 1.0, end: 1.0),
                            height: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                          child: Center(
                              child: Container(
                            margin: const EdgeInsetsDirectional.only(
                                start: 1.0, end: 1.0),
                            height: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3),
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // TODO: Add Google login
                  Placeholder(
                    fallbackHeight: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  widget.isLogin
                      ? Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.6),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpPage(
                                        title: "SIGN UP",
                                        auth: widget.auth,
                                        onSignedIn: widget.onSignedIn,
                                        onSignedOut: widget.onSignedOut,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ])
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
