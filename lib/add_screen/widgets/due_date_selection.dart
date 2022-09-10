import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDatePicker extends StatelessWidget {
  const DueDatePicker({Key? key, required this.selectedDate, required this.onDatePick})
      : super(key: key);

  final DateTime? selectedDate;
  final void Function() onDatePick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: selectedDate != null
          ? Text(DateFormat('dd.MM.yyyy').format(selectedDate!))
          : const Text("Datum wählen"),
      onPressed: onDatePick,
      style: ElevatedButton.styleFrom(
        primary: selectedDate != null ? null : Colors.grey,
      ),
    );
  }
}
