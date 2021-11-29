import 'package:flutter/material.dart';
import 'package:nestless/utils/config.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  late bool isDark;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    isDark = brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.wb_sunny_rounded),
        Switch(
          value: isDark,
          onChanged: (bool value) {
            setState(() {
              // Switch the theme
              setTheme.toggleTheme();
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        const Icon(Icons.brightness_3),
      ],
    );
  }
}
