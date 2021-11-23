import 'package:flutter/material.dart';
import 'package:nestless/utils/config.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool hasTitle;
  final bool hasBack;
  final bool hasThemeToggle;
  final List<IconButton> actions;

  final AppBar appBar;

  const TopBar(
      {Key? key,
      required this.title,
      this.hasBack = true,
      this.hasThemeToggle = true,
      this.hasTitle = true,
      required this.appBar,
      this.actions = const []})
      : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _TopBarState extends State<TopBar> {
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
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
      centerTitle: true,
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
        opacity: 1.0,
      ),
      actions: widget.hasThemeToggle
          ? [
                IconButton(
                  icon: _isDarkMode
                      ? const Icon(Icons.wb_sunny)
                      : const Icon(Icons.brightness_3_rounded),
                  tooltip: 'Toggle Theme',
                  onPressed: () {
                    setState(() {
                      setTheme.toggleTheme();
                    });
                  },
                )
              ] +
              widget.actions
          : widget.actions,
    );
  }
}
