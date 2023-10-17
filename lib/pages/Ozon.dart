import 'package:flutter/material.dart';
import 'package:airtastic/nav_bar.dart';
import 'package:airtastic/widgets/common_widgets.dart';

class Ozon extends StatefulWidget {
  const Ozon({super.key});

  @override
  State<Ozon> createState() => _OzonState();
}

class _OzonState extends State<Ozon> {
  final CommonWidgets commonWidgets = CommonWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: commonWidgets.buildContainer('Header', 'Paragraph'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Ozon"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
