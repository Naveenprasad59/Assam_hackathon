import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_app/Screens/casualscreen.dart';

class LoadingScreen extends StatefulWidget {
  static const id = "loading_screen";
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude;
  double longitude;
  @override
  void initState() {
    getLocationData();
    super.initState();
  }

  void getLocationData() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CasualScreen(
          latitude: latitude,
          longitude: longitude,
        );
      }));
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
