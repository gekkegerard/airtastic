import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/url_widget.dart';
import 'package:airtastic/data/humidity_page_content.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text(navBarHeader),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          paragraphBuilder(firstHeader, [firstParagraph]),
          paragraphBuilder(secondHeader, [secondParagraph]),
          paragraphBuilder(thirdHeader, [thirdParagraph]),
          paragraphBuilder("Sources", [
            urlwidget(url[0]),
            urlwidget(url[1]),
            urlwidget(url[2]),
          ]),
        ],
      ),
    );
  }
}
