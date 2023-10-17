import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';

class CO2 extends StatefulWidget {
  const CO2({super.key});

  @override
  State<CO2> createState() => _CO2State();
}

class _CO2State extends State<CO2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('CO2'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("CO2"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
