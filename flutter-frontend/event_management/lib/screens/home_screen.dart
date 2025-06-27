import 'package:event_management/models/event.dart';
import 'package:event_management/screens/event_form_screen.dart';
import 'package:event_management/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];
  late String role;
  void loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role')!;
    events = await ApiService.getEvents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void deleteEvent(int? id) async {
    await ApiService.deleteEvent(id!);
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Events")),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.description ?? ''),
            trailing: role == 'admin'
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteEvent(event.id),
                  )
                : null,
          );
        },
      ),
      floatingActionButton: role == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EventFormScreen()),
                );
                loadEvents();
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
