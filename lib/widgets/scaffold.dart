import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget navBarHeader;
  final Widget firstHeader;
  final Widget firstParagraph;
  final Widget secondHeader;
  final Widget secondParagraph;
  final Widget thirdHeader;
  final Widget thirdParagraph;

  const CustomScaffold({
    super.key,
    required this.navBarHeader,
    required this.firstHeader,
    required this.firstParagraph,
    required this.secondHeader,
    required this.secondParagraph,
    required this.thirdHeader,
    required this.thirdParagraph,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const nav_bar(),
      appBar: AppBar(
        title: const Text("test"),
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

  Widget buildContainer(Widget header, Widget paragraph) {
    return Column(
      children: [header, paragraph],
    );
  }
}
