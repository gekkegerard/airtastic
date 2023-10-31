import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/data/temperature_page_content.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';

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
          paragraphBuilder(firstHeader, firstParagraph),
          paragraphBuilder(secondHeader, secondParagraph),
          paragraphBuilder(thirdHeader, thirdParagraph),
          paragraphBuilder("Sources", sourceText),
        ],
      ),
    );
  }
}
