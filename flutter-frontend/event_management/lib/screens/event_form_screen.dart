import 'package:event_management/models/event.dart';
import 'package:event_management/services/api_service.dart';
import 'package:flutter/material.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormState();
}

class _EventFormState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String location = '';
  DateTime? startDate;
  DateTime? endDate;
  String status = 'upcoming';

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate() ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please complete all fields.")));
      return;
    }

    final event = Event(
      title: title,
      description: description,
      location: location,
      startDate: startDate!,
      endDate: endDate!,
      status: status,
    );

    await ApiService.createEvent(event);
    Navigator.pop(context);
  }

  Future<void> _pickDate(bool isStart) async {
    DateTime initial = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Title required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (val) => location = val,
              ),
              SizedBox(height: 10),
              Text(
                "Start Date: ${startDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}",
              ),
              ElevatedButton(
                onPressed: () => _pickDate(true),
                child: Text("Select Start Date"),
              ),
              SizedBox(height: 10),
              Text(
                "End Date: ${endDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}",
              ),
              ElevatedButton(
                onPressed: () => _pickDate(false),
                child: Text("Select End Date"),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['upcoming', 'ongoing', 'completed']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => status = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitEvent, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
