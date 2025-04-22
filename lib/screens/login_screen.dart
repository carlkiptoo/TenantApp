import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String tenantEmail = 'tenant@tenant.com';
  final String password = 'tenant';

  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == tenantEmail && password == password) {
      setState(() {
        _isLoading = true;
      });

      // Navigator.pushReplacement(context,
      // MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    } else {

    ScaffoldMessenger.of(context,
    ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //
    //   Future.delayed(const Duration(seconds: 3), () {
    //     setState(() {
    //       _isLoading = false;
    //
    //       // Navigator.pushReplacement(context,
    //       //  MaterialPageRoute(builder: (_) => const HomeScreen()),
    //       // );
    //     });
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.withValues(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.home, size: 80, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  'Tenant Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter Password' : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('Login'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}