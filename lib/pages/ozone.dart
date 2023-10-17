import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';
import 'package:airtastic/data/ozone_page_content.dart';

class Ozon extends StatefulWidget {
  const Ozon({super.key});

  @override
  State<Ozon> createState() => _OzonState();
}

class _OzonState extends State<Ozon> {
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
        ],
      ),
    );
  }
}
