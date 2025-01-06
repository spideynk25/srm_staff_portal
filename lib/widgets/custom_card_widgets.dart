import 'package:flutter/material.dart';

class CustomCardWidgets extends StatelessWidget {
  final String name;
  final String imagePath; // Updated to use image
  final Function() onTap;

  const CustomCardWidgets({
    super.key,
    required this.name,
    required this.imagePath, // Updated to use image
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
        tileColor: Colors.white,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            imagePath, // Display image
            width: 40, // Set width
            height: 40, // Set height
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
