import 'package:flutter/material.dart';
import 'package:srm_staff_portal/widgets/custom_app_bar.dart';
import 'package:srm_staff_portal/widgets/custom_drawer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }
}