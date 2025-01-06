import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<dynamic> items;
  final String Function(dynamic item) valueExtractor;
  final String Function(dynamic item) displayTextExtractor;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.valueExtractor,
    required this.displayTextExtractor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration:const InputDecoration(
        fillColor: Color.fromARGB(255, 243, 239, 239),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 8, 49, 110),
            width: 2.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      icon: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 8, 49, 110),
        ),
        width: 20,
        height: 20,
        child: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 18,
        ),
      ),
      hint: Text(hint),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: valueExtractor(item),
          child: Text(displayTextExtractor(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}