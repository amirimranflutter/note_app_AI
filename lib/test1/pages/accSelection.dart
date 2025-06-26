// ===========================================================
// 👉 account_selection_page.dart
// ===========================================================
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_test_soban/test1/Auth/service_Auth.dart';
import 'package:note_test_soban/test1/pages/noteScreen.dart';

class AccountSelectionPage extends StatefulWidget {
  const AccountSelectionPage({super.key});

  @override
  State<AccountSelectionPage> createState() => _AccountSelectionPageState();
}

class _AccountSelectionPageState extends State<AccountSelectionPage> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final fetched = await ServiceAuth.fetchAllUser();
    setState(() {
      _users = List<Map<String, dynamic>>.from(fetched);
      _loading = false;
    });
  }

  Future<void> _switchTo(Map<String, dynamic> userData) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NotesScreen(userData: userData),
      ),
    );
  }


  /// Opens the dialog containing the account list.
  void _showAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff4f635f),
          title:  Text('Select an account',style: GoogleFonts.poppins(color: Colors.white),),
          content: SizedBox(
            // Constrain height so the list is scrollable inside dialog
            height: 300,
            width: double.maxFinite,
            child: _users.isEmpty
                ? const Center(child: Text('No accounts found'))
                : ListView.separated(
              itemCount: _users.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final u = _users[index];
                return GestureDetector(
                  onTap: (){_switchTo;},
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: u['urlImage'] != null
                          ? NetworkImage(u['urlImage'])
                          : null,
                      child: u['urlImage'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(u['email'],style: GoogleFonts.poppins(color: Colors.white)),
                    onTap: () async {
                      Navigator.of(context).pop(); // close dialog first
                      await _switchTo(u);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Choose an Account',style: GoogleFonts.poppins(color: Colors.white))),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          icon: CircleAvatar(child: 
          const Icon(Icons.person)),
          label:  Text('Choose account',style: GoogleFonts.poppins(color: Colors.white),),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding:
            const EdgeInsets.symmetric(horizontal: 10
                , vertical: 10),
          ),
          onPressed: _showAccountDialog,
        ),
      ),
    );
  }
}
