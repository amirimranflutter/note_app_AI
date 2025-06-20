import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_test_soban/test1/Auth/service_Auth.dart';
import 'package:note_test_soban/test1/Dry/globelfile.dart';
import 'package:note_test_soban/test1/pages/noteScreen.dart';

import '../Dry/custom button.dart';
import '../Dry/custom textField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose controllers when not needed
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Create Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // 👤 Account Icon
              const Icon(Icons.person_add, size: 80, color: Colors.white),

              const SizedBox(height: 24),

              // Title
              Text(
                'Welcome to Sign Up',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Create an account to continue',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Full Name
              CustomTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.person,
                controller: fullNameController,
              ),
              const SizedBox(height: 16),

              // Email
              CustomTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                controller: emailController,
              ),
              const SizedBox(height: 16),

              // Password
              CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock,
                controller: passwordController,
              ),
              const SizedBox(height: 16),

              // Phone
              CustomTextField(
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                controller: phoneController,
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              isLoading
                  ? Global.customLoader()
                  : CustomButton(
                      width: double.infinity,
                      height: 50,
                      color: Colors.deepPurple,
                      text: 'Sign Up',

                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        FocusScope.of(context).unfocus();
                        bool issuccess=await ServiceAuth.SignUp(
                          name: fullNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          phone: phoneController.text,
                          context: context,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        Future.delayed(Duration.zero, () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => NotesScreen()),
                          );
                        });
                      },
                    ),

              const SizedBox(height: 30),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to Login Page
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
