import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';

class Ozon extends StatefulWidget {
  const Ozon({super.key});

  @override
  State<Ozon> createState() => _OzonState();
}

class _OzonState extends State<Ozon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Ozon'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Ozon"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
} 