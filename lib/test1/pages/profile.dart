import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Auth/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email='';

  String? picUrl='';
  String? userName='';
  String? phone='';

  @override
  void initState() {
    super.initState();
    userinfo();
  }

  @override
  // Set status bar color and icon brightness
  Future <void> userinfo()async{
    final user=Api.user;
    if(Api.user!=null){
      final uid=user.uid;
      final doc=await Api.firestore.collection('user').doc(uid).get();
      setState(() {
        email=doc['email']??'no mail';
        picUrl=Api.user.photoURL??'';
        userName=doc['name']??'no name';
        phone=doc['phone']??'phone ';

      });
       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfilemaiPage',style: GoogleFonts.poppins(fontSize: 22,fontWeight: FontWeight.w600),),
        centerTitle: true,
        elevation: 0,
      ),
      body:SafeArea(
        child: Center(
          child: Column(

            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150,),
              Container(

                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue

                ),
                child: picUrl != null && picUrl!.isNotEmpty
          ? ClipOval(child: Image.network(picUrl!, fit: BoxFit.cover))
              : Icon(Icons.person, size: 100),
              ),
              SizedBox(height: 20,),
              Text(userName != null && userName!.isNotEmpty ? userName! : "No name"),
              SizedBox(height: 10,),
              Text(email != null && email!.isNotEmpty ? email! : "No email"),
              SizedBox(height: 10,),
              Text(phone != null && phone!.isNotEmpty ? phone! : "No phone"),
            ],
          ),
        ),
      )
    );
  }
}

