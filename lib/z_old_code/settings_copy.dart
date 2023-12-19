import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/custom_dropdown.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _vibrationEnabled = false;
  bool _soundEnabled = false;
  bool _pushNotificationEnabled = false;
  String _selectedColor = 'Light'; // Default color theme
  int _selectedSyncInterval = 10; // Default sync interval in minutes
  List<String> colorThemeList = <String>['Light', 'Dark', 'Rainbow'];
  List<int> syncIntervalList = <int>[1, 10, 15, 30, 60, 120];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSettingsList(),
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      children: [
        ListTile(
          title: const Text('Vibration'),
          onTap: () {
            // Implement the action for Vibration
          },
          trailing: Switch(
            value: _vibrationEnabled,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Sound'),
          onTap: () {
            // Implement the action for Sound
          },
          trailing: Switch(
            value: _soundEnabled,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Push Notifications'),
          onTap: () {
            // Implement the action for Push Notifications
          },
          trailing: Switch(
            value: _pushNotificationEnabled,
            onChanged: (bool value) {
              setState(() {
                _pushNotificationEnabled = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Background Sync Interval'),
          trailing: CustomDropdown(
            items:
                syncIntervalList.map((int value) => value.toString()).toList(),
            initialSelection: _selectedSyncInterval.toString(),
            onSelected: (String value) {
              setState(() {
                _selectedSyncInterval = int.parse(value);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Color Theme'),
          trailing: CustomDropdown(
            items: colorThemeList,
            initialSelection: _selectedColor,
            onSelected: (String value) {
              setState(() {
                _selectedColor = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
