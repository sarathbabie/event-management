import 'package:event_management/providers/auth_provider.dart';
import 'package:event_management/screens/home_screen.dart';
import 'package:event_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  void login(BuildContext context) async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter credentials')));
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final data = await authProvider.login(
      emailController.text,
      passwordController.text,
    );
    if (data != null) {
      final token = data['token'];
      Map<String, dynamic> user = data['user'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setInt('userId', user['id']);
      prefs.setString('role', user['role']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: TextStyle(color: primaryColor, fontSize: 22)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
