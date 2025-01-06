import 'package:flutter/material.dart';

class LmsCustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  const LmsCustomListTile(
      {super.key, required this.onTap, required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Card(
        elevation: 2,
        color: Colors.white60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          tileColor: Colors.white60,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Center(
            child: Text(name, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
