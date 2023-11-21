import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TemperatureChart extends StatefulWidget {
  const TemperatureChart({super.key});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  List<TemperatureData> temperatureDataList = [];
  late Timer _timer;
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    header: "Measurement",
    format: 'Time: point.x\nTemp: point.y°C',
  );

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    fetchData();
    // Start a periodic timer to fetch data every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
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
    var url =
        'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
    try {
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
    } catch (e) {
      print('Failed to fetch data: $e'); // TODO: Remove this line
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              temperatureDataList.isNotEmpty
                  ? /*SfCartesianChart(
                      title: ChartTitle(
                          text: 'Temperature in °C',
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
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
                    )*/

                  // Welke graph is beter???
                  SfCartesianChart(
                      title: ChartTitle(
                          text: 'Temperature',
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),

                      primaryXAxis: DateTimeAxis(
                        title: AxisTitle(
                          text: 'Time',
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: 'Temperature (°C)',
                        ),
                      ),
                      tooltipBehavior: _tooltipBehavior, // Enable tooltip

                      series: <ChartSeries>[
                        LineSeries<TemperatureData, DateTime>(
                          enableTooltip: true, // Make the graph interactive
                          color: Colors.red[600],
                          dataSource: temperatureDataList,
                          xValueMapper: (TemperatureData data, _) =>
                              data.timestamp,
                          yValueMapper: (TemperatureData data, _) =>
                              data.temperature,
                          width: 5, // line width
                          markerSettings: const MarkerSettings(
                              shape: DataMarkerType.diamond,
                              color: Color.fromARGB(255, 255, 255, 255),
                              isVisible:
                                  true), // This line makes data points visible
                        ),
                      ],
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
}
