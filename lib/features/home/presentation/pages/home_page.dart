import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/explore_page.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/home_quick_access_page.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/search_page.dart';
import 'package:srm_staff_portal/features/home/presentation/pages/settings_page.dart';
import 'package:srm_staff_portal/features/profile/presentation/pages/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeQuickAccessPage(),
    const ExplorePage(),
    const SearchPage(),
    const ProfilePage(isDrawer: true,),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        
        decoration: BoxDecoration(
          //color: Colors.white,
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 8, 49, 110),
              Color.fromARGB(255, 20, 100, 200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? const Icon(Icons.home_filled)
                    : const Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? const Icon(Icons.explore)
                    : const Icon(Icons.explore_outlined),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 2
                    ? const Icon(Icons.search_rounded)
                    : const Icon(Icons.search_outlined),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? const Icon(Icons.person)
                    : const Icon(Icons.person_outlined),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 4
                    ? const Icon(Icons.settings)
                    : const Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
