import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/Screens/casualscreen.dart';
import 'package:hackathon_app/Screens/loading_screen.dart';
import 'package:hackathon_app/Screens/loginScreen.dart';
import 'package:hackathon_app/Screens/registerscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        CasualScreen.id: (context) => CasualScreen(),
        LoadingScreen.id: (context) => LoadingScreen(),
      },
    );
  }
}
