import 'package:flutter/material.dart';
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
          title: const Text(navBarHeader),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            // First header
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40.0),
              child: const Text(
                firstHeader,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // First paragraph
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Text(
                firstParagraph,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Second header
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40.0),
              child: const Text(
                secondHeader,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Second paragraph
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Text(
                secondParagraph,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Third header
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(40.0),
              child: const Text(
                thirdHeader,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: const Text(
                thirdParagraph,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
