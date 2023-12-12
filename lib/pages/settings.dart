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
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
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
        ),
        _buildSwitchListTile(
          title: 'Vibration',
          value: _vibrationEnabled,
          onChanged: (bool value) {
            setState(() {
              _vibrationEnabled = value;
            });
          },
          onTap: () {
            setState(() {
              _vibrationEnabled = !_vibrationEnabled;
            });
          },
        ),
        _buildSwitchListTile(
          title: 'Sound',
          value: _soundEnabled,
          onChanged: (bool value) {
            setState(() {
              _soundEnabled = value;
            });
          },
          onTap: () {
            setState(() {
              _soundEnabled = !_soundEnabled;
            });
          },
        ),
        _buildSwitchListTile(
          title: 'Push Notifications',
          value: _pushNotificationEnabled,
          onChanged: (bool value) {
            setState(() {
              _pushNotificationEnabled = value;
            });
          },
          onTap: () {
            setState(() {
              _pushNotificationEnabled = !_pushNotificationEnabled;
            });
          },
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
      ],
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: GestureDetector(
        onTap: onTap,
        child: Text(title),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
