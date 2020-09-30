import 'package:flutter/material.dart';
import 'package:hackathon_app/constants.dart';
class ReusableCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 15.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              color: maincolor,
              size: 80,
            ),
            SizedBox(height: 15,),
            Text(
              'Home',
            ),
          ],
        ),
      ),
    );
  }
}
