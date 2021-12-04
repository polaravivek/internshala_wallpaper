import 'package:flutter/material.dart';

showSnack({required BuildContext context, required String label}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        label,
        style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width / 2,
      duration: Duration(seconds: 2),
    ),
  );
}
