import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _role = 'vendor';

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<AuthBloc>().add(LoginRequested(email, password, _role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  // Fallback if 'message' is not defined in AuthFailure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login Failed')),
                  );
                } else if (state is AuthAuthenticated) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline_rounded,
                        size: 64, color: Color(0xFFfa6404)),
                    const SizedBox(height: 16),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 8),
                    const Text("Login to your account",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _role,
                            decoration: const InputDecoration(
                              labelText: "Select Role",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'vendor', child: Text('Vendor')),
                              DropdownMenuItem(
                                  value: 'customer', child: Text('Customer')),
                            ],
                            onChanged: (value) =>
                                setState(() => _role = value!),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFfa6404),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isLoading ? null : _login,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text("Login",
                                      style: TextStyle(fontSize: 16,color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("Don't have an account? Sign up",
                        style: TextStyle(color: Colors.grey)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
