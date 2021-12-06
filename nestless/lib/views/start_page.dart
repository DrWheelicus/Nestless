// ignore_for_file: constant_identifier_names

import 'package:advance_notification/advance_notification.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestless/animations/fade.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/views/home_page.dart';
import 'package:nestless/views/login_page.dart';
import 'package:nestless/widgets/theme_switch.dart';
import 'package:page_transition/page_transition.dart';

// Sign in state
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class StartPage extends StatefulWidget {
  final BaseAuth auth;

  const StartPage({Key? key, required this.auth}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // Initial auth status has to be not determined
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  // Current user id
  // ignore: non_constant_identifier_names
  String _UID = "";

  @override
  void initState() {
    super.initState();
    // Set auth status
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _UID = user.uid;
        }
        _authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // Get the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: 0,
                child: FadeAnimation(
                    1,
                    Container(
                      width: deviceWidth,
                      height: 400,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Positioned(
                top: -160,
                right: 0,
                child: FadeAnimation(
                    1.3,
                    Container(
                      width: deviceWidth,
                      height: 400,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Positioned(
                top: -240,
                left: 0,
                child: FadeAnimation(
                    1.6,
                    Container(
                      width: deviceWidth,
                      height: 400,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one.png'),
                              fit: BoxFit.cover)),
                    )),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                      1.5,
                      // Create text logo
                      AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText('Nestless',
                              textStyle: GoogleFonts.lato(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              colors: [Colors.lightGreen, Colors.lightBlue]),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeAnimation(
                      1.6,
                      // Create text description
                      Text(
                        'A lightweight bird tracking app.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeAnimation(
                      1.7,
                      // Create button to start app
                      AnimatedButton(
                        width: deviceWidth * 0.7,
                        borderRadius: 20,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).primaryColor,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        selectedGradientColor: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                        text: 'GET STARTED',
                        borderWidth: 1.5,
                        transitionType: TransitionType.LEFT_TOP_ROUNDER,
                        onPress: () async {
                          // Check auth status and navigate to correct page
                          switch (_authStatus) {
                            // If not logged in, navigate to login page
                            case AuthStatus.NOT_LOGGED_IN:
                              AdvanceSnackBar(
                                      message:
                                          'Access your account to start tracking!',
                                      mode: 'ADVANCE',
                                      type: 'INFO',
                                      closeIconPosition: 'RIGHT',
                                      iconPosition: 'LEFT',
                                      isIcon: true,
                                      bgColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primaryVariant)
                                  .show(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: LoginPage(
                                    title: 'LOGIN',
                                    auth: widget.auth,
                                    onSignedIn: loginCallback,
                                    onSignedOut: logoutCallback,
                                    userId: _UID,
                                    isLinkLogin: false,
                                  ),
                                ),
                              );
                              break;
                            // If logged in, navigate to home page
                            case AuthStatus.LOGGED_IN:
                              const AdvanceSnackBar(
                                message: 'Welcome back!',
                                mode: 'ADVANCE',
                                type: 'INFO',
                                closeIconPosition: 'RIGHT',
                                isIcon: true,
                                iconPosition: 'LEFT',
                              ).show(context);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: HomePage(
                                    auth: widget.auth,
                                    onSignedOut: logoutCallback,
                                    onSignedIn: loginCallback,
                                    userId: _UID,
                                  ),
                                ),
                              );
                              break;
                            // If unknown, show error
                            case AuthStatus.NOT_DETERMINED:
                              AdvanceSnackBar(
                                      message: 'Account unretrievable!',
                                      mode: 'ADVANCE',
                                      type: 'ERROR',
                                      closeIconPosition: 'RIGHT',
                                      iconPosition: 'LEFT',
                                      isClosable: true,
                                      icon: const Icon(Icons.error),
                                      bgColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .error)
                                  .show(context);
                              break;
                            default:
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const FadeAnimation(
          1.8,
          // Create button to switch theme
          ThemeSwitch(),
        ));
  }

  // Callback for when user logs in. Updates auth status and user ID
  // ! Can be called from anywhere
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _UID = user!.uid;
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  // Callback for when user logs out. Updates auth status
  // ! Can be called from anywhere
  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _UID = "";
    });
  }
}
