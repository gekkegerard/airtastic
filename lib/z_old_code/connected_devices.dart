import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Devices'),
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text("Devices"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
