import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';
import 'package:airtastic/data/Ozone_page_content.dart';

class Ozone extends StatefulWidget {
  const Ozone({super.key});

  @override
  State<Ozone> createState() => _OzoneState();
}

class _OzoneState extends State<Ozone> {
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