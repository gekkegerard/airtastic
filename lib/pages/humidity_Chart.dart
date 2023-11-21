import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class HumidityChart extends StatefulWidget {
  const HumidityChart({super.key});

  @override
  State<HumidityChart> createState() => _HumidityChartState();
}

class _HumidityChartState extends State<HumidityChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Humidity_Chart'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("About"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}