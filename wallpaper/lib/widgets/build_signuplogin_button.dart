import 'package:flutter/material.dart';

GestureDetector buildSignupLoginButton(
    {required BuildContext context,
    required label,
    required Function() tapFunction}) {
  return GestureDetector(
    onTap: tapFunction,
    child: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'poppinsThin',
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
