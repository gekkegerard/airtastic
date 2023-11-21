import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Homepage'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Airtastic"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
