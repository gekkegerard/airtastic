import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Humidity'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Humidity"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}