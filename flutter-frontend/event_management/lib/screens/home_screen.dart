import 'package:event_management/models/event.dart';
import 'package:event_management/providers/auth_provider.dart';
import 'package:event_management/providers/event_provider.dart';
import 'package:event_management/screens/event_form_screen.dart';
import 'package:event_management/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];
  String? role;
  void loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role')!;
  }

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void deleteEvent(int? id) async {
    await ApiService.deleteEvent(id!);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<EventProvider>(context);
    provider.fetchEvents();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              authProvider.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("Your Events"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          provider.reset();
          await provider.fetchEvents();
        },
        child: ListView.builder(
          itemCount: provider.events.length + 1,
          itemBuilder: (ctx, i) {
            if (i < provider.events.length) {
              final event = provider.events[i];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.startDate.toString()),
                trailing: role == 'admin'
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          deleteEvent(event.id);
                          provider.reset();
                          await provider.fetchEvents();
                        },
                      )
                    : null,
              );
            } else {
              return Center(
                child: provider.hasMore
                    ? CircularProgressIndicator()
                    : Text("No more events"),
              );
            }
          },
        ),
      ),
      floatingActionButton: role == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EventFormScreen()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
