import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';
import 'package:airtastic/widgets/date_picker_widget.dart';

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
  bool isGraphLoaded = false;

  @override
  void initState() {
    super.initState();
    // Try to get data initially
    fetchData().then((success) {
      if (success) {
        // If initial fetch is successful, start periodic timer with refresh time of 30 seconds
        _timer = Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
          fetchData();
        });
      } else {
        // If initial fetch fails, continue with periodic timer using loading refresh time of 10 seconds
        _timer = Timer.periodic(Duration(seconds: loadingRefreshTime),
            (Timer timer) {
          fetchData();
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  Future<bool> fetchData() async {
    try {
      var url =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php'; // Get all the data from the last day of measuremtens
      http.Response response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body) as List<dynamic>;

      List<TemperatureData> tempList = [];

      for (var entry in data) {
        DateTime timestamp = DateTime.parse(entry['timestamp']);
        double temperature = double.parse(entry['temperature']);
        tempList.add(TemperatureData(timestamp, temperature));
      }

      if (mounted) {
        // Check if the widget is still in the widget tree before calling setState
        setState(() {
          temperatureDataList = tempList;
          isGraphLoaded = true; // Set to true when the graph is loaded
        });
      }

      // Return true to indicate a successful fetch
      return true;
    } catch (e) {
      print('Failed to fetch data: $e');
      // Return false to indicate a failed fetch
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the date of the first data point, if no data points are available, use the current date. Fix for crash
    DateTime graphDate = temperatureDataList.isNotEmpty
        ? temperatureDataList.first.timestamp
        : DateTime.now();

    return Scaffold(
      drawer: const NavBar(),
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
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
                      child: DataChart(
                        dataPoints: temperatureDataList
                            .map((data) => data.toDataPoint())
                            .toList(),
                        title: '      Temperature Chart',
                        xAxisLabel:
                            'Measurements (${graphDate.day}-${graphDate.month}-${graphDate.year})',
                        yAxisLabel: 'Temperature (°C)',
                        yAxisUnit: '°C',
                      ),
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
              if (temperatureDataList.isNotEmpty &&
                  isGraphLoaded) // Display DatePickerWidget only when the graph is loaded
                Column(
                  children: [
                    const SizedBox(height: 20.0),
                    DatePickerWidget(
                      onDateSelected: (selectedDate) {
                        // Handle the selected date
                        print(selectedDate);
                        // You may want to update the data based on the selected date
                        // Implement logic to fetch data for the selected date
                      },
                    ),
                  ],
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
