import 'package:flutter/material.dart';

Widget generateCustomScaffold({
  required String navBarHeader,
  required Widget drawer,
  required String firstHeader,
  required String firstParagraph,
  required String secondHeader,
  required String secondParagraph,
  required String thirdHeader,
  required String thirdParagraph,
}) {
  return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: Text(navBarHeader),
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
      ));
}

Widget buildContainer(String header, String paragraph) {
  return Container(
    // Customize the container's appearance as needed
    child: Column(
      children: [
        Text(header),
        Text(paragraph),
      ],
    ),
  );
}
