//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/auth_provider.dart';
// import '../providers/player_provider.dart';
// import 'my_profile_screen.dart';
// import 'team_list_screen.dart';
// import 'all_players_screen.dart';
// import 'tournament_list_screen.dart'; // 🔥 নতুন import
//
// class MoreScreen extends StatelessWidget {
//   const MoreScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Profile Section
//               Consumer<AuthProvider>(
//                 builder: (context, authProvider, child) {
//                   final user = authProvider.currentUser;
//
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF16213E),
//                           Color(0xFF0F3460),
//                         ],
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         // Avatar
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF0F3460),
//                                 Color(0xFF1A5490),
//                               ],
//                             ),
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 3,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               user?.fullName.isNotEmpty == true
//                                   ? user!.fullName[0].toUpperCase()
//                                   : 'U',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user?.fullName ?? 'User',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           user?.email ?? '',
//                           style: const TextStyle(
//                             color: Colors.white60,
//                             fontSize: 14,
//                           ),
//                         ),
//
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const MyProfileScreen(),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.person),
//                           label: const Text('প্রোফাইল দেখুন'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF28A745),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               // Menu Items - 🔥 আপডেট করা ফুটবল মেনু
//               _buildMenuSection(
//                 context,
//                 title: 'ফুটবল',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.shield,
//                     title: 'সকল টিম',
//                     subtitle: 'টিম তালিকা দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TeamListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.sports_soccer,
//                     title: 'খেলোয়াড়',
//                     subtitle: 'সব খেলোয়াড়দের দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AllPlayersScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.emoji_events,
//                     title: '🏆 টুর্নামেন্ট', // 🔥 নতুন!
//                     subtitle: 'সব টুর্নামেন্ট দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TournamentListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               _buildMenuSection(
//                 context,
//                 title: 'সেটিংস',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.notifications,
//                     title: 'নোটিফিকেশন',
//                     subtitle: 'নোটিফিকেশন সেটিংস',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Coming Soon')),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.language,
//                     title: 'ভাষা',
//                     subtitle: 'বাংলা',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Coming Soon')),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.dark_mode,
//                     title: 'থিম',
//                     subtitle: 'Dark Mode',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Coming Soon')),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               _buildMenuSection(
//                 context,
//                 title: 'সাপোর্ট',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.help_outline,
//                     title: 'সাহায্য',
//                     subtitle: 'FAQ এবং সাপোর্ট',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Coming Soon')),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.info_outline,
//                     title: 'অ্যাপ সম্পর্কে',
//                     subtitle: 'Version 1.0.0',
//                     onTap: () {
//                       _showAboutDialog(context);
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.share,
//                     title: 'শেয়ার করুন',
//                     subtitle: 'বন্ধুদের সাথে শেয়ার করুন',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Coming Soon')),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               // Logout Button
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           _showLogoutDialog(context, authProvider);
//                         },
//                         icon: const Icon(Icons.logout),
//                         label: const Text(
//                           'লগআউট',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuSection(
//       BuildContext context, {
//         required String title,
//         required List<_MenuItem> items,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white54,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFF16213E),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: items.map((item) {
//                 return _buildMenuItem(context, item);
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(BuildContext context, _MenuItem item) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F3460),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(
//           item.icon,
//           color: Colors.white,
//           size: 24,
//         ),
//       ),
//       title: Text(
//         item.title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       subtitle: Text(
//         item.subtitle,
//         style: const TextStyle(
//           color: Colors.white54,
//           fontSize: 13,
//         ),
//       ),
//       trailing: const Icon(
//         Icons.arrow_forward_ios,
//         color: Colors.white54,
//         size: 16,
//       ),
//       onTap: item.onTap,
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF16213E),
//           title: const Text(
//             'লগআউট',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: const Text(
//             'আপনি কি লগআউট করতে চান?',
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('না'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await authProvider.signOut();
//                 // Clear player data
//                 if (context.mounted) {
//                   Provider.of<PlayerProvider>(context, listen: false)
//                       .clearPlayer();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 }
//               },
//               child: const Text(
//                 'হ্যাঁ',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showAboutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF16213E),
//           title: const Text(
//             '⚽ ফুটবল লাইভ স্কোর',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: const Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Version: 1.0.0',
//                 style: TextStyle(color: Colors.white70),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'বাংলাদেশের সবচেয়ে জনপ্রিয় ফুটবল লাইভ স্কোর অ্যাপ',
//                 style: TextStyle(color: Colors.white70),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 '© 2024 Football Live Score',
//                 style: TextStyle(color: Colors.white54, fontSize: 12),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('ঠিক আছে'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class _MenuItem {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   _MenuItem({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
// }

//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/auth_provider.dart';
// import '../providers/player_provider.dart';
// import 'my_profile_screen.dart';
// import 'team_list_screen.dart';
// import 'all_players_screen.dart';
// import 'tournament_list_screen.dart';
//
// class MoreScreen extends StatelessWidget {
//   const MoreScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Profile Section
//               Consumer<AuthProvider>(
//                 builder: (context, authProvider, child) {
//                   final user = authProvider.currentUser;
//
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF16213E),
//                           Color(0xFF0F3460),
//                         ],
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         // Avatar
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF0F3460),
//                                 Color(0xFF1A5490),
//                               ],
//                             ),
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 3,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               user?.fullName.isNotEmpty == true
//                                   ? user!.fullName[0].toUpperCase()
//                                   : 'U',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user?.fullName ?? 'User',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           user?.email ?? '',
//                           style: const TextStyle(
//                             color: Colors.white60,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const MyProfileScreen(),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.person),
//                           label: const Text('প্রোফাইল দেখুন'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF28A745),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               // Football Menu Section
//               _buildMenuSection(
//                 context,
//                 title: 'ফুটবল',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.emoji_events,
//                     title: '🏆 টুর্নামেন্ট',
//                     subtitle: 'সব টুর্নামেন্ট দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TournamentListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.shield,
//                     title: 'সকল টিম',
//                     subtitle: 'টিম তালিকা দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TeamListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.sports_soccer,
//                     title: 'খেলোয়াড়',
//                     subtitle: 'সব খেলোয়াড়দের দেখুন',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AllPlayersScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               // Settings Section
//               _buildMenuSection(
//                 context,
//                 title: 'সেটিংস',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.notifications,
//                     title: 'নোটিফিকেশন',
//                     subtitle: 'নোটিফিকেশন সেটিংস',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('শীঘ্রই আসছে'),
//                           backgroundColor: Color(0xFF28A745),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.language,
//                     title: 'ভাষা',
//                     subtitle: 'বাংলা',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('শীঘ্রই আসছে'),
//                           backgroundColor: Color(0xFF28A745),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.dark_mode,
//                     title: 'থিম',
//                     subtitle: 'Dark Mode',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('শীঘ্রই আসছে'),
//                           backgroundColor: Color(0xFF28A745),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               // Support Section
//               _buildMenuSection(
//                 context,
//                 title: 'সাপোর্ট',
//                 items: [
//                   _MenuItem(
//                     icon: Icons.help_outline,
//                     title: 'সাহায্য',
//                     subtitle: 'FAQ এবং সাপোর্ট',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('শীঘ্রই আসছে'),
//                           backgroundColor: Color(0xFF28A745),
//                         ),
//                       );
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.info_outline,
//                     title: 'অ্যাপ সম্পর্কে',
//                     subtitle: 'Version 1.0.0',
//                     onTap: () {
//                       _showAboutDialog(context);
//                     },
//                   ),
//                   _MenuItem(
//                     icon: Icons.share,
//                     title: 'শেয়ার করুন',
//                     subtitle: 'বন্ধুদের সাথে শেয়ার করুন',
//                     onTap: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('শীঘ্রই আসছে'),
//                           backgroundColor: Color(0xFF28A745),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               // Logout Button
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           _showLogoutDialog(context, authProvider);
//                         },
//                         icon: const Icon(Icons.logout),
//                         label: const Text(
//                           'লগআউট',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuSection(
//       BuildContext context, {
//         required String title,
//         required List<_MenuItem> items,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white54,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [
//                   Color(0xFF16213E),
//                   Color(0xFF0F3460),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: items.asMap().entries.map((entry) {
//                 final index = entry.key;
//                 final item = entry.value;
//                 final isLast = index == items.length - 1;
//
//                 return Column(
//                   children: [
//                     _buildMenuItem(context, item),
//                     if (!isLast)
//                       const Divider(
//                         color: Colors.white12,
//                         height: 1,
//                         indent: 72,
//                         endIndent: 16,
//                       ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(BuildContext context, _MenuItem item) {
//     return InkWell(
//       onTap: item.onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color(0xFF0F3460),
//                     Color(0xFF1A5490),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 item.icon,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.subtitle,
//                     style: const TextStyle(
//                       color: Colors.white54,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.white54,
//               size: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF16213E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: const [
//               Icon(Icons.logout, color: Colors.red, size: 28),
//               SizedBox(width: 12),
//               Text(
//                 'লগআউট',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//           content: const Text(
//             'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?',
//             style: TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white70,
//               ),
//               child: const Text('না'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await authProvider.signOut();
//                 if (context.mounted) {
//                   Provider.of<PlayerProvider>(context, listen: false)
//                       .clearPlayer();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('হ্যাঁ, লগআউট'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showAboutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF16213E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: const [
//               Text(
//                 '⚽',
//                 style: TextStyle(fontSize: 28),
//               ),
//               SizedBox(width: 12),
//               Text(
//                 'ফুটবল লাইভ স্কোর',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow('Version', '1.0.0'),
//               const SizedBox(height: 12),
//               const Divider(color: Colors.white24),
//               const SizedBox(height: 12),
//               const Text(
//                 'বাংলাদেশের সবচেয়ে জনপ্রিয় ফুটবল লাইভ স্কোর অ্যাপ',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 '© 2024 Football Live Score',
//                 style: TextStyle(
//                   color: Colors.white54,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF28A745),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('ঠিক আছে'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _MenuItem {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   _MenuItem({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import 'my_profile_screen.dart';
import 'team_list_screen.dart';
import 'all_players_screen.dart';
import 'tournament_list_screen.dart';
import 'rankings_screen.dart'; // Add this import

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.currentUser;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0F3460),
                                Color(0xFF1A5490),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user?.fullName.isNotEmpty == true
                                  ? user!.fullName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.fullName ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person),
                          label: const Text('প্রোফাইল দেখুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF28A745),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Football Menu Section
              _buildMenuSection(
                context,
                title: 'ফুটবল',
                items: [
                  _MenuItem(
                    icon: Icons.emoji_events,
                    title: '🏆 টুর্নামেন্ট',
                    subtitle: 'সব টুর্নামেন্ট দেখুন',
                    gradientColors: const [Color(0xFFFFB800), Color(0xFFFF8C00)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TournamentListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.leaderboard,
                    title: 'র‍্যাঙ্কিং',
                    subtitle: 'টিম এবং খেলোয়াড়ের র‍্যাঙ্কিং',
                    gradientColors: const [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RankingsScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.shield,
                    title: 'সকল টিম',
                    subtitle: 'টিম তালিকা দেখুন',
                    gradientColors: const [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeamListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.sports_soccer,
                    title: 'খেলোয়াড়',
                    subtitle: 'সব খেলোয়াড়দের দেখুন',
                    gradientColors: const [Color(0xFF38EF7D), Color(0xFF11998E)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllPlayersScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Settings Section
              _buildMenuSection(
                context,
                title: 'সেটিংস',
                items: [
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'নোটিফিকেশন',
                    subtitle: 'নোটিফিকেশন সেটিংস',
                    gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('শীঘ্রই আসছে'),
                          backgroundColor: Color(0xFF28A745),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    title: 'ভাষা',
                    subtitle: 'বাংলা',
                    gradientColors: const [Color(0xFFFA709A), Color(0xFFFEE140)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('শীঘ্রই আসছে'),
                          backgroundColor: Color(0xFF28A745),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.dark_mode,
                    title: 'থিম',
                    subtitle: 'Dark Mode',
                    gradientColors: const [Color(0xFF30CFD0), Color(0xFF330867)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('শীঘ্রই আসছে'),
                          backgroundColor: Color(0xFF28A745),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Support Section
              _buildMenuSection(
                context,
                title: 'সাপোর্ট',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'সাহায্য',
                    subtitle: 'FAQ এবং সাপোর্ট',
                    gradientColors: const [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('শীঘ্রই আসছে'),
                          backgroundColor: Color(0xFF28A745),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'অ্যাপ সম্পর্কে',
                    subtitle: 'Version 1.0.0',
                    gradientColors: const [Color(0xFFFFAFBD), Color(0xFFFFC3A0)],
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.share,
                    title: 'শেয়ার করুন',
                    subtitle: 'বন্ধুদের সাথে শেয়ার করুন',
                    gradientColors: const [Color(0xFF2196F3), Color(0xFF21CBF3)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('শীঘ্রই আসছে'),
                          backgroundColor: Color(0xFF28A745),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context, authProvider);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'লগআউট',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, {
        required String title,
        required List<_MenuItem> items,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    _buildMenuItem(context, item),
                    if (!isLast)
                      const Divider(
                        color: Colors.white12,
                        height: 1,
                        indent: 72,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.gradientColors,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: item.gradientColors[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text(
                'লগআউট',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Text(
            'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
              ),
              child: const Text('না'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Provider.of<PlayerProvider>(context, listen: false)
                      .clearPlayer();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('হ্যাঁ, লগআউট'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Text(
                '⚽',
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(width: 12),
              Text(
                'ফুটবল লাইভ স্কোর',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Version', '1.0.0'),
              const SizedBox(height: 12),
              const Divider(color: Colors.white24),
              const SizedBox(height: 12),
              const Text(
                'বাংলাদেশের সবচেয়ে জনপ্রিয় ফুটবল লাইভ স্কোর অ্যাপ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '© 2024 Football Live Score',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradientColors = const [Color(0xFF0F3460), Color(0xFF1A5490)],
    required this.onTap,
  });
}