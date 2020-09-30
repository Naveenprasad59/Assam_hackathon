import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/Screens/loading_screen.dart';
import 'package:hackathon_app/Screens/registerscreen.dart';
import 'package:hackathon_app/constants.dart';

class LoginScreen extends StatelessWidget {
  static const id = "login_screen";
  String email;
  String pass;
  bool isWrong = false;
  bool isNotVisible = true;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Safety App',
                style: TextStyle(
                  color: maincolor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
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
                obscureText: true,
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
              ButtonTheme(
                buttonColor: maincolor,
                minWidth: 200,
                child: RaisedButton(
                  onPressed: () async {
                    try {
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: pass);
                      Navigator.pushNamed(context, LoadingScreen.id);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
                child: Text(
                  'New User?Sign up Here',
                  style: TextStyle(
                    color: maincolor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
