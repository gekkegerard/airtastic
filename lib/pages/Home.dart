import 'package:airtastic/nav_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        child: Text('Welcome to Airtastic!!'),
      ),
    );
  }
}
