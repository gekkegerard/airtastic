import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';

class HumidityChart extends StatefulWidget {
  const HumidityChart({super.key});

  @override
  State<HumidityChart> createState() => _HumidityChartState();
}

class _HumidityChartState extends State<HumidityChart> {
  List<HumidityData> humidityDataList = [];
  late Timer _timer;
  var standardRefreshTime = 30;
  var loadingRefreshTime = 10; // Faster polling time while loading

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    fetchData();
    // Start a periodic timer to fetch data every 30 seconds
    _timer =
        Timer.periodic(Duration(seconds: standardRefreshTime), (Timer timer) {
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
    _timer =
        Timer.periodic(Duration(seconds: loadingRefreshTime), (Timer timer) {
      fetchData();
    });

    var url =
        'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
    try {
      http.Response response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body) as List<dynamic>;

      List<HumidityData> tempList = [];

      for (var entry in data) {
        DateTime timestamp = DateTime.parse(entry['timestamp']);
        double temperature = double.parse(entry['humidity']);
        tempList.add(HumidityData(timestamp, temperature));
      }

      setState(() {
        humidityDataList = tempList;
      });

      // Switch back to the regular refresh time after data is loaded
      _timer.cancel();
      _timer =
          Timer.periodic(Duration(seconds: standardRefreshTime), (Timer timer) {
        fetchData();
      });
    } catch (e) {
      print('Failed to fetch data: $e'); // TODO: Remove this line
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const nav_bar(),
      appBar: AppBar(
        title: const Text('Humidity'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              humidityDataList.isNotEmpty
                  ? DataChart(
                      dataPoints: humidityDataList
                          .map((data) => data.toDataPoint())
                          .toList(),
                      title: 'Humidity Chart',
                      xAxisLabel: 'Time', //
                      yAxisLabel: 'Humidity (%)',
                      yAxisUnit: '%',
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

class HumidityData {
  final DateTime timestamp;
  final double temperature;

  HumidityData(this.timestamp, this.temperature);

  // Conversion function
  DataPoint toDataPoint() {
    return DataPoint(timestamp, temperature);
  }
}
