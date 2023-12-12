import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';
import 'package:airtastic/widgets/date_picker_widget.dart';
import 'package:airtastic/widgets/time_picker_widget.dart';

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
  DateTime? selectedDate; // Date selected by the user for the graph
  DateTime? dateFromGraphCurrently; // Date of the first data point in the graph
  TimeRange? currentGraphTimeRange; // Time range of the current graph

  @override
  void initState() {
    super.initState();
    // Try to get data initially
    fetchData().then((success) {
      if (success) {
        // If initial fetch is successful, start periodic timer with refresh time of 30 seconds
        _timer = Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
          print("Triggered 30 second timer"); // DEBUG
          fetchData();
        });
      } else {
        // If initial fetch fails, continue with periodic timer using loading refresh time of 10 seconds
        _timer = Timer.periodic(Duration(seconds: loadingRefreshTime),
            (Timer timer) {
          print("Triggered 10 second timer"); // DEBUG
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

  Future<bool> fetchData({
    DateTime? selectedDate,
    TimeOfDay? selectedStartTime,
    TimeOfDay? selectedEndTime,
  }) async {
    try {
      var url =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php'; // GET = last day of measurements, POST = specific date
      http.Response? response;

      // If a date is passed on to the function, use POST request with the selected date
      if (selectedDate != null) {
        // Create a body for the request
        Map<String, String> body = {};

        // If a time range is selected, use the selected time range and date
        if (selectedStartTime != null && selectedEndTime != null) {
          body = {
            'primaryDate':
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${selectedStartTime.hour}:${selectedStartTime.minute}:00',
            'secondaryDate':
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${selectedEndTime.hour}:${selectedEndTime.minute}:59'
          };
          // No time range is selected, use every measurement from the selected date
        } else {
          body = {
            'primaryDate':
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} 00:00:00',
            'secondaryDate':
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day} 23:59:59',
          };
        }

        // Encode the body to a string so it can be sent with the request
        String encodedBody = body.keys
            .map((key) => '$key=${Uri.encodeComponent(body[key]!)}')
            .join('&');

        // Make the POST request
        print("Making post request"); // DEBUG
        response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: encodedBody,
        );

        // The selected date of the user is not the current date, cancel auto refresh since there will not be any new data
        if (selectedDate.day != DateTime.now().day) {
          print("Cancelling timer"); // DEBUG
          _timer.cancel();
          // User has selected the current date and there is date from today available, restart the timer if it is not already active
        } else if (selectedDate.day == DateTime.now().day &&
            _timer.isActive == false &&
            response.body.trim() != '[]') {
          print("Restarting timer"); // DEBUG
          _timer =
              Timer.periodic(Duration(seconds: refreshTime), (Timer timer) {
            print("Triggered 30 second timer"); // DEBUG
            fetchData();
          });
        }
      } else {
        // If no date is selected, use GET request to get the last day of measurements
        print("Making get request"); // DEBUG

        // Making a GET request, gets you the last day of measurements
        response = await http.get(Uri.parse(url));

        // Extract the date from the GET response body
        var data = jsonDecode(response.body) as List<dynamic>;
        dateFromGraphCurrently = DateTime.parse(data[0]['timestamp']);
      }

      // Successful communication with the server
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.trim() != '[]') {
          print("Response not empty"); // DEBUG
          var data = jsonDecode(response.body) as List<dynamic>;

          // Extract the date from the POST response body
          dateFromGraphCurrently = DateTime.parse(data[0]['timestamp']);

          // Create a list to store the temperature data
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
          print("Making pop-up"); // DEBUG

          // Show a pop-up dialog only if it hasn't been shown before or a new date is selected
          if (selectedDate != null) {
            // Reset the current time range
            setState(() {
              currentGraphTimeRange = null;
            });

            // Show a pop-up dialog
            showDialog(
              context: _scaffoldKey.currentContext!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('No Data Available'),
                  content: const Text(
                      'Something went wrong, please try again. Make sure you select the time range chronologically'),
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
        print('Error: ${response.statusCode}'); // DEBUG
        // You may want to display an error message or handle it in some way
      }

      // Return true to indicate a successful fetch
      return true;
    } catch (e) {
      print('Failed to fetch data: $e'); // DEBUG
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(35.0, 10, 35.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DatePickerWidget(
                          onDateSelected: (date) {
                            print("Calling Datepickerwidget"); // DEBUG

                            // Save the selected date for later use in the TimePickerWidget
                            setState(() {
                              selectedDate = date;
                            });

                            // Reset the current time range
                            setState(() {
                              currentGraphTimeRange = null;
                            });

                            // After the user has selected a date, update the graph
                            fetchData(selectedDate: selectedDate);
                          },
                          initialDate: graphDate,
                        ),
                      ),
                      // Width between the DatePickerWidget and TimePickerWidget buttons
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: TimePickerWidget(
                          onTimeSelected: (selectedTimeRange) {
                            print(
                                "Selected Start Time: ${selectedTimeRange.startTime}"); // DEBUG
                            print(
                                "Selected End Time: ${selectedTimeRange.endTime}"); // DEBUG
                            print("Date: $selectedDate"); // DEBUG

                            // Pass the selected time range to page itself
                            setState(() {
                              currentGraphTimeRange = selectedTimeRange;
                            });
                            // After the user has selected a time range, update the graph
                            fetchData(
                              selectedDate: dateFromGraphCurrently,
                              selectedStartTime: selectedTimeRange.startTime,
                              selectedEndTime: selectedTimeRange.endTime,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              // Height between the buttons and the text
              const SizedBox(height: 15.0),
              if (currentGraphTimeRange != null && isGraphLoaded)
                Text(
                  'Current time range: ${currentGraphTimeRange?.startTime.format(context)} to ${currentGraphTimeRange?.endTime.format(context)}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )
              else if (isGraphLoaded)
                const Text(
                  "Currently showing all measurements of the day.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )
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
