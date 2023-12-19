import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/data/about_us_page_content.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';
//import 'package:airtastic/widgets/page_colors.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text(navBarHeader),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          paragraphBuilder(firstHeader, [firstParagraph]),
          paragraphBuilder(secondHeader, [secondParagraph]),
          paragraphBuilder(thirdHeader, [thirdParagraph]),
          paragraphBuilder(fourthHeader, [fourthParagraph])
        ],
      ),
    );
  }
}
