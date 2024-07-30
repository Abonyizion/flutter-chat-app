
import 'package:flutter/material.dart';
import '../bottomNavBar/MainPage.dart';
import '../bottomNavBar/Profile.dart';
import '../bottomNavBar/Setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  final List<Widget> pages = [
    const MainPage(),
    const ProfilePage(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'profile'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings'
            ),
          ],

          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
