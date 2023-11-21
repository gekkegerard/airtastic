import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';
import 'package:airtastic/data/ozone_page_content.dart';

class OzoneChart extends StatefulWidget {
  const OzoneChart({super.key});

  @override
  State<OzoneChart> createState() => _OzoneChartState();
}

class _OzoneChartState extends State<OzoneChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Ozone Chart'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Ozone Chart"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}