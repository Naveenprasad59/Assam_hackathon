import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hackathon_app/Screens/loading_screen.dart';
import 'package:hackathon_app/constants.dart';

class RegisterScreen extends StatelessWidget {
  static const id = "register_screen";
  String email;
  String pass;
  String mobilenum;
  String emergency_contact;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text(
          'Register ',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Password'),
                  onChanged: (value) {
                    pass = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Mobile Number'),
                  onChanged: (value) {
                    mobilenum = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Emergency Contact'),
                  onChanged: (value) {
                    emergency_contact = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                ButtonTheme(
                  buttonColor: maincolor,
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        final user = await _auth.createUserWithEmailAndPassword(
                            email: email, password: pass);
                        await _store.collection('Users').doc(email).set({
                          'email': email,
                          'emergency': emergency_contact,
                          'mobile': mobilenum,
                          'no_of_complaints': 0,
                        });
                        Navigator.pushNamed(context, LoadingScreen.id);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
