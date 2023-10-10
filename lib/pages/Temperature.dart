import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';
import 'package:airtastic/data/temperature_page_content.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  Widget buildContainer(String header, String paragraph) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Column(
        children: [
          Text(
            header,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            paragraph,
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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
          buildContainer(firstHeader, firstParagraph),
          buildContainer(secondHeader, secondParagraph),
          buildContainer(thirdHeader, thirdParagraph),
        ],
      ),
    );
  }
}
