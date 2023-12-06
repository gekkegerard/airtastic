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
  List<String> list = <String>['Light', 'Dark', 'Rainbow'];

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
          trailing: DropdownButton<int>(
            value: _selectedSyncInterval,
            onChanged: (int? newValue) {
              setState(() {
                _selectedSyncInterval = newValue!;
              });
            },
            items: <int>[1, 10, 15, 30, 60, 120]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value minutes'),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Color Theme'),
          trailing: DropdownButton<String>(
            value: _selectedColor,
            onChanged: (String? newValue) {
              setState(() {
                _selectedColor = newValue!;
              });
            },
            items: <String>['Light', 'Dark', 'Rainbow']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
            title: const Text('Color Theme V2'),
            trailing: DropdownMenu<String>(
              initialSelection: list.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  String dropdownValue = list.first;
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            )),
      ],
    );
  }
}