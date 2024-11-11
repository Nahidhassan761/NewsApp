import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Define an enum to represent theme options
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Light Theme'),
            leading: Radio<bool>(
              value: false,
              groupValue: _isDarkTheme,
              onChanged: (bool? value) {
                setState(() {
                  _isDarkTheme = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dark Theme'),
            leading: Radio<bool>(
              value: true,
              groupValue: _isDarkTheme,
              onChanged: (bool? value) {
                setState(() {
                  _isDarkTheme = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Return the theme selection to the HomeScreen
              Navigator.pop(context, _isDarkTheme);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
