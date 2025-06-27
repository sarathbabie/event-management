// providers/auth_provider.dart
import 'package:event_management/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool get isAuth => _token != null;
  String? get token => _token;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future login(String email, String password) async {
    final res = await ApiService.login(email, password);

    if (res != null) {
      _token = res['token'];
      notifyListeners();
      return res; // no error
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }
}
