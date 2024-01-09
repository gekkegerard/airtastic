import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';

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
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text("Ozone Chart, in progress."),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ));
  }
}
