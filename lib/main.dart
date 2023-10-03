import 'package:airtastic/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/pages/Home.dart';

//import 'package:sidebar/nav_bar.dart';
import 'package:airtastic/lineChartWidget.dart';
import 'package:airtastic/data/random_chart_data.dart';

void main() => runApp(const MaterialApp(
      home: Home(),
      //home: Homescreen(),
    ));

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text('Airtastic'),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LineChartWidget(pricePoints),
              ],
            ),
          ),
        ));
  }
}
