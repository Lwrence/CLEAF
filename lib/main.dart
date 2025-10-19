import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this import
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/care_library_screen.dart';
import 'screens/profile_screen.dart';


void main() {
  runApp(
    const ProviderScope( // Wrap the app with ProviderScope
      child: CLeafApp(),
    ),
  );
}

class CLeafApp extends StatelessWidget {
  const CLeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLeaf',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CatalogScreen(),
    ScheduleScreen(),
    CareLibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}