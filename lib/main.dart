import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_test_soban/firebase_options.dart';
import 'package:note_test_soban/test1/pages/noteScreen.dart';
import 'package:note_test_soban/test1/pages/profile.dart';
import 'package:note_test_soban/test1/pages/signUp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff222421),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white, // apply white to all body text
      displayColor: Colors.white, // apply white to titles/headlines
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff222421),
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    ),),
      home: NotesScreen(),
    );
  }
}
