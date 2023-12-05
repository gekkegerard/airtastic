import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedDate = DateTime.now();

  // Add a variable to store the last selected date
  DateTime? _lastSelectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime dateNow = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: DateTime(2023, 11, 16),
      lastDate: dateNow,
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
    return OutlinedButton(
      onPressed: () => _selectDate(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[600],
      ),
      child: const Text('Select Date'),
    );
  }
}
