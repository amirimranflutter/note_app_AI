import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_test_soban/test1/Auth/service_Auth.dart';
import 'package:note_test_soban/test1/Dry/globelfile.dart';
import 'package:note_test_soban/test1/Dry/img_picker_dialog.dart';
import 'package:note_test_soban/test1/pages/noteScreen.dart';

import '../Dry/custom button.dart';
import '../Dry/custom textField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File? _selectedImg;
  String? _enteredImgUrl;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => Imag_Picker_Dialog(
        onImageSelected: (String? url) {
          setState(() {
            _enteredImgUrl = url;
          });
        },
      ),
    );
  }

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
              Stack(
                children:[ Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3,color: Colors.white),
                    shape: BoxShape.circle
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImg != null
                        ? FileImage(_selectedImg!)
                        : _enteredImgUrl != null
                        ? NetworkImage(_enteredImgUrl!)
                        : null,
                    child: _selectedImg == null && _enteredImgUrl == null
                        ? Icon(Icons.person_add, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                Positioned(bottom: 9,right: 9
                    ,child: GestureDetector(
                      onTap: showImagePickerDialog,
                      child: Container(
                        
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(.7),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white,strokeAlign: BorderSide.strokeAlignOutside,width: 2)
                          ),
                          child:Padding(padding: EdgeInsets.all(4),child: Icon(CupertinoIcons.camera,size: 16,))) ,
                    ))
                ]
              ),

              // IconButton(
              //   icon: Icon(Icons.person_add, size: 80, color: Colors.white),
              //   onPressed: () {
              //     showImagePickerDialog();
              //   },
              // ),
              SizedBox(height: 24),

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
                        String? imagPathorUrl;

                        FocusScope.of(context).unfocus();
                       if(_enteredImgUrl!=null&&_enteredImgUrl!.isNotEmpty){
                          imagPathorUrl=_enteredImgUrl;
                        }
                        bool issuccess = await ServiceAuth.SignUp(name: fullNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          phone: phoneController.text,
                          context: context,
                          picUrl: imagPathorUrl!,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if(issuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => NotesScreen()),
                          );
                        };
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
