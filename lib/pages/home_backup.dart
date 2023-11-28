// ignore: file_names
import 'package:flutter/material.dart';
import 'package:airtastic/widgets/line_chart_widget.dart';
import 'package:airtastic/data/random_chart_data.dart';
import 'package:airtastic/widgets/nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('Airtastic'),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LineChartWidget(generateRandomData()),
              ],
            ),
          ),
        ));
  }
}
