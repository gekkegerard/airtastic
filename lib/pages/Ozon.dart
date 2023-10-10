import 'package:flutter/material.dart';

class Ozon extends StatefulWidget {
  const Ozon({super.key});

  @override
  State<Ozon> createState() => _OzonState();
}

class _OzonState extends State<Ozon> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text('Ozon')),
    );
  }
} 