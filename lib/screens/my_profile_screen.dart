// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../providers/auth_provider.dart';
// import '../providers/player_provider.dart';
// import 'edit_profile_screen.dart';
// import 'my_player_profile_screen.dart';
//
// class MyProfileScreen extends StatelessWidget {
//   const MyProfileScreen({Key? key}) : super(key: key);
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
//               // App Bar with Profile Photo
//               SliverAppBar(
//                 expandedHeight: 280,
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
//                     tooltip: 'প্রোফাইল সম্পাদনা',
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.logout),
//                     onPressed: () {
//                       _showLogoutDialog(context, authProvider);
//                     },
//                     tooltip: 'লগআউট',
//                   ),
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xFF0F3460),
//                           Color(0xFF16213E),
//                         ],
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 80),
//                         // Profile Avatar (without photo upload)
//                         Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF0F3460),
//                                 Color(0xFF1A5490),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 4,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 blurRadius: 15,
//                                 spreadRadius: 3,
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Text(
//                               user.fullName.isNotEmpty
//                                   ? user.fullName[0].toUpperCase()
//                                   : 'U',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 48,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         // Name
//                         Text(
//                           user.fullName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         // Email
//                         Text(
//                           user.email,
//                           style: const TextStyle(
//                             color: Colors.white60,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
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
//   Widget _buildInfoCard({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
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
//                   Navigator.pushReplacementNamed(context, '/signup');
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
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import 'edit_profile_screen.dart';
import 'my_player_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text(
                'প্রোফাইল লোড হচ্ছে...',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Profile Photo
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
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

                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0F3460),
                          Color(0xFF16213E),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        // Profile Avatar (without photo upload)
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0F3460),
                                Color(0xFF1A5490),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        icon: Icons.person,
                        children: [
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'পূর্ণ নাম',
                            value: user.fullName,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'ইমেইল',
                            value: user.email,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.wc,
                            label: 'লিঙ্গ',
                            value: user.gender,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.cake,
                            label: 'জন্ম তারিখ',
                            value: DateFormat('dd MMMM yyyy')
                                .format(user.dateOfBirth),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Location Information Card
                      _buildInfoCard(
                        title: 'ঠিকানা',
                        icon: Icons.location_on,
                        children: [
                          _buildInfoRow(
                            icon: Icons.location_city,
                            label: 'বিভাগ',
                            value: user.division,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.map,
                            label: 'জেলা',
                            value: user.district,
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.place,
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
                        children: [
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: 'যোগদানের তারিখ',
                            value: DateFormat('dd MMMM yyyy')
                                .format(user.createdAt),
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildInfoRow(
                            icon: Icons.fingerprint,
                            label: 'ইউজার আইডি',
                            value: user.uid.substring(0, 12) + '...',
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
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

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white54,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}