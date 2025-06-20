import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_test_soban/test1/Dry/globelfile.dart';

import 'api.dart';

class ServiceAuth {
  static Future<bool> SignUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await Api.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await Api.firestore.collection('user').doc(Api.user.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'uid': Api.user.uid,
        'created_at': Timestamp.now(),
      });

      Global.scaffoldMessage(context, 'successfully signUp');
      return true;
    } catch (e) {
      // Optionally handle errors here
      Global.scaffoldMessage(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  static Future<void> addNoteToFirebase({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    if (title.isNotEmpty) {
      await Api.firestore
          .collection('user')
          .doc(Api.user.uid)
          .collection('note')
          .add({
            'title': title,
            'description': description,
            'timestamp': FieldValue.serverTimestamp(),
          });
      title.clear();
      description.clear();
      Navigator.pop(context);
    }

  }

  static Future<void> createUserAndEmailSubcollection({
    required String name,
    required String email,
    required String password,
    required String phone,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Step 1: Sign up user with Firebase Auth
      UserCredential userCredential = await Api.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Step 2: Save user data in Firestore under 'users/uid'
      await Api.firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'uid': uid,
        'created_at': Timestamp.now(),
      });

      // Step 3: Create a subcollection with the email (safe format)
      final safeEmail = email.replaceAll('.', '_').replaceAll('@', '_');

      await Api.firestore
          .collection('users')
          .doc(uid)
          .collection(safeEmail)
          .doc('meta') // optional document
          .set({'created': Timestamp.now(), 'status': 'active'});

      onSuccess("User created and subcollection saved");
    } catch (e) {
      onError("Error: ${e.toString()}");
    }
  }

  static Future <List<Map<String,dynamic>>> fetchAllUser() async{
    final snapshot=await Api.firestore.collection('user').get();
    return snapshot.docs.map((doc)=>doc.data()as Map<String,dynamic>).toList();
  }
}


extension on String {
  void clear() {}
}
