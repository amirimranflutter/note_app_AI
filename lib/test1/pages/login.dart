import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Dry/custom button.dart';
import '../Dry/custom textField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Add controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Login to Note App',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),

            const Icon(Icons.lock, size: 80, color: Colors.white),

            const SizedBox(height: 24),

            Text(
              'Welcome to Login',
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please sign in to continue',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Email Field with controller
            CustomTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: emailController,
            ),

            const SizedBox(height: 16),

            // Password Field with controller
            CustomTextField(
              hintText: 'Password',
              prefixIcon: Icons.lock,
              controller: passwordController,
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot password logic
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login Button
            CustomButton(
              width: double.infinity,
              height: 50,
              color: Colors.deepPurple,
              text: 'Log In',
              onPressed: () {
                // Access text from controllers
                print("Email: ${emailController.text}");
                print("Password: ${passwordController.text}");
              },
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Navigate to sign up
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
