import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class TemperatureChart extends StatefulWidget {
  const TemperatureChart({super.key});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text('Temperature Chart'),
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text("Temperature Chart"),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
