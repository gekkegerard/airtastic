import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:airtastic/widgets/paragraph_builder.dart';
import 'package:airtastic/data/ozone_page_content.dart';

class CO2Chart extends StatefulWidget {
  const CO2Chart({super.key});

  @override
  State<CO2Chart> createState() => _CO2ChartState();
}

class _CO2ChartState extends State<CO2Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('CO2 Chart'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("CO2 Chart"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}