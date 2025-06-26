import 'package:e_commerce/features/cart/presentation/screens/cart_screen.dart';
import 'package:e_commerce/features/users/presentation/screens/ProfileScreen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
     HomeScreen(),
     CartScreen(),   // Mark these as `const` if possible for performance
     ProfileScreen(),
     
     
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem customNavItem(
      IconData icon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      label: label,
      icon: TweenAnimationBuilder<double>(
        tween:
            Tween<double>(begin: isSelected ? 1.0 : 0.9, end: isSelected ? 1.2 : 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Icon(icon, color: isSelected ? Colors.black : Colors.grey),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          customNavItem(Icons.home_rounded, 'Home', _currentIndex == 0),
          customNavItem(Icons.shopping_cart, 'Cart', _currentIndex == 1),
          customNavItem(Icons.person_rounded, 'Profile', _currentIndex == 3),
        ],
      ),
    );
  }
}
