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
  // Create a GlobalKey to access the current context
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TemperatureData> temperatureDataList = [];
  late Timer _timer;
  var refreshTime = 30;
  var loadingRefreshTime = 10;
  bool isGraphLoaded = false; // Used to display the DatePickerWidget

  @override
  void initState() {
    super.initState();
    // Try to get data initially
    fetchData().then((success) {
      if (success) {
        // If initial fetch is successful, start periodic timer with refresh time of 30 seconds
        _timer = Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
          print("Triggered 30 second timer");
          fetchData();
        });
      } else {
        // If initial fetch fails, continue with periodic timer using loading refresh time of 10 seconds
        _timer = Timer.periodic(Duration(seconds: loadingRefreshTime),
            (Timer timer) {
          print("Triggered 10 second timer");
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

  Future<bool> fetchData({DateTime? selectedDate}) async {
    try {
      var url =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php'; // GET = last day of measurements, POST = specific date
      http.Response? response;

      // If a date is passed on to the function, use POST request with the selected date
      if (selectedDate != null) {
        // Create a body for the request
        Map<String, String> body = {
          'primaryDate':
              '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'
        };

        // Encode the body to a string so it can be sent with the request
        String encodedBody = body.keys
            .map((key) => '$key=${Uri.encodeComponent(body[key]!)}')
            .join('&');

        // Make the POST request
        print("Making post request");
        response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: encodedBody,
        );

        // The selected date of the user is not the current date, cancel auto refresh since there will not be any new data
        if (selectedDate.day != DateTime.now().day) {
          print("Cancelling timer");
          _timer.cancel();
          // User has selected the current date and there is date from today available, restart the timer if it is not already active
        } else if (selectedDate.day == DateTime.now().day &&
            _timer.isActive == false &&
            response.body.trim() != '[]') {
          print("Restarting timer");
          _timer =
              Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
            print("Triggered 30 second timer");
            fetchData();
          });
        }
      } else {
        // If no date is selected, use GET request to get the last day of measurements
        print("Making get request");
        response = await http.get(Uri.parse(url));
      }

      // Successful communication with the server
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.trim() != '[]') {
          print("not empty");
          var data = jsonDecode(response.body) as List<dynamic>;
          List<TemperatureData> tempList = [];

          for (var entry in data) {
            DateTime timestamp = DateTime.parse(entry['timestamp']);
            double temperature = double.parse(entry['temperature']);
            tempList.add(TemperatureData(timestamp, temperature));
          }

          // Check if the widget is still in the widget tree before calling setState
          if (mounted) {
            setState(() {
              temperatureDataList = tempList;
              isGraphLoaded = true; // Used to display the DatePickerWidget
            });
          }
          // If the response body is empty, show a pop-up dialog
        } else {
          print("Making pop-up");
          // Show a pop-up dialog only if it hasn't been shown before or a new date is selected
          if (selectedDate != null) {
            showDialog(
              context: _scaffoldKey.currentContext!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('No Data Available'),
                  content: const Text(
                      'There are no measurements for the selected day.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } else {
        // Handle non-200 status code (error)
        print('Error: ${response.statusCode}');
        // You may want to display an error message or handle it in some way
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
      key: _scaffoldKey,
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
                        print("Calling Datepickerwidget");
                        // After the user has selected a date, update the graph
                        fetchData(selectedDate: selectedDate);
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
