
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Dry/custom button.dart';
import '../Dry/custom widget.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  elevation: 0,
  title: Text('Login to Note App',style: GoogleFonts.poppins(
    fontWeight: FontWeight.w800
  ),),
  centerTitle:true,
),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),

            // 🔒 Lock Icon
            const Icon(Icons.lock, size: 80, color: Colors.white),

            const SizedBox(height: 24),

            // Title
            Text(
              'Welcome to Login',
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.white,

                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
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

            // 📧 Email Field
            const CustomTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),

            const SizedBox(height: 16),

            // 🔑 Password Field
            const CustomTextField(
              hintText: 'Password',
              prefixIcon: Icons.lock,
            ),

            const SizedBox(height: 12),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Add your logic here
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
              text: 'Sign In',
              onPressed: () {
                // Handle login
              },
            ),

            const SizedBox(height: 32),

            // Don't have account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",


                ),
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
