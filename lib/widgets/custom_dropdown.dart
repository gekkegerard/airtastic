import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialSelection;
  final void Function(String) onSelected;

  const CustomDropdown({
    required this.items,
    required this.initialSelection,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.initialSelection,
      onSelected: (String? value) {
        if (value != null) {
          setState(() {
            dropdownValue = value;
          });
          widget.onSelected(value);
        }
      },
      dropdownMenuEntries:
          widget.items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
