import 'package:flutter/material.dart';

class DetailedRow extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  const DetailedRow({super.key, required this.label, this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 8, 49, 110)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                Text(
                  value ?? "N/A",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}