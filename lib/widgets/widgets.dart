import 'package:flutter/material.dart';

const textInputDeoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Color(0xFFee7b64))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Color(0xFFee7b64))),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Color(0xFFee7b64))));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplaced(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
