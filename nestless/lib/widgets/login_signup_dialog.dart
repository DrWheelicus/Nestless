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

  // Initialize form field controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success;
  late String? _userEmail;

  @override
  void initState() {
    super.initState();
    // Check for link login
    WidgetsBinding.instance!.addObserver(this);
  }

  // Clean up controllers when done
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  // Detect when app is in the background and open link
  // ! Not working
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   try {
  //     FirebaseDynamicLinks.instance.onLink(
  //         onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //       final Uri? deepLink = dynamicLink?.link;
  //       if (deepLink != null) {
  //         handleLink(deepLink, _emailController.text);
  //         FirebaseDynamicLinks.instance.onLink(
  //             onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //           final Uri? deepLink = dynamicLink!.link;
  //           handleLink(deepLink!, _emailController.text);
  //         }, onError: (OnLinkErrorException e) async {
  //           log(e.message.toString());
  //         });
  //         // Navigator.pushNamed(context, deepLink.path);
  //       }
  //     }, onError: (OnLinkErrorException e) async {
  //       log(e.message.toString());
  //     });

  //     final PendingDynamicLinkData? data =
  //         await FirebaseDynamicLinks.instance.getInitialLink();
  //     final Uri? deepLink = data?.link;

  //     if (deepLink != null) {
  //       log(deepLink.userInfo);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // // Handle dynamic link
  // void handleLink(Uri link, userEmail) async {
  //   // ignore: unnecessary_null_comparison
  //   if (link != null) {
  //     log(userEmail);
  //     final UserCredential user =
  //         await FirebaseAuth.instance.signInWithEmailLink(
  //       email: userEmail,
  //       emailLink: link.toString(),
  //     );
  //     // ignore: unnecessary_null_comparison
  //     if (user != null) {
  //       log(user.credential.toString());
  //     }
  //   } else {
  //     log("link is null");
  //   }
  // }

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
                      // * NOTE: Need to change this every time the login dialog
                      // * is added to
                      ? MediaQuery.of(context).size.height * 0.4
                      : MediaQuery.of(context).size.height *
                          0.48 // ! DO NOT CHANGE
                  : MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              elevation: 10,
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 10),
              borderRadius: BorderRadius.circular(20),
              blur: isDark ? 10 : 20, // Put a blur on the background
              // More blur = more expensive so use less
              // when possible
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
                                    // Assign the controller to the text field
                                    controller: _emailController,
                                    // Set the keyboard type so the user can
                                    // enter their email more easily
                                    // * Accessibility option
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
                                    // Assign the controller to the text field
                                    controller: _emailController,
                                    // Set the keyboard type so the user can
                                    // enter their email more easily
                                    // * Accessibility option
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
                                      // Assign the controller to the text field
                                      controller: _passwordController,
                                      // Hide the password to make it more seem
                                      // secure
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
                          // Set the button text based on whether the user is
                          // logging in or signing up
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

                            // Check if the form is valid
                            if (_formKey.currentState!.validate() &&
                                !widget.isLinkLogin) {
                              // Check if the user is logging in or signing up
                              widget.isLogin
                                  // If the user is logging in, log them in (obviously)
                                  ? widget.auth
                                      .signIn(_emailController.text,
                                          _passwordController.text)
                                      .then((user) {
                                      userId = user.uid;
                                      if (userId.isNotEmpty) {
                                        widget.onSignedIn();
                                        _success = true;
                                        _userEmail = user.email;
                                        widget.userId = user.uid;
                                        // Navigate to the home page
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: HomePage(
                                                  userId: userId,
                                                  auth: widget.auth,
                                                  onSignedOut:
                                                      widget.onSignedOut,
                                                  onSignedIn: widget.onSignedIn,
                                                ),
                                                type: PageTransitionType.fade));
                                      } else {
                                        _success = false;
                                        // TODO: Change this to a personalized snackbar
                                        // * Should be a more user friendly error message
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
                                  // If the user is signing up, sign them up (obviously)
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
                                          // Navigate to the home page
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                  child: HomePage(
                                                    auth: widget.auth,
                                                    onSignedOut:
                                                        widget.onSignedOut,
                                                    onSignedIn:
                                                        widget.onSignedIn,
                                                    userId: userId,
                                                  )));
                                        } else {
                                          _success = false;
                                        }
                                      },
                                    );
                              // } else if (_formKey.currentState!.validate() &&
                              //     widget.isLinkLogin) {
                              //   // Email link login
                              //   widget.auth.sendSignInLink(_emailController.text);
                              //   widget.onSignedIn();
                              //   _success = true;
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //         "Email sent",
                              //         style: TextStyle(
                              //           color:
                              //               Theme.of(context).colorScheme.onError,
                              //         ),
                              //       ),
                              //       backgroundColor: Theme.of(context).primaryColor,
                              //     ),
                              //   );
                              // }
                            }
                          })),
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
                  const SizedBox(height: 2),
                  widget.isLogin
                      ? Column(children: [
                          // Google sign in button
                          SignInButton(Buttons.GoogleDark,
                              text: "Sign in with Google", onPressed: () {
                            // Initialize the google sign in
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
                                  children: const [
                                    SizedBox(height: 2),
                                    // ElevatedButton.icon(
                                    //   onPressed: () {
                                    //     Navigator.push(
                                    //         context,
                                    //         PageTransition(
                                    //             type: PageTransitionType.fade,
                                    //             child: LoginPage(
                                    //               auth: widget.auth,
                                    //               onSignedOut:
                                    //                   widget.onSignedOut,
                                    //               isLinkLogin: true,
                                    //               onSignedIn: widget.onSignedIn,
                                    //               userId: widget.userId,
                                    //               title: 'LOGIN',
                                    //             )));
                                    //   },
                                    //   icon: const Icon(
                                    //     Icons.link,
                                    //   ),
                                    //   label: const Text("Passwordless Sign In"),
                                    //   style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all(
                                    //       Theme.of(context)
                                    //           .colorScheme
                                    //           .secondary,
                                    //     ),
                                    //     foregroundColor:
                                    //         MaterialStateProperty.all(
                                    //       Theme.of(context)
                                    //           .colorScheme
                                    //           .onSecondary,
                                    //     ),
                                    //     shape: MaterialStateProperty.all(
                                    //       RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
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
