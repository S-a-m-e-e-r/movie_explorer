import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import Home Screen
import 'search_screen.dart'; // Import Search Screen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // This will track the selected index for BottomNavigationBar
  int _currentIndex = 0;

  // List of screens to navigate between
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex, // Keep track of the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected screen when tapped
          });
        },
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        selectedIconTheme: IconThemeData(color: Colors.black87),
        selectedItemColor: Colors.white, // Color for selected item label
        unselectedItemColor: Colors.grey, // Color for unselected item labels
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.png',
                scale: 22.0, color: Colors.white), // Icon for Home tab
            label: 'Home', // Label for Home tab
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/search.png',
                scale: 22.0, color: Colors.white),
            label: 'Search', // Label for Search tab
          ),
        ],
      ),
    );
  }
}
