import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class AddNoteBottomSheet extends StatefulWidget {
  final Function(String title, Timestamp date) onAddNote;

  const AddNoteBottomSheet({Key? key, required this.onAddNote})
      : super(key: key);

  @override
  _AddNoteBottomSheetState createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitNote() {
    if (_titleController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      final DateTime combinedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      final Timestamp dateTimestamp = Timestamp.fromDate(combinedDateTime);
      widget.onAddNote(
        _titleController.text,
        dateTimestamp,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Eslatma nomi',
            border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          _buildPickerRow(
            context,
            'Tanlash',
            _selectedDate == null
                ? 'Eslatma sanasi ->'
                : 'Picked Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
            _pickDate,
          ),
          const SizedBox(height: 20),
          _buildPickerRow(
            context,
            'Tanlash',
            _selectedTime == null
                ? 'Eslatma vaqti ->'
                : 'Picked Time: ${_selectedTime!.format(context)}',
            _pickTime,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitNote,
            child: const Text('Qo\'shish'),
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget _buildPickerRow(BuildContext context, String buttonText,
      String displayText, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(displayText),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}