import 'dart:convert';
import 'package:event_management/models/event.dart';
import 'package:event_management/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<Map?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );
    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  static Future<List<Event>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final res = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return (json.decode(res.body) as List)
        .map((e) => Event.fromJson(e))
        .toList();
  }

  static Future<bool> createEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    int? userId = prefs.getInt('userId');
    final res = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'title': event.title,
        'description': event.description,
        'location': event.location,
        'start_date': event.startDate.toIso8601String(),
        'end_date': event.endDate.toIso8601String(),
        'status': event.status,
        'created_by': userId,
      },
    );
    return res.statusCode == 200;
  }

  static Future<bool> deleteEvent(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final res = await http.delete(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return res.statusCode == 204;
  }
}
