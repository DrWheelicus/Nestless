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
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  // ignore: non_constant_identifier_names
  String _UID = "";

  @override
  void initState() {
    super.initState();
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
    // TODO: could be an introduction screen instead of a basic scaffold

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
                      Text(
                        'A lightweight bird tracking app.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeAnimation(
                      1.7,
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
                        onPress: () {
                          switch (_authStatus) {
                            case AuthStatus.NOT_LOGGED_IN:
                              AdvanceSnackBar(
                                      message:
                                          'Access your account to start tracking!',
                                      mode: 'ADVANCE',
                                      type: 'INFO',
                                      closeIconPosition: 'RIGHT',
                                      iconPosition: 'LEFT',
                                      bgColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primaryVariant)
                                  .show(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(
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
                            case AuthStatus.LOGGED_IN:
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    auth: widget.auth,
                                    onSignedOut: logoutCallback,
                                    onSignedIn: loginCallback,
                                    userId: _UID,
                                  ),
                                ),
                              );
                              break;
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
          ThemeSwitch(),
        ));
  }

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

  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _UID = "";
    });
  }
}
