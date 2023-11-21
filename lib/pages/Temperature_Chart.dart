import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';

class TemperatureChart extends StatefulWidget {
  const TemperatureChart({super.key});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  List<TemperatureData> temperatureDataList = [];
  late Timer _timer;
  var refreshTime = 30;
  var loadingRefreshTime = 10;

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    fetchData();
    // Start a periodic timer to fetch data every 30 seconds
    _timer = Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    // Use loadingRefreshTime while fetching data
    _timer = Timer.periodic(Duration(seconds: loadingRefreshTime),
        (Timer timer) async {
      try {
        var url =
            'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
        http.Response response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body) as List<dynamic>;

        List<TemperatureData> tempList = [];

        for (var entry in data) {
          DateTime timestamp = DateTime.parse(entry['timestamp']);
          double humidity = double.parse(entry['humidity']);
          tempList.add(TemperatureData(timestamp, humidity));
        }

        if (mounted) {
          // Check if the widget is still in the widget tree before calling setState
          setState(() {
            temperatureDataList = tempList;
          });
        }

        // Switch back to the regular refresh time after data is loaded
        _timer.cancel();
        _timer = Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
          fetchData();
        });
      } catch (e) {
        print('Failed to fetch data: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const nav_bar(),
      appBar: AppBar(
        title: const Text('Temperature'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              temperatureDataList.isNotEmpty
                  ? DataChart(
                      dataPoints: temperatureDataList
                          .map((data) => data.toDataPoint())
                          .toList(),
                      title: 'Temperatures Chart',
                      xAxisLabel: 'Time',
                      yAxisLabel: 'Temperature (°C)',
                      yAxisUnit: '°C',
                    )
                  : SizedBox(
                      height: 200.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              color: Colors.red[600],
                            ),
                            const Text('Loading graph...',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
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

  // Conversion function
  DataPoint toDataPoint() {
    return DataPoint(timestamp, temperature);
  }
}
