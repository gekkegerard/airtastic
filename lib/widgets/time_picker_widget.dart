import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  final Function(TimeRange) onTimeSelected;

  const TimePickerWidget({Key? key, required this.onTimeSelected})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

// Add a class to store the selected time range
class TimeRange {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeRange(this.startTime, this.endTime);
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;

  @override
  void initState() {
    super.initState();
    // Set the initial values for the selected time range
    _selectedStartTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    // Select Start Time
    final TimeOfDay? startTime = await showTimePicker(
      helpText: 'Select Starting Time',
      context: context,
      initialTime: _selectedStartTime,
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

    if (startTime != null) {
      // Store the context before the second showTimePicker call
      final secondContext = context;

      // Select End Time
      // ignore: use_build_context_synchronously
      final TimeOfDay? endTime = await showTimePicker(
        helpText: 'Select Ending Time',
        context: secondContext,
        initialTime: _selectedEndTime,
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

      // Second date has been selected
      if (endTime != null) {
        setState(() {
          _selectedStartTime = startTime;
          _selectedEndTime = endTime;
        });

        // Trigger the callback with the selected time range
        widget.onTimeSelected(TimeRange(_selectedStartTime, _selectedEndTime));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectTime(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[600],
      ),
      child: const Text('Select Time Range'),
    );
  }
}
