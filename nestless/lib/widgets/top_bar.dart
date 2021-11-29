import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/sign_out_button.dart';

// Global class for a customizable app bar
class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool hasTitle;
  final bool isCenterTitle;
  final bool hasBack;
  final bool hasSignOut;
  final bool hasThemeToggle;
  final List<Widget> actions;
  final double opacity;

  final AppBar appBar;

  final BaseAuth auth;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;
  final String userId;

  const TopBar(
      {Key? key,
      required this.title,
      this.hasBack = true,
      this.hasSignOut = false,
      this.hasThemeToggle = true,
      this.hasTitle = true,
      this.isCenterTitle = false,
      required this.appBar,
      required this.auth,
      required this.onSignOut,
      this.actions = const [],
      this.opacity = 1.0,
      required this.userId,
      required this.onSignIn})
      : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();

  // Gets the preferred size of the app bar
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
      elevation: 0.0,
      // Check if the app bar has a back button
      automaticallyImplyLeading: widget.hasBack,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      // Check if the app bar has a title
      title: widget.hasTitle
          ? Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline1!.color,
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Abraham',
              ),
            )
          : null,
      // Check if the app bar's title is centered
      centerTitle: widget.isCenterTitle,
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      // Check if the app bar has a sign out button
      // and populate the actions list with the given actions
      actions: widget.hasSignOut
          ? <Widget>[
                SignOutButton(
                    auth: widget.auth,
                    onSignedOut: widget.onSignOut,
                    userId: widget.userId,
                    onSignedIn: widget.onSignIn),
              ] +
              widget.actions
          : widget.actions,
    );
  }
}
