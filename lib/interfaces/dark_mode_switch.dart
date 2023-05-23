import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class DarkModeSwitch extends StatefulWidget {
  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
  
}
class _DarkModeSwitchState extends State<DarkModeSwitch> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    darkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Row(
        children: [
          Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
          SizedBox(width: 8),
          Text(darkMode ? 'Mode sombre' : 'Mode clair'),
          
        ],
      ),
      value: darkMode,
      activeColor: Colors.orange,
      onChanged: (bool value) {
        setState(() {
          darkMode = value;
        });
        if (value) {
          AdaptiveTheme.of(context).setDark();
        } else {
          AdaptiveTheme.of(context).setLight();
        }
      },
    );
  }
}
