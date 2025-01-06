import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar show({required String title}) {
    return SnackBar(
      content: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(70),
      duration: const Duration(seconds: 3),
    );
  }
}
