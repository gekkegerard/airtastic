import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isActive = false; // Set this to false for a green circle
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

  late double temperature = 20;
  late double ozone = 20;
  late double humidity = 20;
  late int valid;

  Future<bool> fetchData() async {
    try {
      var url =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php'; // Get all the data from the last day of measuremtens
      http.Response response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body) as List<dynamic>;

      List<TemperatureData> tempList = [];

      for (var entry in data) {
        DateTime timestamp = DateTime.parse(entry['timestamp']);
        temperature = double.parse(entry['temperature']);
        ozone = double.parse(entry['ozone_concentration']);
        humidity = double.parse(entry['humidity']);
        valid = int.parse(entry['ozone_measurement_valid']);
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
    DateTime datum = temperatureDataList.isNotEmpty
        ? temperatureDataList.first.timestamp
        : DateTime.now();

    if (valid != 0) {
      isActive = true;
    } else {
      isActive = false;
    }

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Active:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ontime:'),
                ),
                Text("data markus")
              ],
            ),
            const SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Date:'),
                ),
                Text("${datum.day}-${datum.month}-${datum.year}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Temperature:'),
                ),
                Text("$temperature")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Humidity:'),
                ),
                Text("$humidity")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ozone:'),
                ),
                Text("$ozone")
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("these are the last measurd values"),
                ),
              ],
            ),
          ],
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
