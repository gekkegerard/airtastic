import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool espIsActive = false; // Set this to false for a green circle
  String temperature = "?"; // Temperature in degrees Celsius
  String humidity = "?"; // Humidity in percent
  String ozone = "?"; // Ozone concentration in ppb
  bool ozoneMeasurementValid = false;
  DateTime lastDataPoint = DateTime(
      2000); // Initialize this with a placeholder date '2000-01-01 00:00:00.000'
  String uptimeESP = "?"; // Running time of the ESP in minutes

  @override
  void initState() {
    super.initState();
    // Try to get data initially
    fetchData(context).then((value) => setState(() {}));
  }

  Future<bool> fetchData(BuildContext context) async {
    try {
      const String serverUrl =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
      http.Response? response;

      // Create a body for the POST request, only request the last data point in the database
      Map<String, String> body = {
        'requestSize': "1",
      };

      // Encode the body to a string so it can be sent with the request
      String encodedBody = body.keys
          .map((key) => '$key=${Uri.encodeComponent(body[key]!)}')
          .join('&');

      // Send the POST request
      response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      // print("POST response from server:"); // DEBUG
      // print(response.body); // DEBUG

      var data = jsonDecode(response.body) as List<dynamic>;

      // Loop through the data and set the variables
      for (var entry in data) {
        lastDataPoint = DateTime.parse(entry['timestamp']);
        temperature = double.parse(entry['temperature']).toString();
        ozone = double.parse(entry['ozone_concentration']).toString();
        humidity = double.parse(entry['humidity']).toString();
        ozoneMeasurementValid =
            entry['ozone_measurement_valid'].toString().toLowerCase() == 'true';
        uptimeESP = double.parse(entry['uptime']).toStringAsFixed(0);
      }
      // Return true to indicate a successful fetch
      return true;
    } catch (e) {
      // Something went wrong
      // print(e.toString()); // DEBUG

      // Check if the widget is still active
      if (mounted) {
        // Let the user know that the fetch failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The webserver failed to respond.'),
          ),
        );
      }

      // Return false to indicate a failed fetch
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double paddingBetweenDataValues = 4;

    // Find out if the device has been active in the last 2 minutes
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(lastDataPoint);
    // Last measurement was less than 2 minutes ago
    if (difference.inMinutes < 2) {
      espIsActive = true;
    } else {
      espIsActive = false;
    }

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "This is the home page where you can see the latest data from your Airtastic device. Take a look around the app if you like. You can refresh the data by pressing the refresh button in the bottom right corner.",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              const SizedBox(
                  height:
                      30), // Spacer between introduction and active indicator
              const SizedBox(
                  height: 30), // Spacer between active indicator and data
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Last measurement",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: paddingBetweenDataValues),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Currently active: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: espIsActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: paddingBetweenDataValues),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Date: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  lastDataPoint != DateTime(2000)
                      ? Text(DateFormat('dd-MM-yyyy').format(lastDataPoint))
                      : const Text("?")
                ],
              ),
              const SizedBox(height: paddingBetweenDataValues),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Time: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  lastDataPoint != DateTime(2000)
                      ? Text(DateFormat('HH:mm:ss').format(lastDataPoint))
                      : const Text("?")
                ],
              ),
              const SizedBox(height: paddingBetweenDataValues),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'Temperature: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("$temperature °C"),
              ]),
              const SizedBox(height: paddingBetweenDataValues),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'Humidity: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("$humidity %"),
              ]),
              const SizedBox(height: paddingBetweenDataValues),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'Ozone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("$ozone PPB"),
              ]),
              const SizedBox(height: paddingBetweenDataValues), //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    espIsActive
                        ? 'Airtastic is currently online for $uptimeESP minutes.'
                        : 'Airtastic was last online for $uptimeESP minutes.',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh the data when the button is pressed
          fetchData(context).then((value) => setState(() {}));
        },
        backgroundColor: Colors.red[600],
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
