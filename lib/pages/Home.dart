import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TemperatureData> temperatureDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url =
        'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
    http.Response response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body) as List<dynamic>;

    List<TemperatureData> tempList = [];

    for (var entry in data) {
      DateTime timestamp = DateTime.parse(entry['timestamp']);
      double temperature = double.parse(entry['temperature']);
      tempList.add(TemperatureData(timestamp, temperature));
    }

    setState(() {
      temperatureDataList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Chart'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              temperatureDataList.isNotEmpty
                  ? SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      series: <ChartSeries>[
                        ScatterSeries<TemperatureData, DateTime>(
                          color: Colors.red[600],
                          dataSource: temperatureDataList,
                          xValueMapper: (TemperatureData data, _) =>
                              data.timestamp,
                          yValueMapper: (TemperatureData data, _) =>
                              data.temperature,
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class TemperatureData {
  final DateTime timestamp;
  final double temperature;

  TemperatureData(this.timestamp, this.temperature);
}
