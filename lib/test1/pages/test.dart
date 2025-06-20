import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExtendedNoteTreePage extends StatefulWidget {
  @override
  _ExtendedNoteTreePageState createState() => _ExtendedNoteTreePageState();
}

class _ExtendedNoteTreePageState extends State<ExtendedNoteTreePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final noteTitleController = TextEditingController();
  final noteDescriptionController = TextEditingController();

  bool isLoading = false;
  String message = '';

  Future<void> createExtendedNoteTree({
    required String title,
    required String description,
    required String username,
    required String email,
    required String phone,
    required String noteTitle,
    required String noteDescription,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not logged in");
      }

      final uid = currentUser.uid;

      // Save user data
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'title': title,
        'description': description,
        'username': username,
        'email': email,
        'phone': phone,
        'created_at': Timestamp.now(),
      });

      // Add note document
      final noteRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('note')
          .add({
        'created_at': Timestamp.now(),
      });

      // Add subcollection with safe email
      final safeEmail = email.replaceAll('.', '_').replaceAll('@', '_');

      await noteRef.collection(safeEmail).doc('meta').set({
        'noteTitle': noteTitle,
        'noteDescription': noteDescription,
        'created_at': Timestamp.now(),
      });

      setState(() {
        message = "✅ Firestore tree created successfully!";
      });
    } catch (e) {
      setState(() {
        message = "❌ Error: ${e.toString()}";
      });
    }
  }

  void handleSubmit() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    await createExtendedNoteTree(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      noteTitle: noteTitleController.text.trim(),
      noteDescription: noteDescriptionController.text.trim(),
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nested Firestore Tree")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("User Info", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
            SizedBox(height: 20),
            Text("Note Info", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: noteTitleController, decoration: InputDecoration(labelText: "Note Title")),
            TextField(controller: noteDescriptionController, decoration: InputDecoration(labelText: "Note Description")),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleSubmit,
              child: Text("Create Firestore Tree"),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
