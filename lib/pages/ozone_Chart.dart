import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:airtastic/widgets/scatter_chart_widget.dart';
import 'package:airtastic/widgets/date_picker_widget.dart';
import 'package:airtastic/widgets/time_picker_widget.dart';

class OzoneChart extends StatefulWidget {
  const OzoneChart({super.key});

  @override
  State<OzoneChart> createState() => _OzoneChartState();
}

class _OzoneChartState extends State<OzoneChart> {
  // Create a GlobalKey to access the current context
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<OzoneData> ozoneDataList = [];
  late Timer _timer;
  final int refreshTime = 30; // Normal refresh time of the graph
  final int loadingRefreshTime =
      10; // Faster refresh time of the graph when troubles occur with the server
  bool isGraphLoaded =
      false; // Flag used to indicate that the graph is loaded for the date picker widget
  bool timeRangeIsValid =
      false; // Flag used to indicate that the selected time range has data in it, used in the displaying of the time range
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
      const String serverUrl =
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
        print("Making post request with date- and timerange"); // DEBUG
        response = await http.post(
          Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: encodedBody,
        );
      } else {
        // If no date is selected, use GET request to get the last day of measurements
        print("Making get request for all data from last date"); // DEBUG

        // Making a GET request, gets you the last day of measurements
        response = await http.get(Uri.parse(serverUrl));

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

          // Create a list to store the ozone data
          List<OzoneData> tempList = [];

          for (var entry in data) {
            DateTime timestamp = DateTime.parse(entry['timestamp']);
            double ozone = double.parse(entry['ozone_concentration']);
            bool ozoneMeasurementValid =
                entry['ozone_measurement_valid'] == "1" ? true : false;
            tempList.add(OzoneData(timestamp, ozone, ozoneMeasurementValid));
          }

          // Check if the widget is still in the widget tree before calling setState
          if (mounted) {
            setState(() {
              ozoneDataList = tempList;
              isGraphLoaded = true; // Used to display the DatePickerWidget
            });
          }

          // Got a response, so the time range is valid
          timeRangeIsValid = true; // Used to display the time range
        } else {
          // If the response body is empty, show a pop-up dialog
          print("Showing the pop-up"); // DEBUG

          // Show a pop-up dialog to indicate that there is no data available
          if (selectedDate != null) {
            // Show a pop-up dialog
            showDialog(
              context: _scaffoldKey.currentContext!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('No Data Available'),
                  content: const Text(
                      'Make sure that the time range you selected has data in it.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red, // Button text color to red
                      ),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }

          // Got empty response, so the time range is invalid
          timeRangeIsValid = false; // Used to display the time range
        }
      } else {
        // Handle non-200 status code (error)
        print('Error: ${response.statusCode}'); // DEBUG
      }

      // Return true to indicate a successful fetch
      return true;
    } catch (e) {
      print('Failed to fetch data: $e'); // DEBUG
      // Return false to indicate a failed fetch
      return false;
    }
  }

  // Function to find the range of valid ozone measurements in the dataset
  TimeRange findValidTimeRange() {
    if (ozoneDataList.isEmpty) {
      return TimeRange(TimeOfDay.now(), TimeOfDay.now());
    }

    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();

    for (var data in ozoneDataList) {
      if (data.ozoneMeasurementValid) {
        startTime = TimeOfDay.fromDateTime(data.timestamp);
        break;
      }
    }

    for (var i = ozoneDataList.length - 1; i >= 0; i--) {
      if (ozoneDataList[i].ozoneMeasurementValid) {
        endTime = TimeOfDay.fromDateTime(ozoneDataList[i].timestamp);
        break;
      }
    }

    return TimeRange(startTime, endTime);
  }

  @override
  Widget build(BuildContext context) {
    // Get the date of the first data point, if no data points are available, use the current date. Fix for crash
    DateTime graphDate = ozoneDataList.isNotEmpty
        ? ozoneDataList.first.timestamp
        : DateTime.now();
    final validTimeRange = findValidTimeRange();
    final currentTime = TimeOfDay.now();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Ozone'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ozoneDataList.isNotEmpty
                  ? Padding(
                      // Outer padding for the graph
                      padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
                      child: DataChart(
                        dataPoints: ozoneDataList
                            .map((data) => data.toDataPoint())
                            .toList(),
                        title: '      Ozone Chart',
                        xAxisLabel:
                            'Measurements of ${graphDate.day}-${graphDate.month}-${graphDate.year}',
                        yAxisLabel: 'Ozone concentration (PPB)',
                        yAxisUnit: ' PPB',
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
              if (ozoneDataList.isNotEmpty &&
                  isGraphLoaded) // Display DatePickerWidget only when the graph is loaded
                Padding(
                  // Outer padding for the DatePickerWidget and TimePickerWidget buttons
                  padding: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
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

                            // The selected date of the user is not the current date, cancel auto refresh since there will not be any new data
                            if (selectedDate!.day != DateTime.now().day) {
                              print(
                                  "Cancelling timer from datepicker"); // DEBUG
                              _timer.cancel();
                            }

                            // If the selected date is the current date, restart the timer
                            if (selectedDate!.day == DateTime.now().day &&
                                _timer.isActive == false) {
                              print(
                                  "Restarting timer from datepicker"); // DEBUG
                              _timer =
                                  Timer.periodic(Duration(seconds: refreshTime),
                                      (Timer timer) {
                                print("Triggered 30 second timer"); // DEBUG
                                fetchData();
                              });
                            }
                          },
                          initialDate: graphDate,
                        ),
                      ),
                      // Width between the DatePickerWidget and TimePickerWidget buttons
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TimePickerWidget(
                          onTimeSelected: (selectedTimeRange) async {
                            print(
                                "Selected Start Time: ${selectedTimeRange.startTime}"); // DEBUG
                            print(
                                "Selected End Time: ${selectedTimeRange.endTime}"); // DEBUG
                            print("Date: $selectedDate"); // DEBUG

                            // Pass the selected time range to page itself
                            setState(() {});

                            int hourDifference =
                                selectedTimeRange.endTime.hour -
                                    selectedTimeRange.startTime.hour;
                            int minuteDifference =
                                selectedTimeRange.endTime.minute -
                                    selectedTimeRange.startTime.minute;

                            // If the starting time is before the ending time
                            if (hourDifference > 0 ||
                                (hourDifference == 0 && minuteDifference > 0)) {
                              // After the user has selected a time range, get all the data points in that time range, wait for the response
                              await fetchData(
                                selectedDate: dateFromGraphCurrently,
                                selectedStartTime: selectedTimeRange.startTime,
                                selectedEndTime: selectedTimeRange.endTime,
                              );

                              // If the response is not empty, update the graph
                              if (timeRangeIsValid == true) {
                                currentGraphTimeRange = selectedTimeRange;
                              }

                              // Cancel auto refresh timer when a time range is selected
                              _timer.cancel();
                              print(
                                  "Cancelling timer from timepicker"); // DEBUG
                            } else {
                              // Starting time is after the ending time, show a pop-up dialog
                              showDialog(
                                context: _scaffoldKey.currentContext!,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('No Data Available'),
                                    content: const Text(
                                        'Make sure you select the time range chronologically.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors
                                              .red, // Button text color to red
                                        ),
                                        child: const Text(
                                          'OK',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Height between the buttons and the text
              const SizedBox(height: 15.0),
              // Display the time range indicator
              Text(
                // The graph has loaded and the time range is valid
                isGraphLoaded
                    ? (currentGraphTimeRange != null
                        ? 'Current time range: ${currentGraphTimeRange?.startTime.format(context)} to ${currentGraphTimeRange?.endTime.format(context)}'
                        : 'Currently showing all measurements of the day.')
                    : '',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),

              // Text widget to let the user know in which time range the ozone measurements are valid
              const SizedBox(height: 8.0),
              // There is a range of valid ozone measurements in the dataset
              if (isGraphLoaded &&
                  (validTimeRange.startTime.format(context) !=
                          currentTime.format(context) &&
                      validTimeRange.endTime.format(context) !=
                          currentTime.format(context)))
                Text(
                  'Ozone measurements valid between ${findValidTimeRange().startTime.format(context)} and ${findValidTimeRange().endTime.format(context)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )
              // No valid ozone measurements in the dataset
              else if (isGraphLoaded)
                const Text(
                  'No valid ozone measurements for that range.',
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

class OzoneData {
  final DateTime timestamp;
  final double ozone;
  final bool ozoneMeasurementValid;

  OzoneData(this.timestamp, this.ozone, this.ozoneMeasurementValid);

  // Conversion function
  DataPoint toDataPoint() {
    return DataPoint(timestamp, ozone);
  }
}
