import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('About'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("About"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
