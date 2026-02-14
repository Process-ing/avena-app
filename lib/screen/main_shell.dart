import 'package:flutter/material.dart';
import 'package:avena/screen/home.dart';
import 'package:avena/screen/cook_book.dart';
import 'package:avena/screen/pantry_screen.dart';
import 'package:avena/screen/profile.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _goToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageList = [
      HomeScreen(onProfilePressed: () => _goToProfile(context)),
      CookBookScreen(onProfilePressed: () => _goToProfile(context)),
      PantryScreen(onProfilePressed: () => _goToProfile(context)),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: ''),
        ],
      ),
    );
  }
}