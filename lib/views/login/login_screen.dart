import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _role = 'vendor';
  bool _loading = false;

  void loginUser() async {
    setState(() => _loading = true);
    final api = ApiService();

    final user = await api.login(emailController.text.trim(), passwordController.text.trim(), _role);

    setState(() => _loading = false);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", user.token);
      prefs.setString("userId", user.id);
      prefs.setString("role", user.role);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            DropdownButton<String>(
              value: _role,
              onChanged: (value) => setState(() => _role = value!),
              items: const [
                DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
              ],
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: loginUser, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
