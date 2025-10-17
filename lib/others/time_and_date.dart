import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final void Function(DateTime?)? onDateTimeSelected;

  const DateTimeInputField({
    super.key,
    required this.controller,
    this.label = 'Select Expiry Date & Time',
    this.onDateTimeSelected,
  });

  @override
  State<DateTimeInputField> createState() => _DateTimeInputFieldState();
}

class _DateTimeInputFieldState extends State<DateTimeInputField> {
  DateTime? _selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    // Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    // Combine both
    _selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Format for display
    final formatted = DateFormat(
      'dd/MM/yyyy hh:mm a',
    ).format(_selectedDateTime!);
    widget.controller.text = formatted;

    // Call callback
    if (widget.onDateTimeSelected != null) {
      widget.onDateTimeSelected!(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onTap: () => _selectDateTime(context),
    );
  }
}
