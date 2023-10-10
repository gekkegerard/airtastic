import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:airtastic/nav_bar.dart';
import 'package:airtastic/data/temperature_page_content.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text('Temperature'),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                firstHeader,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                firstParagraph,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ));
  }}
