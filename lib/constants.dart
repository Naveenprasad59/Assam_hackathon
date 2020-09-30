import 'package:flutter/material.dart';

const Color maincolor = Color(0xFFF2593C);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Your Email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: maincolor, width: 1.0),
    //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: maincolor, width: 2.0),
    //  borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kListTilestyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black26,
  fontWeight: FontWeight.w400,
);
