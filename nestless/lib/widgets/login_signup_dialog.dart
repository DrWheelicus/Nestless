import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:nestless/views/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/views/home_page.dart';
import 'package:nestless/views/sign_up_page.dart';

// ignore: must_be_immutable
class LoginSignupDialog extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  String userId;
  final bool isLogin;
  final bool isLinkLogin;

  LoginSignupDialog(
      {Key? key,
      required this.auth,
      required this.onSignedIn,
      required this.isLogin,
      required this.onSignedOut,
      required this.userId,
      this.isLinkLogin = false})
      : super(key: key);

  @override
  _LoginSignupDialogState createState() => _LoginSignupDialogState();
}

class _LoginSignupDialogState extends State<LoginSignupDialog>
    with WidgetsBindingObserver {
  late bool isDark;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success;
  late String? _userEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (data?.link != null) {
        handleLink(data!.link);
      }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri deepLink = dynamicLink!.link;
        handleLink(deepLink);
      }, onError: (OnLinkErrorException e) async {
        log('onLinkError');
        log(e.message.toString());
      });
    }
  }

  void handleLink(Uri link) async {
    if (link.userInfo.isNotEmpty) {
      final User user = await widget.auth
          .signInWithLink(_emailController.text, link.toString());
      // ignore: unnecessary_null_comparison
      if (user != null) {
        setState(() {
          widget.userId = user.uid;
          _success = true;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } else {
      setState(() {
        _success = false;
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    isDark = brightness == Brightness.dark;

    // TODO: this is messy, refactor
    return Container(
      padding: const EdgeInsets.all(16),
      // ! this overflows the screen at the bottom when the keyboard is up
      // ! but it's not a big deal since the keyboard is only up when the user
      // ! is typing and no error is visible
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
                  ? widget.isLinkLogin
                      ? MediaQuery.of(context).size.height * 0.45
                      : MediaQuery.of(context).size.height * 0.625
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
                      child: widget.isLinkLogin
                          ? Column(
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
                              ],
                            )
                          : Column(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? "Empty nests are always sad.\nPlease enter a password."
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            )),
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

                          if (_formKey.currentState!.validate() &&
                              !widget.isLinkLogin) {
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
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: HomePage(
                                                  auth: widget.auth,
                                                  onSignedOut:
                                                      widget.onSignedOut,
                                                  onSignedIn: widget.onSignedIn,
                                                  userId: userId,
                                                )));
                                      } else {
                                        _success = false;
                                      }
                                    },
                                  );
                          } else if (_formKey.currentState!.validate() &&
                              widget.isLinkLogin) {
                            widget.auth.sendSignInLink(_emailController.text);
                            widget.onSignedIn();
                            _success = true;
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Email sent",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                          }
                        },
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
                  widget.isLogin
                      ? Column(children: [
                          SignInButton(Buttons.GoogleDark,
                              text: "Sign in with Google", onPressed: () {
                            widget.auth.signInWithGoogle().then((user) {
                              if (user.uid.isNotEmpty) {
                                widget.onSignedIn();
                                _success = true;
                                _userEmail = user.email;
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: HomePage(
                                          auth: widget.auth,
                                          onSignedOut: widget.onSignedOut,
                                          onSignedIn: widget.onSignedIn,
                                          userId: widget.userId,
                                        )));
                              } else {
                                _success = false;
                              }
                            });
                          }),
                          widget.isLinkLogin
                              ? Container()
                              : Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child: LoginPage(
                                                  auth: widget.auth,
                                                  onSignedOut:
                                                      widget.onSignedOut,
                                                  isLinkLogin: true,
                                                  onSignedIn: widget.onSignedIn,
                                                  userId: widget.userId,
                                                  title: 'LOGIN',
                                                )));
                                      },
                                      icon: const Icon(
                                          Icons.attach_email_rounded),
                                      label: const Text("Passwordless Sign In"),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
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
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SignUpPage(
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
                      : Column(children: [
                          SignInButton(Buttons.GoogleDark,
                              text: "Sign up with Google", onPressed: () {
                            widget.auth.signInWithGoogle().then((user) {
                              if (user.uid.isNotEmpty) {
                                widget.onSignedIn();
                                _success = true;
                                _userEmail = user.email;
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: HomePage(
                                          auth: widget.auth,
                                          onSignedOut: widget.onSignedOut,
                                          onSignedIn: widget.onSignedIn,
                                          userId: widget.userId,
                                        )));
                              } else {
                                _success = false;
                              }
                            });
                          }),
                        ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
