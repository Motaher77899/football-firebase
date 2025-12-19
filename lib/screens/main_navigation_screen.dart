// // import 'package:flutter/material.dart';
// //
// // import 'home_screen.dart';
// // import 'favourite_screen.dart';
// // import 'community_screen.dart';
// // import 'more_screen.dart';
// //
// // class MainNavigationScreen extends StatefulWidget {
// //   const MainNavigationScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// // }
// //
// // class _MainNavigationScreenState extends State<MainNavigationScreen> {
// //   int _currentIndex = 0;
// //
// //   final List<Widget> _screens = [
// //     const HomeScreen(),
// //     const FavouriteScreen(),
// //     const CommunityScreen(),
// //     const MoreScreen(),
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: IndexedStack(
// //         index: _currentIndex,
// //         children: _screens,
// //       ),
// //       bottomNavigationBar: Container(
// //         decoration: BoxDecoration(
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.3),
// //               blurRadius: 10,
// //               offset: const Offset(0, -3),
// //             ),
// //           ],
// //         ),
// //         child: BottomNavigationBar(
// //           currentIndex: _currentIndex,
// //           onTap: (index) {
// //             setState(() {
// //               _currentIndex = index;
// //             });
// //           },
// //           type: BottomNavigationBarType.fixed,
// //           backgroundColor: const Color(0xFF16213E),
// //           selectedItemColor: const Color(0xFF0F3460),
// //           unselectedItemColor: Colors.white54,
// //           selectedLabelStyle: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 12,
// //           ),
// //           unselectedLabelStyle: const TextStyle(
// //             fontSize: 12,
// //           ),
// //           items: const [
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.home_outlined),
// //               activeIcon: Icon(Icons.home),
// //               label: 'Home',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.favorite_outline),
// //               activeIcon: Icon(Icons.favorite),
// //               label: 'Favourite',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.groups_outlined),
// //               activeIcon: Icon(Icons.groups),
// //               label: 'Community',
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.menu),
// //               activeIcon: Icon(Icons.menu_open),
// //               label: 'More',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Haptic feedback এর জন্য
//
// import 'home_screen.dart';
// import 'favourite_screen.dart';
// import 'community_screen.dart';
// import 'more_screen.dart';
//
// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const FavouriteScreen(),
//     const CommunityScreen(),
//     const MoreScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E), // অ্যাপের মূল ব্যাকগ্রাউন্ড
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       // বোটম বারটিকে প্রফেশনাল করতে স্ট্যাক বা কন্টেইনার ব্যবহার করা হয়েছে
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16, top: 8),
//         decoration: const BoxDecoration(
//           color: Color(0xFF1A1A2E), // বারের পেছনের ব্যাকগ্রাউন্ড
//         ),
//         child: Container(
//           height: 65,
//           decoration: BoxDecoration(
//             color: const Color(0xFF16213E), // বারের মূল রঙ
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.4),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//             border: Border.all(
//               color: Colors.white.withOpacity(0.05),
//               width: 1,
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: BottomNavigationBar(
//               currentIndex: _currentIndex,
//               onTap: (index) {
//                 HapticFeedback.lightImpact(); // হালকা ভাইব্রেশন যা প্রফেশনাল ফিল দেয়
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: Colors.transparent, // কন্টেইনারের রঙ ব্যবহার হবে
//               elevation: 0,
//               selectedItemColor: const Color(0xFF28A745), // নিওন গ্রিন বা আপনার পছন্দের রঙ
//               unselectedItemColor: Colors.white38,
//               showSelectedLabels: true,
//               showUnselectedLabels: false, // আনসিলেক্টেড লেবেল হাইড করলে মডার্ন দেখায়
//               selectedLabelStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//                 letterSpacing: 0.5,
//               ),
//               items: [
//                 _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
//                 _buildNavItem(Icons.favorite_outline, Icons.favorite, 'Favourite', 1),
//                 _buildNavItem(Icons.groups_outlined, Icons.groups, 'Community', 2),
//                 _buildNavItem(Icons.menu, Icons.menu_open, 'More', 3),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // আইটেমগুলোকে ক্লিন রাখার জন্য হেল্পার মেথড
//   BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, String label, int index) {
//     return BottomNavigationBarItem(
//       icon: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(4),
//         child: Icon(icon),
//       ),
//       activeIcon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF28A745).withOpacity(0.15),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(activeIcon),
//       ),
//       label: label,
//     );
//   }
// }

import 'package:flutter/material.dart';

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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // হোয়াটসঅ্যাপের মতো খুব পাতলা একটি বর্ডার লাইন
          Container(
            height: 0.5,
            color: Colors.white.withOpacity(0.1),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color(0xFF16213E), // বারের ব্যাকগ্রাউন্ড
              splashColor: Colors.transparent,     // ট্যাপ করলে ছড়াবে না
              highlightColor: Colors.transparent,  // ট্যাপ হাইলাইট অফ
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFF16213E),
              elevation: 0,
              selectedItemColor: const Color(0xFF28A745), // হোয়াটসঅ্যাপের মতো সবুজ রঙ
              unselectedItemColor: Colors.white54,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              // লেবেল এবং আইকনের মাঝের গ্যাপ হোয়াটসঅ্যাপের মতো ঠিক করা
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.favorite_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.favorite),
                  ),
                  label: 'Favourite',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.groups_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.groups),
                  ),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.menu),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.menu_open),
                  ),
                  label: 'More',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}