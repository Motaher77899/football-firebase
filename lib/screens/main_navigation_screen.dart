

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'favourite_screen.dart';
import 'community_screen.dart';
import 'more_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavouriteScreen(),
    const CommunityScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      // কীবোর্ড ওপেন হলে যেন ডিজাইন নষ্ট না হয়
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          // ভার্টিকাল প্যাডিং আরও কমানো হয়েছে (২ পিক্সেল)
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          height: 76, // মোট উচ্চতা সামান্য বাড়ানো হয়েছে কিন্তু প্যাডিং কমানো হয়েছে
          color: const Color(0xFF1A1A2E),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  HapticFeedback.selectionClick();
                  setState(() => _currentIndex = index);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color(0xFF28A745),
                unselectedItemColor: Colors.white30,
                // ওভারফ্লো এড়াতে ফন্ট সাইজ এবং গ্যাপ নিয়ন্ত্রণ
                selectedFontSize: 14,
                unselectedFontSize: 12,
                showUnselectedLabels: true,
                iconSize: 24,
                items: [
                  _buildNavItem(Icons.home_outlined, Icons.home, 'Home'),
                  _buildNavItem(Icons.favorite_outline, Icons.favorite, 'Favorite'),
                  _buildNavItem(Icons.groups_outlined, Icons.groups, 'Community'),
                  _buildNavItem(Icons.menu, Icons.menu_open, 'More'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF28A745).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}