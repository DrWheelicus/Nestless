import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:nestless/widgets/sign_out_button.dart';

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

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(widget.opacity),
      elevation: 0.0,
      automaticallyImplyLeading: widget.hasBack,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      title: widget.hasTitle
          ? Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Abraham',
              ),
            )
          : null,
      centerTitle: widget.isCenterTitle,
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
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
