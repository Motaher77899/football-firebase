// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/auth_provider.dart';
// // import '../widgets/my_profile_card.dart';
// // import 'edit_profile_screen.dart';
// //
// // class MyProfileScreen extends StatelessWidget {
// //   const MyProfileScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF1A1A2E),
// //       body: Consumer<AuthProvider>(
// //         builder: (context, authProvider, child) {
// //           final user = authProvider.currentUser;
// //
// //           if (user == null) {
// //             return const Center(
// //               child: Text(
// //                 'প্রোফাইল লোড হচ্ছে...',
// //                 style: TextStyle(color: Colors.white),
// //               ),
// //             );
// //           }
// //
// //           return CustomScrollView(
// //             slivers: [
// //               // App Bar with Profile
// //               SliverAppBar(
// //                 expandedHeight: 220,
// //                 floating: false,
// //                 pinned: true,
// //                 backgroundColor: const Color(0xFF16213E),
// //                 iconTheme: const IconThemeData(color: Colors.white),
// //                 actions: [
// //                   IconButton(
// //                     icon: const Icon(Icons.edit),
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => const EditProfileScreen(),
// //                         ),
// //                       );
// //                     },
// //                     tooltip: 'প্রোফাইল সম্পাদনা',
// //                   ),
// //                 ],
// //                 flexibleSpace: FlexibleSpaceBar(
// //                   // 🚨 এখানে নতুন MyProfileCard ব্যবহার করা হচ্ছে 🚨
// //                   background: MyProfileCard(
// //                     fullName: user.fullName,
// //                     profilePhotoUrl: user.profilePhotoUrl, email:user.email,
// //                   ),
// //                 ),
// //               ),
// //
// //               // Profile Information
// //               SliverToBoxAdapter(
// //                 child: Padding(
// //                   // ... (বাকি কোড অপরিবর্তিত)
// //                   padding: const EdgeInsets.all(20),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Personal Information Card
// //                       _buildInfoCard(
// //                         title: 'ব্যক্তিগত তথ্য',
// //                         icon: Icons.person,
// //                         children: [
// //                           _buildInfoRow(
// //                             icon: Icons.person_outline,
// //                             label: 'পূর্ণ নাম',
// //                             value: user.fullName,
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.email_outlined,
// //                             label: 'ইমেইল',
// //                             value: user.email,
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.wc,
// //                             label: 'লিঙ্গ',
// //                             value: user.gender,
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.cake,
// //                             label: 'জন্ম তারিখ',
// //                             value: DateFormat('dd MMMM yyyy')
// //                                 .format(user.dateOfBirth),
// //                           ),
// //                         ],
// //                       ),
// //
// //                       const SizedBox(height: 20),
// //
// //                       // Location Information Card
// //                       _buildInfoCard(
// //                         title: 'ঠিকানা',
// //                         icon: Icons.location_on,
// //                         children: [
// //                           _buildInfoRow(
// //                             icon: Icons.location_city,
// //                             label: 'বিভাগ',
// //                             value: user.division,
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.map,
// //                             label: 'জেলা',
// //                             value: user.district,
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.place,
// //                             label: 'উপজেলা',
// //                             value: user.upazila,
// //                           ),
// //                         ],
// //                       ),
// //
// //                       const SizedBox(height: 20),
// //
// //                       // Account Information Card
// //                       _buildInfoCard(
// //                         title: 'অ্যাকাউন্ট তথ্য',
// //                         icon: Icons.info_outline,
// //                         children: [
// //                           _buildInfoRow(
// //                             icon: Icons.calendar_today,
// //                             label: 'যোগদানের তারিখ',
// //                             value: DateFormat('dd MMMM yyyy')
// //                                 .format(user.createdAt),
// //                           ),
// //                           const Divider(color: Colors.white24, height: 24),
// //                           _buildInfoRow(
// //                             icon: Icons.fingerprint,
// //                             label: 'ইউজার আইডি',
// //                             value: user.uid.substring(0, 12) + '...',
// //                           ),
// //                         ],
// //                       ),
// //
// //                       const SizedBox(height: 40),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   // --- Utility Widgets and Dialogs ---
// //   // _buildInfoCard, _buildInfoRow, এবং _showLogoutDialog মেথডগুলো অপরিবর্তিত থাকবে
// //
// //   Widget _buildInfoCard({
// //     required String title,
// //     required IconData icon,
// //     required List<Widget> children,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [
// //             Color(0xFF16213E),
// //             Color(0xFF0F3460),
// //           ],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.2),
// //             blurRadius: 10,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(10),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Icon(
// //                   icon,
// //                   color: Colors.white,
// //                   size: 24,
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //           ...children,
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoRow({
// //     required IconData icon,
// //     required String label,
// //     required String value,
// //   }) {
// //     return Row(
// //       children: [
// //         Icon(
// //           icon,
// //           color: Colors.white54,
// //           size: 20,
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 label,
// //                 style: const TextStyle(
// //                   color: Colors.white54,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 value,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           backgroundColor: const Color(0xFF16213E),
// //           title: const Text(
// //             'লগআউট',
// //             style: TextStyle(color: Colors.white),
// //           ),
// //           content: const Text(
// //             'আপনি কি লগআউট করতে চান?',
// //             style: TextStyle(color: Colors.white70),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('না'),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 await authProvider.signOut();
// //                 if (context.mounted) {
// //                   // '/login' রুটে যেতে চাইলে নিশ্চিত করুন এটি আপনার অ্যাপে সংজ্ঞায়িত আছে
// //                   Navigator.pushReplacementNamed(context, '/login');
// //                 }
// //               },
// //               child: const Text(
// //                 'হ্যাঁ',
// //                 style: TextStyle(color: Colors.red),
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../providers/auth_provider.dart';
// import '../widgets/my_player_card.dart';
// import 'edit_profile_screen.dart';
//
// class MyProfileScreen extends StatelessWidget {
//   const MyProfileScreen({Key? key}) : super(key: key);
//
//   // --- ছবি নির্বাচন ও আপলোডের মেথড ---
//   Future<void> _pickAndUploadImage(BuildContext context) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     if (authProvider.isLoading) return; // লোডিং চলাকালীন ডাবল ট্যাপ ইগনোর করা
//
//     final ImagePicker picker = ImagePicker();
//     // গ্যালারি থেকে ছবি নির্বাচন
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//
//     if (image != null) {
//       // ছবি আপলোড শুরু
//       bool success = await authProvider.updateProfilePhoto(File(image.path));
//
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               success
//                   ? 'প্রোফাইল ছবি সফলভাবে আপডেট হয়েছে'
//                   : authProvider.errorMessage ?? 'ছবি আপলোড ব্যর্থ হয়েছে',
//             ),
//             backgroundColor: success ? Colors.green : Colors.red,
//           ),
//         );
//       }
//     }
//   }
//   // --- মেথড শেষ ---
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           final user = authProvider.currentUser;
//
//           if (user == null) {
//             return const Center(
//               child: Text(
//                 'প্রোফাইল লোড হচ্ছে...',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }
//
//           return CustomScrollView(
//             slivers: [
//               // App Bar with Profile
//               SliverAppBar(
//                 expandedHeight: 280, // উচ্চতা বাড়ানো হলো
//                 floating: false,
//                 pinned: true,
//                 backgroundColor: const Color(0xFF16213E),
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const EditProfileScreen(),
//                         ),
//                       );
//                     },
//                     tooltip: 'ব্যক্তিগত তথ্য সম্পাদনা',
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.logout),
//                     onPressed: () => _showLogoutDialog(context, authProvider),
//                     tooltip: 'লগআউট',
//                   ),
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   centerTitle: true,
//                   titlePadding: EdgeInsets.zero,
//                   background: Stack(
//                     children: [
//                       MyPlayerCard(
//                         playerName: user.fullName,
//                         profilePhotoUrl: user.profilePhotoUrl,
//                         email: user.email,
//                       ),
//
//                       // ছবি আপলোডের জন্য ট্যাপ এরিয়া এবং আইকন
//                       Positioned(
//                         bottom: 40, // ছবির নিচে
//                         right: MediaQuery.of(context).size.width / 2 - 40, // ডানদিকে সরানোর জন্য
//                         child: GestureDetector(
//                           onTap: authProvider.isLoading ? null : () => _pickAndUploadImage(context),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF0F3460),
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 2),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.5),
//                                   blurRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: authProvider.isLoading
//                                 ? const SizedBox(
//                                 width: 18,
//                                 height: 18,
//                                 child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
//                             )
//                                 : const Icon(
//                               Icons.auto_fix_high, // <--- সুন্দর ম্যাজিক ওয়ান্ড আইকন
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Loading indicator যখন ছবি আপলোড হচ্ছে (পুরো স্ক্রিন কভার করবে)
//                       if (authProvider.isLoading)
//                         Container(
//                           color: Colors.black54.withOpacity(0.1),
//                           alignment: Alignment.center,
//                           // Note: যেহেতু লোডিং আইকন উপরেই যুক্ত করা হয়েছে, তাই এটি বাদ দিলেও চলবে।
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Profile Information
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Personal Information Card
//                       _buildInfoCard(
//                         title: 'ব্যক্তিগত তথ্য',
//                         icon: Icons.person,
//                         children: [
//                           _buildInfoRow(
//                             icon: Icons.person_outline,
//                             label: 'পূর্ণ নাম',
//                             value: user.fullName,
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.email_outlined,
//                             label: 'ইমেইল',
//                             value: user.email,
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.wc,
//                             label: 'লিঙ্গ',
//                             value: user.gender,
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.cake,
//                             label: 'জন্ম তারিখ',
//                             value: DateFormat('dd MMMM yyyy')
//                                 .format(user.dateOfBirth),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Location Information Card
//                       _buildInfoCard(
//                         title: 'ঠিকানা',
//                         icon: Icons.location_on,
//                         children: [
//                           _buildInfoRow(
//                             icon: Icons.location_city,
//                             label: 'বিভাগ',
//                             value: user.division,
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.map,
//                             label: 'জেলা',
//                             value: user.district,
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.place,
//                             label: 'উপজেলা',
//                             value: user.upazila,
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Account Information Card
//                       _buildInfoCard(
//                         title: 'অ্যাকাউন্ট তথ্য',
//                         icon: Icons.info_outline,
//                         children: [
//                           _buildInfoRow(
//                             icon: Icons.calendar_today,
//                             label: 'যোগদানের তারিখ',
//                             value: DateFormat('dd MMMM yyyy')
//                                 .format(user.createdAt),
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildInfoRow(
//                             icon: Icons.fingerprint,
//                             label: 'ইউজার আইডি',
//                             value: user.uid.substring(0, 12) + '...',
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // --- Utility Widgets and Dialogs ---
//
//   Widget _buildInfoCard({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     // অপরিবর্তিত
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [
//             Color(0xFF16213E),
//             Color(0xFF0F3460),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     // অপরিবর্তিত
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white54,
//           size: 20,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white54,
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
//     // অপরিবর্তিত
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
//                 if (context.mounted) {
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
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  // ছবি নির্বাচন ও আপলোডের মেথড
  Future<void> _pickAndUploadImage(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isLoading) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      bool success = await authProvider.updateProfilePhoto(File(image.path));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    success
                        ? 'প্রোফাইল ছবি সফলভাবে আপডেট হয়েছে'
                        : authProvider.errorMessage ?? 'ছবি আপলোড ব্যর্থ হয়েছে',
                  ),
                ),
              ],
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF28A745),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Profile Header
              SliverAppBar(
                expandedHeight: 320,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
                actions: [
                  // Edit Button
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 22),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      tooltip: 'প্রোফাইল সম্পাদনা',
                    ),
                  ),
                  // Logout Button
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),

                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  background: _buildProfileHeader(context, user, authProvider),
                ),
              ),

              // Profile Information
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Card
                      _buildInfoCard(
                        title: 'ব্যক্তিগত তথ্য',
                        icon: Icons.person_outline,
                        iconColor: const Color(0xFF28A745),
                        children: [
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: 'পূর্ণ নাম',
                            value: user.fullName,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'ইমেইল',
                            value: user.email,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.wc_outlined,
                            label: 'লিঙ্গ',
                            value: user.gender,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.cake_outlined,
                            label: 'জন্ম তারিখ',
                            value: DateFormat('dd MMMM yyyy').format(user.dateOfBirth),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Location Information Card
                      _buildInfoCard(
                        title: 'ঠিকানা',
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFF0F6FFF),
                        children: [
                          _buildInfoRow(
                            icon: Icons.location_city_outlined,
                            label: 'বিভাগ',
                            value: user.division,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.map_outlined,
                            label: 'জেলা',
                            value: user.district,
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.place_outlined,
                            label: 'উপজেলা',
                            value: user.upazila,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Account Information Card
                      _buildInfoCard(
                        title: 'অ্যাকাউন্ট তথ্য',
                        icon: Icons.info_outline,
                        iconColor: const Color(0xFFFF9800),
                        children: [
                          _buildInfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'যোগদানের তারিখ',
                            value: DateFormat('dd MMMM yyyy').format(user.createdAt),
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildInfoRow(
                            icon: Icons.fingerprint,
                            label: 'ইউজার আইডি',
                            value: user.uid.substring(0, 16) + '...',
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ Professional Profile Header
  // ✅ Professional Profile Header with Beautiful Camera Button
  Widget _buildProfileHeader(BuildContext context, user, AuthProvider authProvider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F3460),
            Color(0xFF16213E),
            Color(0xFF1A5490),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Profile Photo with Upload Button
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Photo Container
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF28A745), Color(0xFF20C997)],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
                        ? Image.network(
                      user.profilePhotoUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Beautiful Upload Button (নতুন ডিজাইন)
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: authProvider.isLoading
                          ? null
                          : () => _pickAndUploadImage(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F6FFF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F6FFF).withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Name
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Email Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Professional Info Card
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF16213E).withOpacity(0.8),
            const Color(0xFF0F3460).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: iconColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  // ✅ Professional Info Row
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white54,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Logout Dialog

}