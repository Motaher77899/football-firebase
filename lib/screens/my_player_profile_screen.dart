// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
//
// import '../providers/player_provider.dart';
// import '../providers/auth_provider.dart';
//
// class MyPlayerProfileScreen extends StatefulWidget {
//   const MyPlayerProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyPlayerProfileScreen> createState() => _MyPlayerProfileScreenState();
// }
//
// class _MyPlayerProfileScreenState extends State<MyPlayerProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//     // ✅ Load player data when screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadPlayerData();
//     });
//   }
//
//   Future<void> _loadPlayerData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
//
//     if (authProvider.currentUser != null) {
//       if (playerProvider.myPlayer == null) {
//         await playerProvider.checkPlayerProfile(authProvider.currentUser!.uid);
//       }
//     }
//
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: Consumer<PlayerProvider>(
//         builder: (context, playerProvider, child) {
//           final player = playerProvider.myPlayer;
//
//           // ✅ Show loading if still checking
//           if (_isLoading) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(
//                     color: Color(0xFF28A745),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'প্লেয়ার প্রোফাইল লোড হচ্ছে...',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // ✅ Show error if no player after loading
//           if (player == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.error_outline,
//                     color: Colors.red,
//                     size: 64,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'প্লেয়ার প্রোফাইল পাওয়া যায়নি',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'দয়া করে Community থেকে প্রোফাইল তৈরি করুন',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back),
//                     label: const Text('ফিরে যান'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF28A745),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return CustomScrollView(
//             slivers: [
//               // App Bar
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
//                       _showEditPositionDialog(context, playerProvider);
//                     },
//                     tooltip: 'পজিশন পরিবর্তন',
//                   ),
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: _buildPlayerHeader(player),
//                 ),
//                 bottom: TabBar(
//                   controller: _tabController,
//                   indicatorColor: const Color(0xFF28A745),
//                   indicatorWeight: 3,
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.white54,
//                   tabs: const [
//                     Tab(text: 'তথ্য'),
//                     Tab(text: 'আমার ম্যাচ'),
//                   ],
//                 ),
//               ),
//
//               // Content
//               SliverFillRemaining(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildInfoTab(player),
//                     _buildMatchesTab(playerProvider),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildPlayerHeader(player) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFF0F3460),
//             Color(0xFF1A5490),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // ✅ Player Avatar with Photo
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.5),
//                 width: 4,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: ClipOval(
//               // ✅ প্রথমে profilePhotoUrl চেক করো, না থাকলে imageUrl চেক করো
//               child: (player.profilePhotoUrl != null && player.profilePhotoUrl!.isNotEmpty)
//                   ? Image.network(
//                 player.profilePhotoUrl!,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF28A745), Color(0xFF20C997)],
//                       ),
//                     ),
//                     child: const Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF28A745), Color(0xFF20C997)],
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         player.name.isNotEmpty
//                             ? player.name[0].toUpperCase()
//                             : 'P',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 50,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//                   : Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF28A745), Color(0xFF20C997)],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     player.name.isNotEmpty
//                         ? player.name[0].toUpperCase()
//                         : 'P',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 50,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             player.name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 26,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF28A745),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               player.position,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'ID: ${player.playerId}',
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildInfoTab(player) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Player Info Card
//           _buildInfoCard(
//             title: 'প্লেয়ার তথ্য',
//             icon: Icons.sports_soccer,
//             children: [
//               _buildInfoRow(
//                 icon: Icons.person,
//                 label: 'নাম',
//                 value: player.name,
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               _buildInfoRow(
//                 icon: Icons.badge,
//                 label: 'প্লেয়ার আইডি',
//                 value: player.playerId,
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               _buildInfoRow(
//                 icon: Icons.sports,
//                 label: 'পজিশন',
//                 value: player.position,
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               _buildInfoRow(
//                 icon: Icons.cake,
//                 label: 'জন্ম তারিখ',
//                 value: DateFormat('dd MMMM yyyy').format(player.dateOfBirth),
//               ),
//               if (player.teamName != null) ...[
//                 const Divider(color: Colors.white24, height: 24),
//                 _buildInfoRow(
//                   icon: Icons.shield,
//                   label: 'টিম',
//                   value: player.teamName!,
//                 ),
//               ],
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Location Card
//           _buildInfoCard(
//             title: 'ঠিকানা',
//             icon: Icons.location_on,
//             children: [
//               _buildInfoRow(
//                 icon: Icons.location_city,
//                 label: 'বিভাগ',
//                 value: player.division,
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               _buildInfoRow(
//                 icon: Icons.map,
//                 label: 'জেলা',
//                 value: player.district,
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               _buildInfoRow(
//                 icon: Icons.place,
//                 label: 'উপজেলা',
//                 value: player.upazila,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Account Info
//           _buildInfoCard(
//             title: 'অ্যাকাউন্ট',
//             icon: Icons.info,
//             children: [
//               _buildInfoRow(
//                 icon: Icons.calendar_today,
//                 label: 'তৈরির তারিখ',
//                 value: DateFormat('dd MMMM yyyy').format(player.createdAt),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 80), // Bottom padding
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMatchesTab(PlayerProvider playerProvider) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: playerProvider.getPlayerMatches(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF28A745)),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(
//                   Icons.sports_soccer,
//                   color: Colors.white30,
//                   size: 80,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'আপনার এলাকার কোন ম্যাচ খেলা হয়নি',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final matches = snapshot.data!;
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: matches.length,
//           itemBuilder: (context, index) {
//             final match = matches[index];
//             return _buildMatchCard(match);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildMatchCard(Map<String, dynamic> match) {
//     final teamA = match['teamA'] ?? '';
//     final teamB = match['teamB'] ?? '';
//     final scoreA = match['scoreA'] ?? 0;
//     final scoreB = match['scoreB'] ?? 0;
//     final date = (match['date'] as Timestamp?)?.toDate() ?? DateTime.now();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [
//             Color(0xFF16213E),
//             Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Date
//           Text(
//             DateFormat('dd MMM yyyy').format(date),
//             style: const TextStyle(
//               color: Colors.white54,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Score
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Text(
//                   teamA,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0F3460),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       '$scoreA',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         '-',
//                         style: TextStyle(
//                           color: Colors.white54,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       '$scoreB',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   teamB,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
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
//                 child: Icon(icon, color: Colors.white, size: 24),
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
//         Icon(icon, color: Colors.white54, size: 20),
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
//   void _showEditPositionDialog(
//       BuildContext context, PlayerProvider playerProvider) {
//     String? selectedPosition = playerProvider.myPlayer?.position;
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF16213E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               title: const Row(
//                 children: [
//                   Icon(Icons.sports_soccer, color: Color(0xFF28A745)),
//                   SizedBox(width: 12),
//                   Text(
//                     'পজিশন পরিবর্তন করুন',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   'ফরওয়ার্ড',
//                   'মিডফিল্ডার',
//                   'ডিফেন্ডার',
//                   'গোলকিপার',
//                 ].map((position) {
//                   return RadioListTile<String>(
//                     title: Text(
//                       position,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     value: position,
//                     groupValue: selectedPosition,
//                     activeColor: const Color(0xFF28A745),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedPosition = value;
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext),
//                   child: const Text(
//                     'বাতিল',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (selectedPosition != null) {
//                       Navigator.pop(dialogContext);
//
//                       // Show loading
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => const Center(
//                           child: CircularProgressIndicator(
//                             color: Color(0xFF28A745),
//                           ),
//                         ),
//                       );
//
//                       bool success = await playerProvider
//                           .updatePlayerPosition(selectedPosition!);
//
//                       if (context.mounted) {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               success
//                                   ? 'পজিশন আপডেট সফল হয়েছে'
//                                   : 'আপডেট ব্যর্থ হয়েছে',
//                             ),
//                             backgroundColor:
//                             success ? Colors.green : Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF28A745),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text('সংরক্ষণ'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
//
// import '../providers/player_provider.dart';
// import '../providers/auth_provider.dart';
//
// class MyPlayerProfileScreen extends StatefulWidget {
//   const MyPlayerProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyPlayerProfileScreen> createState() => _MyPlayerProfileScreenState();
// }
//
// class _MyPlayerProfileScreenState extends State<MyPlayerProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isLoadingData = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadPlayerData();
//     });
//   }
//
//   Future<void> _loadPlayerData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
//
//     if (authProvider.currentUser != null) {
//       await playerProvider.checkPlayerProfile(authProvider.currentUser!.uid);
//     }
//
//     if (mounted) {
//       setState(() {
//         _isLoadingData = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // ✅ পজিশন আপডেট ফাংশন (যা লোডিং হ্যান্ডেল করবে)
//   Future<void> _updatePosition(String newPosition, PlayerProvider provider) async {
//     // ১. লোডিং ডায়ালগ দেখানো
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(color: Color(0xFF28A745)),
//       ),
//     );
//
//     // ২. প্রোভাইডার থেকে আপডেট কল করা
//     bool success = await provider.updatePlayerPosition(newPosition);
//
//     // ৩. লোডিং ডায়ালগ বন্ধ করা
//     if (mounted) {
//       Navigator.of(context, rootNavigator: true).pop();
//     }
//
//     // ৪. মেসেজ দেখানো
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(success ? 'পজিশন আপডেট সফল হয়েছে' : 'আপডেট ব্যর্থ হয়েছে'),
//           backgroundColor: success ? Colors.green : Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: Consumer<PlayerProvider>(
//         builder: (context, playerProvider, child) {
//           final player = playerProvider.myPlayer;
//
//           if (_isLoadingData) {
//             return const Center(child: CircularProgressIndicator(color: Color(0xFF28A745)));
//           }
//
//           if (player == null) {
//             return _buildNoPlayerUI();
//           }
//
//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 expandedHeight: 280,
//                 pinned: true,
//                 backgroundColor: const Color(0xFF16213E),
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: _buildPlayerHeader(player),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                     onPressed: () => _showEditPositionDialog(context, playerProvider),
//                   ),
//                 ],
//                 bottom: TabBar(
//                   controller: _tabController,
//                   indicatorColor: const Color(0xFF28A745),
//                   tabs: const [Tab(text: 'তথ্য'), Tab(text: 'আমার ম্যাচ')],
//                 ),
//               ),
//               SliverFillRemaining(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildInfoTab(player),
//                     _buildMatchesTab(playerProvider),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // পজিশন এডিট ডায়ালগ
//   void _showEditPositionDialog(BuildContext context, PlayerProvider playerProvider) {
//     String? tempPosition = playerProvider.myPlayer?.position;
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               backgroundColor: const Color(0xFF16213E),
//               title: const Text('পজিশন পরিবর্তন', style: TextStyle(color: Colors.white)),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'].map((pos) {
//                   return RadioListTile<String>(
//                     title: Text(pos, style: const TextStyle(color: Colors.white)),
//                     value: pos,
//                     groupValue: tempPosition,
//                     activeColor: const Color(0xFF28A745),
//                     onChanged: (val) => setDialogState(() => tempPosition = val),
//                   );
//                 }).toList(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(dialogContext),
//                   child: const Text('বাতিল', style: TextStyle(color: Colors.white70)),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(dialogContext); // ডায়ালগ বন্ধ
//                     if (tempPosition != null) {
//                       _updatePosition(tempPosition!, playerProvider); // আপডেট শুরু
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28A745)),
//                   child: const Text('সংরক্ষণ'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // হেডার ডিজাইন
//   Widget _buildPlayerHeader(player) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(colors: [Color(0xFF0F3460), Color(0xFF1A5490)]),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundColor: const Color(0xFF28A745),
//             backgroundImage: (player.profilePhotoUrl != null && player.profilePhotoUrl!.isNotEmpty)
//                 ? NetworkImage(player.profilePhotoUrl!)
//                 : null,
//             child: (player.profilePhotoUrl == null || player.profilePhotoUrl!.isEmpty)
//                 ? Text(player.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))
//                 : null,
//           ),
//           const SizedBox(height: 15),
//           Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Chip(
//             label: Text(player.position, style: const TextStyle(color: Colors.white)),
//             backgroundColor: const Color(0xFF28A745),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // বাকি উইজেটগুলো (Info Tab, Match Tab, ইত্যাদি) আগের মতোই থাকবে...
//   Widget _buildInfoTab(player) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           _buildInfoRow(Icons.person, 'নাম', player.name),
//           const Divider(color: Colors.white24),
//           _buildInfoRow(Icons.badge, 'আইডি', player.playerId),
//           const Divider(color: Colors.white24),
//           _buildInfoRow(Icons.sports, 'পজিশন', player.position),
//           const Divider(color: Colors.white24),
//           _buildInfoRow(Icons.cake, 'জন্ম তারিখ', DateFormat('dd MMM yyyy').format(player.dateOfBirth)),
//           const Divider(color: Colors.white24),
//           _buildInfoRow(Icons.location_on, 'উপজেলা', player.upazila),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white54),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMatchesTab(PlayerProvider playerProvider) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: playerProvider.getPlayerMatches(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('কোন ম্যাচ পাওয়া যায়নি', style: TextStyle(color: Colors.white54)));
//         }
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) => _buildMatchCard(snapshot.data![index]),
//         );
//       },
//     );
//   }
//
//   Widget _buildMatchCard(Map<String, dynamic> match) {
//     return Card(
//       color: const Color(0xFF16213E),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         title: Text('${match['teamA']} vs ${match['teamB']}', style: const TextStyle(color: Colors.white)),
//         subtitle: Text('Score: ${match['scoreA']} - ${match['scoreB']}', style: const TextStyle(color: Colors.white70)),
//       ),
//     );
//   }
//
//   Widget _buildNoPlayerUI() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.person_off, color: Colors.white30, size: 80),
//           const SizedBox(height: 16),
//           const Text('প্লেয়ার প্রোফাইল নেই', style: TextStyle(color: Colors.white, fontSize: 18)),
//           const SizedBox(height: 20),
//           ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('ফিরে যান')),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // ক্যাশিং প্যাকেজ

import '../providers/player_provider.dart';
import '../providers/auth_provider.dart';

class MyPlayerProfileScreen extends StatefulWidget {
  const MyPlayerProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyPlayerProfileScreen> createState() => _MyPlayerProfileScreenState();
}

class _MyPlayerProfileScreenState extends State<MyPlayerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlayerData();
    });
  }

  Future<void> _loadPlayerData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      // রিয়েল-টাইম লিসেনার চালু করা হলো
      playerProvider.listenToPlayerProfile(authProvider.currentUser!.uid);
    }

    if (mounted) {
      setState(() => _isLoadingData = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updatePosition(
      String newPosition, PlayerProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF28A745)),
      ),
    );

    bool success = await provider.updatePlayerPosition(newPosition);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? 'পজিশন আপডেট সফল হয়েছে' : 'আপডেট ব্যর্থ হয়েছে'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) {
          final player = playerProvider.myPlayer;

          if (_isLoadingData) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF28A745)));
          }

          if (player == null) {
            return _buildNoPlayerUI();
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildPlayerHeader(player),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () =>
                        _showEditPositionDialog(context, playerProvider),
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF28A745),
                  tabs: const [Tab(text: 'তথ্য'), Tab(text: 'আমার ম্যাচ')],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(player),
                    _buildMatchesTab(playerProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ হেডার ডিজাইন যেখানে ক্যাশ ইমেজ ব্যবহার করা হয়েছে
  Widget _buildPlayerHeader(player) {
    String? photoUrl =
        (player.profilePhotoUrl != null && player.profilePhotoUrl!.isNotEmpty)
            ? player.profilePhotoUrl
            : null;

    return Container(
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF0F3460), Color(0xFF1A5490)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ইমেজ ক্যাশিং লজিক
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 3),
            ),
            child: ClipOval(
              child: photoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: photoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white),
                    )
                  : Container(
                      color: const Color(0xFF28A745),
                      child: Center(
                        child: Text(
                          player.name[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          Text(player.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Chip(
            label: Text(player.position,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF28A745),
          ),
        ],
      ),
    );
  }

  // পজিশন এডিট ডায়ালগ
  void _showEditPositionDialog(
      BuildContext context, PlayerProvider playerProvider) {
    String? tempPosition = playerProvider.myPlayer?.position;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Text('পজিশন পরিবর্তন',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['ফরওয়ার্ড', 'মিডফিল্ডার', 'ডিফেন্ডার', 'গোলকিপার']
                    .map((pos) {
                  return RadioListTile<String>(
                    title:
                        Text(pos, style: const TextStyle(color: Colors.white)),
                    value: pos,
                    groupValue: tempPosition,
                    activeColor: const Color(0xFF28A745),
                    onChanged: (val) =>
                        setDialogState(() => tempPosition = val),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('বাতিল',
                      style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    if (tempPosition != null) {
                      _updatePosition(tempPosition!, playerProvider);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745)),
                  child: const Text('সংরক্ষণ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInfoTab(player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow(Icons.person, 'নাম', player.name),
          const Divider(color: Colors.white24),
          _buildInfoRow(Icons.badge, 'আইডি', player.playerId),
          const Divider(color: Colors.white24),
          _buildInfoRow(Icons.sports, 'পজিশন', player.position),
          const Divider(color: Colors.white24),
          _buildInfoRow(Icons.cake, 'জন্ম তারিখ',
              DateFormat('dd MMM yyyy').format(player.dateOfBirth)),
          const Divider(color: Colors.white24),
          _buildInfoRow(Icons.location_on, 'উপজেলা', player.upazila),
          const Divider(color: Colors.white24),
          _buildInfoRow(Icons.map, 'জেলা', player.district),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(PlayerProvider playerProvider) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: playerProvider.getPlayerMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF28A745)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('কোন ম্যাচ পাওয়া যায়নি',
                  style: TextStyle(color: Colors.white54)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) =>
              _buildMatchCard(snapshot.data![index]),
        );
      },
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    return Card(
      color: const Color(0xFF16213E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text('${match['teamA']} vs ${match['teamB']}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Score: ${match['scoreA']} - ${match['scoreB']}',
              style: const TextStyle(
                  color: Color(0xFF28A745),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }

  Widget _buildNoPlayerUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, color: Colors.white30, size: 80),
          const SizedBox(height: 16),
          const Text('প্লেয়ার প্রোফাইল নেই',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745)),
            child: const Text('ফিরে যান'),
          ),
        ],
      ),
    );
  }
}
