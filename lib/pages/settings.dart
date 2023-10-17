import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Settings'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
