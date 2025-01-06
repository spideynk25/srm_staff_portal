import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final TabBar? tabBar;

  const CustomAppBar({super.key, required this.title, this.actions, this.tabBar});

  @override
  Size get preferredSize =>   Size.fromHeight(kToolbarHeight + (tabBar != null ? 50.0 : 0.0));

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 8, 49, 110), 
              Color.fromARGB(255, 20, 100, 200), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent, // Make the AppBar background transparent
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: actions,
          bottom: tabBar,
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
