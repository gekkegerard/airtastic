import 'package:airtastic/nav_bar.dart';
import 'package:flutter/material.dart';
//import 'package:sidebar/nav_bar.dart';

void main() => runApp(const MaterialApp(
      home: Homescreen(),
    ));

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const nav_bar(),
      appBar: AppBar(
        title: const Text('Airtastic'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: const Center(
        child: Text('Welcome to Airtastic!!!'),
      ),
    );
  }
}
