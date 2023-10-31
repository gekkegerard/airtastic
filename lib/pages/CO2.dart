import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/data/carbon_dioxide_page_content.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';

class CO2 extends StatefulWidget {
  const CO2({super.key});

  @override
  State<CO2> createState() => _CO2State();
}

class _CO2State extends State<CO2> {
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
