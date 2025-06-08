import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
  ),
);

const detailText = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Colors.white
);

const headings = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w900,
  color: Colors.blue
);

void mySnackBar(context, color, text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text))
  );
}