import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime initialDate;

  const DatePickerWidget(
      {super.key, required this.onDateSelected, required this.initialDate});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  // Initialize the selected user date with the current date
  DateTime _selectedDate = DateTime.now();

  // Parse the dates and store them in a list
  List<DateTime> selectableDates = [];

  // Add a variable to store the last selected date
  DateTime? _lastSelectedDate;

  // Loading indicator to show progress
  bool _isLoading = true;

  @override
  void initState() {
    print('initing date picker widget');
    super.initState();
    _fetchDatesFromServer();
  }

  // Fetch the data from the server response
  Future<void> _fetchDatesFromServer() async {
    try {
      List<DateTime> dates = await getDatesFromServer();
      setState(() {
        selectableDates = dates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching dates: $e'); // DEBUG
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch dates from the server')),
      );
    }
  }

  // Do a GET request for the available dates from the server
  Future<List<DateTime>> getDatesFromServer() async {
    List<DateTime> listOfAllDates = [];
    try {
      List<Map<String, dynamic>> datesFromServer;
      const String url =
          'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_unique_dates.php'; // Returns a list of all unique dates in the database

      // Send a GET request to the server
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        datesFromServer =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        if (datesFromServer.isEmpty) {
          throw Exception('Server returned an empty unique dates list');
        }
      } else {
        throw Exception('Failed to load the unique dates from the server');
      }

      // Decode the JSON response and cast it to a list of strings
      datesFromServer =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      // print("Dates from server: $datesFromServer"); // DEBUG

      // Parse the dates and store them in a list
      setState(() {
        listOfAllDates = datesFromServer
            .map((dateMap) => DateTime.parse(dateMap['date']))
            .toList();
      });
    } catch (e) {
      // Handle the error by showing a message to the user
      print('Error unique dates: $e'); // DEBUG

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to fetch unique dates from the server')),
      );
    }

    // Return the dates from the server
    return listOfAllDates;
  }

  // Execute this function when the date picker is pressed
  Future<void> _selectDate(BuildContext context) async {
    final DateTime dateNow = DateTime.now();
    final DateTime? picked = await showDatePicker(
      helpText: "Show measurements of a date",
      context: context,
      initialDate: widget.initialDate,
      firstDate: DateTime(2023, 11, 16),
      lastDate: dateNow,
      selectableDayPredicate: (DateTime date) {
        // Only allow dates from the server to be selectable
        return selectableDates.any((selectableDate) =>
            date.year == selectableDate.year &&
            date.month == selectableDate.month &&
            date.day == selectableDate.day);
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
            ),
          ),
          child: child!,
        );
      },
    );

    // Check if the picked date is the same as the last selected date
    if (picked != null && picked == _lastSelectedDate) {
      // If it is the same date, force the onDateSelected callback to trigger
      widget.onDateSelected(_selectedDate);
    }

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Update the last selected date
        _lastSelectedDate = picked;
      });
      widget.onDateSelected(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator(); // or any loading indicator
    } else {
      return ElevatedButton(
        onPressed: () => _selectDate(context),
        style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[600],
        ),
        child: const Text('Select Date'),
      );
    }
  }
}
