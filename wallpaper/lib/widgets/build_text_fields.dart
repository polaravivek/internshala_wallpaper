import 'package:flutter/material.dart';

TextField buildTextField(String title, TextEditingController controller,
    bool obscure, TextInputType typeOfKeyboard) {
  return TextField(
    keyboardType: typeOfKeyboard,
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
      hintText: title,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
