

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_test_soban/test1/Auth/api.dart';
import 'package:note_test_soban/test1/Auth/service_Auth.dart';


class NotesScreen extends StatefulWidget {
  final Map<String,dynamic> userData;
   NotesScreen({super.key,required this.userData});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List colorNote = [
    Color(0xFFE0BBE4),
    Color(0xFFFFD6A5),
    Color(0xFFA0C4FF),
    Color(0xFFFFF5BA),
    Color(0xFFFFADAD),
    Color(0xFFFFDAC1),
    Color(0xFFCBF3F0),
  ];
  String? picUrl = '';

  //all about load user funtion that using in dropdown button to fetch user data
  List user = [];
  late Map<String, dynamic> selectedUser;

  // Show bottom sheet for adding new note
  Future<void> userPic() async {
    if (Api.user != null) {
      picUrl = Api.user.photoURL;
    }
  }

  void initState() {
    super.initState();
    userPic();
    loadUser();
    selectedUser=widget.userData;

  }

  Future<void> loadUser() async {
    final fetchUser = await ServiceAuth.fetchAllUser();
    print("✅ Users fetched: $fetchUser");
    setState(()  {
      user = fetchUser;
    });
  }

  void _showAddNoteBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff222421),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Notes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                fillColor: Color(0xff393939),
                filled: true,
                labelText: 'Notes Title',
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                fillColor: Color(0xff393939),
                filled: true,
                labelText: 'Notes Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    await ServiceAuth.addNoteToFirebase(
                      context: context,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      selectedUser: selectedUser
                    );
                  },
                  child: const Text('Add Notes'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Add note to Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('my Notes'),
        centerTitle: true,


          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: PopupMenuButton<Map<String, dynamic>>(
                tooltip: 'Select account',
                onSelected: (value) {
                  print("✅ Selected user: $value");
                  setState(() {
                    selectedUser = value;
                  });
                },
                itemBuilder: (context) => user.map((userData) {
                  return PopupMenuItem<Map<String, dynamic>>(
                    value: userData,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: userData['urlImage'] != null
                              ? NetworkImage(userData['urlImage'])
                              : null,
                          child: userData['urlImage'] == null
                              ? const Icon(Icons.person, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            userData['email'],
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                child: selectedUser != null
                    ? CircleAvatar(
                  radius: 18,
                  backgroundImage: selectedUser['urlImage'] != null
                      ? NetworkImage(selectedUser['urlImage'])
                      : null,
                  child: selectedUser['urlImage'] == null
                      ? const Icon(Icons.person, size: 18)
                      : null,
                )
                    : const Icon(Icons.account_circle, color: Colors.white),
              ),
            ),


          ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .doc(selectedUser['uid'])
            .collection('note')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          final notes = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final color = colorNote[index % colorNote.length];
              final note = notes[index];
              final data = note.data() as Map<String, dynamic>;

              return Card(
                color: color,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          data['description'] ?? 'No Description',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteBottomSheet,
        // onPressed:()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
