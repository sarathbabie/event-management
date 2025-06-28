import 'dart:convert';
import 'package:event_management/models/event.dart';
import 'package:event_management/services/api_service.dart';
import 'package:event_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/events?page=$_page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> newEvents = jsonBody['data'];
      _events.addAll(newEvents.map((e) => Event.fromJson(e)).toList());

      _hasMore = jsonBody['next_page_url'] != null;
      _page++;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> createEvent(Event event) async {
    final result = await ApiService.createEvent(event);
    if (result != null) {
      notifyListeners();
      return null;
    } else {
      return "Something went wrong!";
    }
  }

  void reset() {
    _events = [];
    _page = 1;
    _hasMore = true;
    notifyListeners();
  }
}
