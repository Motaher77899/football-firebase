//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import '../models/team_model.dart';
// import '../models/tournament.dart';
// import '../models/tournament_match_model.dart';
// import '../models/match_model.dart';
// import '../models/tournament_player_stats_model.dart';
// import '../models/tournament_team_stats_model.dart';
// import '../providers/team_provider.dart';
// import '../widgets/tournament_match_card.dart';
// import 'match_details_screen.dart';
//
// class TournamentDetailsScreen extends StatefulWidget {
//   final String tournamentId;
//
//   const TournamentDetailsScreen({
//     Key? key,
//     required this.tournamentId,
//   }) : super(key: key);
//
//   @override
//   State<TournamentDetailsScreen> createState() =>
//       _TournamentDetailsScreenState();
// }
//
// class _TournamentDetailsScreenState extends State<TournamentDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   Tournament? _tournament;
//   bool _isLoading = true;
//   late TeamProvider _teamProvider;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _teamProvider = TeamProvider();
//     _loadData();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
//
//     try {
//       // Load teams first
//       await _teamProvider.fetchTeams();
//
//       // Load tournament
//       final doc = await FirebaseFirestore.instance
//           .collection('tournaments')
//           .doc(widget.tournamentId)
//           .get();
//
//       if (doc.exists && mounted) {
//         setState(() {
//           _tournament = Tournament.fromMap(
//             doc.data() as Map<String, dynamic>,
//             doc.id,
//           );
//           _isLoading = false;
//         });
//       } else {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Error loading data: $e');
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFF1A1A2E),
//         body: const Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF28A745),
//           ),
//         ),
//       );
//     }
//
//     if (_tournament == null) {
//       return _buildErrorView();
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 250,
//               pinned: true,
//               backgroundColor: const Color(0xFF16213E),
//               iconTheme: const IconThemeData(color: Colors.white),
//               flexibleSpace: FlexibleSpaceBar(
//                 background: _buildHeaderImage(),
//               ),
//             ),
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _SliverAppBarDelegate(
//                 TabBar(
//                   controller: _tabController,
//                   indicatorColor: const Color(0xFF28A745),
//                   indicatorWeight: 3,
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.white60,
//                   isScrollable: true,
//                   labelStyle: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   unselectedLabelStyle: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   tabs: const [
//                     Tab(text: 'তথ্য'),
//                     Tab(text: 'ম্যাচ'),
//                     Tab(text: 'টেবিল'),
//                     Tab(text: 'খেলোয়াড়'),
//                     Tab(text: 'টিম স্ট্যাট'),
//                     Tab(text: 'টিম'),
//                   ],
//                 ),
//               ),
//             ),
//           ];
//         },
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _TournamentInfoTab(tournament: _tournament!),
//             _MatchesTab(
//               tournamentId: widget.tournamentId,
//               teamProvider: _teamProvider,
//             ),
//             _PointsTableTab(tournamentId: widget.tournamentId),
//             _PlayerStatsTab(tournamentId: widget.tournamentId),
//             _TeamStatsTab(tournamentId: widget.tournamentId),
//             _TeamsTab(
//               tournamentId: widget.tournamentId,
//               teamProvider: _teamProvider,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderImage() {
//     final tournament = _tournament!;
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // Background
//         tournament.imageUrl.isNotEmpty
//             ? Image.network(
//           tournament.imageUrl,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return _buildDefaultHeaderImage();
//           },
//         )
//             : _buildDefaultHeaderImage(),
//
//         // Gradient Overlay
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.8),
//               ],
//             ),
//           ),
//         ),
//
//         // Content
//         Positioned(
//           bottom: 16,
//           left: 16,
//           right: 16,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Status Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(tournament.status),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _getStatusColor(tournament.status)
//                           .withOpacity(0.5),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   tournament.statusInBengali,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Tournament Name
//               Text(
//                 tournament.name,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     Shadow(
//                       color: Colors.black54,
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // Location
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Color(0xFF28A745),
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       tournament.location,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDefaultHeaderImage() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF0F3460), Color(0xFF1A5490)],
//         ),
//       ),
//       child: Center(
//         child: Icon(
//           Icons.emoji_events,
//           size: 80,
//           color: Colors.white.withOpacity(0.3),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorView() {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 80, color: Colors.red),
//             const SizedBox(height: 16),
//             const Text(
//               'টুর্নামেন্ট খুঁজে পাওয়া যায়নি',
//               style: TextStyle(color: Colors.white70, fontSize: 18),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF28A745),
//               ),
//               child: const Text('ফিরে যান'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'upcoming':
//         return const Color(0xFF2196F3);
//       case 'ongoing':
//         return const Color(0xFF4CAF50);
//       case 'completed':
//         return const Color(0xFF757575);
//       default:
//         return const Color(0xFF757575);
//     }
//   }
// }
//
// // SliverAppBar Delegate
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar _tabBar;
//
//   _SliverAppBarDelegate(this._tabBar);
//
//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: const Color(0xFF16213E),
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }
//
// // Continue in next file...
// // Tab 1: Tournament Info
// class _TournamentInfoTab extends StatelessWidget {
//   final Tournament tournament;
//
//   const _TournamentInfoTab({required this.tournament});
//
//   @override
//   Widget build(BuildContext context) {
//     final dateFormat = DateFormat('dd MMMM yyyy');
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Description
//           _buildSection(
//             title: '📋 বিবরণ',
//             child: Text(
//               tournament.description,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 15,
//                 height: 1.5,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Schedule
//           _buildSection(
//             title: '📅 সময়সূচী',
//             child: Column(
//               children: [
//                 _buildInfoRow(
//                   icon: Icons.play_circle_outline,
//                   label: 'শুরু',
//                   value: dateFormat.format(tournament.startDate),
//                   iconColor: const Color(0xFF4CAF50),
//                 ),
//                 const SizedBox(height: 12),
//                 _buildInfoRow(
//                   icon: Icons.stop_circle_outlined,
//                   label: 'শেষ',
//                   value: dateFormat.format(tournament.endDate),
//                   iconColor: const Color(0xFFFF5252),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Prize Pool
//           if (tournament.prizePool.isNotEmpty)
//             _buildSection(
//               title: '🏆 পুরস্কার',
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFFFFD700).withOpacity(0.2),
//                       const Color(0xFFFFA000).withOpacity(0.2),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFFFD700), width: 2),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.emoji_events,
//                         size: 40, color: Color(0xFFFFD700)),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         tournament.prizePool,
//                         style: const TextStyle(
//                           color: Color(0xFFFFD700),
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           const SizedBox(height: 16),
//
//           // Organizer
//           _buildSection(
//             title: '👤 আয়োজক',
//             child: Column(
//               children: [
//                 _buildInfoRow(
//                   icon: Icons.person,
//                   label: 'নাম',
//                   value: tournament.organizerName,
//                 ),
//                 if (tournament.organizerContact.isNotEmpty) ...[
//                   const SizedBox(height: 12),
//                   _buildInfoRow(
//                     icon: Icons.phone,
//                     label: 'যোগাযোগ',
//                     value: tournament.organizerContact,
//                     iconColor: const Color(0xFF4CAF50),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSection({required String title, required Widget child}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFF16213E),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: child,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     Color iconColor = Colors.white,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: iconColor, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white54, fontSize: 13),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Tab 2: Matches
// // ✅ এই code টা আপনার tournament_details_screen.dart এর _MatchesTab class এ replace করুন
//
// class _MatchesTab extends StatelessWidget {
//   final String tournamentId;
//   final TeamProvider teamProvider;
//
//   const _MatchesTab({
//     required this.tournamentId,
//     required this.teamProvider,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('🔍 _MatchesTab - Tournament ID: $tournamentId');
//     debugPrint('👥 _MatchesTab - Teams available: ${teamProvider.teams.length}');
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_matches')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .orderBy('matchDate')
//           .snapshots(),
//       builder: (context, snapshot) {
//         debugPrint('📊 Snapshot state: ${snapshot.connectionState}');
//         debugPrint('📊 Has data: ${snapshot.hasData}');
//         debugPrint('📊 Has error: ${snapshot.hasError}');
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF28A745)),
//           );
//         }
//
//         if (snapshot.hasError) {
//           debugPrint('❌ Stream Error: ${snapshot.error}');
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 80, color: Colors.red),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Error: ${snapshot.error}',
//                   style: const TextStyle(color: Colors.white54, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Trigger rebuild
//                     (context as Element).markNeedsBuild();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF28A745),
//                   ),
//                   child: const Text('আবার চেষ্টা করুন'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           debugPrint('📊 No matches found');
//           return _buildEmptyState(
//             'কোন ম্যাচ নেই',
//             Icons.sports_soccer,
//           );
//         }
//
//         final docs = snapshot.data!.docs;
//         debugPrint('✅ Found ${docs.length} match documents');
//
//         // Parse matches with error handling
//         final matches = <TournamentMatch>[];
//         for (var doc in docs) {
//           try {
//             final data = doc.data() as Map<String, dynamic>;
//             debugPrint('📄 Processing match: ${doc.id}');
//             debugPrint('   Data: $data');
//
//             final match = TournamentMatch.fromMap(data, doc.id);
//             matches.add(match);
//
//             debugPrint('✅ Match parsed: ${match.homeTeamId} vs ${match.awayTeamId}');
//           } catch (e, stackTrace) {
//             debugPrint('❌ Error parsing match ${doc.id}: $e');
//             debugPrint('Stack trace: $stackTrace');
//           }
//         }
//
//         if (matches.isEmpty) {
//           return _buildEmptyState(
//             'ম্যাচ parse করতে সমস্যা হয়েছে',
//             Icons.error_outline,
//           );
//         }
//
//         debugPrint('✅ Total matches parsed: ${matches.length}');
//
//         // Sort matches by date
//         matches.sort((a, b) => a.matchDate.compareTo(b.matchDate));
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: matches.length,
//           itemBuilder: (context, index) {
//             final match = matches[index];
//             debugPrint('🎨 Rendering match card $index: ${match.homeTeamId} vs ${match.awayTeamId}');
//
//             // Convert to MatchModel for navigation
//             final matchModel = _convertToMatchModel(match, teamProvider);
//
//             return GestureDetector(
//               onTap: matchModel != null
//                   ? () {
//                 debugPrint('🔗 Navigating to match details: ${match.id}');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MatchDetailsScreen(
//                       match: matchModel,
//                       teamProvider: teamProvider,
//                     ),
//                   ),
//                 );
//               }
//                   : null,
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: TournamentMatchCard(
//                   match: match,
//                   teamProvider: teamProvider,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState(String message, IconData icon) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 80, color: Colors.white24),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: const TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Convert TournamentMatch to MatchModel for navigation
//   MatchModel? _convertToMatchModel(
//       TournamentMatch match,
//       TeamProvider teamProvider,
//       ) {
//     try {
//       debugPrint('🔄 Converting match to MatchModel: ${match.id}');
//
//       // Get team objects
//       final homeTeam = teamProvider.getTeamById(match.homeTeamId);
//       final awayTeam = teamProvider.getTeamById(match.awayTeamId);
//
//       debugPrint('   Home team: ${homeTeam?.name ?? "NOT FOUND"}');
//       debugPrint('   Away team: ${awayTeam?.name ?? "NOT FOUND"}');
//
//       if (homeTeam == null || awayTeam == null) {
//         debugPrint('❌ Cannot convert: teams not found');
//         return null;
//       }
//
//       final matchModel = MatchModel(
//         id: match.id,
//         teamA: homeTeam.name,
//         teamB: awayTeam.name,
//         scoreA: match.homeScore,
//         scoreB: match.awayScore,
//         time: match.matchDate,
//         date: match.matchDate,
//         status: match.status,
//         tournament: match.tournamentId,
//         venue: match.venue,
//       );
//
//       debugPrint('✅ MatchModel created successfully');
//       return matchModel;
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error converting tournament match: $e');
//       debugPrint('Stack trace: $stackTrace');
//       return null;
//     }
//   }
// }
//
// // Tab 3: Points Table
// // Tab 3: Points Table (✅ WITHOUT INDEX REQUIREMENT)
// class _PointsTableTab extends StatelessWidget {
//   final String tournamentId;
//
//   const _PointsTableTab({required this.tournamentId});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//       // ❌ .orderBy('points', descending: true)  ← Remove this
//       // ❌ .orderBy('goalDifference', descending: true)  ← Remove this
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF28A745)),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         // ✅ Parse and sort manually in code
//         final teams = snapshot.data!.docs
//             .map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'data': data,
//             'points': data['points'] ?? 0,
//             'goalDifference': data['goalDifference'] ?? 0,
//           };
//         })
//             .toList();
//
//         // ✅ Sort by points first, then goal difference
//         teams.sort((a, b) {
//           final pointsCompare = (b['points'] as int).compareTo(a['points'] as int);
//           if (pointsCompare != 0) return pointsCompare;
//           return (b['goalDifference'] as int).compareTo(a['goalDifference'] as int);
//         });
//
//         return SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: DataTable(
//                 headingRowColor: MaterialStateProperty.all(
//                   const Color(0xFF16213E),
//                 ),
//                 dataRowColor: MaterialStateProperty.resolveWith(
//                       (states) => const Color(0xFF1A1A2E),
//                 ),
//                 border: TableBorder.all(
//                   color: Colors.white12,
//                   width: 1,
//                 ),
//                 columns: const [
//                   DataColumn(
//                     label: Text(
//                       '#',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'টিম',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'ম্যাচ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'জয়',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'ড্র',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'হার',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'GD',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'পয়েন্ট',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: List.generate(
//                   teams.length,
//                       (index) {
//                     final data = teams[index]['data'] as Map<String, dynamic>;
//                     final position = index + 1;
//
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getPositionColor(position),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               '$position',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             data['teamName'] ?? '',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             '${data['matchesPlayed'] ?? 0}',
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             '${data['wins'] ?? 0}',
//                             style: const TextStyle(color: Colors.greenAccent),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             '${data['draws'] ?? 0}',
//                             style: const TextStyle(color: Colors.orangeAccent),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             '${data['losses'] ?? 0}',
//                             style: const TextStyle(color: Colors.redAccent),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             '${data['goalDifference'] ?? 0}',
//                             style: TextStyle(
//                               color: (data['goalDifference'] ?? 0) >= 0
//                                   ? Colors.greenAccent
//                                   : Colors.redAccent,
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF28A745),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${data['points'] ?? 0}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getPositionColor(int position) {
//     if (position == 1) return const Color(0xFFFFD700); // Gold
//     if (position == 2) return const Color(0xFFC0C0C0); // Silver
//     if (position == 3) return const Color(0xFFCD7F32); // Bronze
//     return const Color(0xFF16213E);
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.table_chart, size: 80, color: Colors.white24),
//           const SizedBox(height: 16),
//           const Text(
//             'পয়েন্ট টেবিল নেই',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Continue in next message with Player Stats, Team Stats, and Teams tabs...
//
// // Tab 4: Player Stats
// // Tab 4: Player Stats (✅ WITHOUT INDEX REQUIREMENT)
// // 🏆 PROFESSIONAL PLAYER STATS TAB
// class _PlayerStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const _PlayerStatsTab({required this.tournamentId});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 5,
//       child: Column(
//         children: [
//           Container(
//             color: const Color(0xFF16213E),
//             child: const TabBar(
//               indicatorColor: Color(0xFF28A745),
//               indicatorWeight: 3,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white60,
//               isScrollable: true,
//               labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               tabs: [
//                 Tab(text: '⚽ গোল'),
//                 Tab(text: '🎯 অ্যাসিস্ট'),
//                 Tab(text: '🟨 হলুদ কার্ড'),
//                 Tab(text: '🟥 লাল কার্ড'),
//                 Tab(text: '🏆 সেরা খেলোয়াড়'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _buildTopScorers(),
//                 _buildTopAssisters(),
//                 _buildYellowCards(),
//                 _buildRedCards(),
//                 _buildBestPlayers(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ⚽ Top Scorers
//   Widget _buildTopScorers() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_player_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন গোলদাতা নেই', Icons.sports_soccer);
//         }
//
//         final players = snapshot.data!.docs
//             .map((doc) => TournamentPlayerStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .where((player) => player.goals > 0)
//             .toList();
//
//         players.sort((a, b) => b.goals.compareTo(a.goals));
//         final topPlayers = players.take(20).toList();
//
//         if (topPlayers.isEmpty) {
//           return _buildEmptyState('কোন গোলদাতা নেই', Icons.sports_soccer);
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: topPlayers.length,
//           itemBuilder: (context, index) {
//             final player = topPlayers[index];
//             return _buildPlayerCard(
//               rank: index + 1,
//               player: player,
//               primaryStat: player.goals,
//               primaryStatLabel: 'গোল',
//               primaryStatIcon: Icons.sports_soccer,
//               secondaryStat: player.assists,
//               secondaryStatLabel: 'অ্যাসিস্ট',
//               color: const Color(0xFF4CAF50),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🎯 Top Assisters
//   Widget _buildTopAssisters() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_player_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন অ্যাসিস্ট নেই', Icons.sports_handball);
//         }
//
//         final players = snapshot.data!.docs
//             .map((doc) => TournamentPlayerStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .where((player) => player.assists > 0)
//             .toList();
//
//         players.sort((a, b) => b.assists.compareTo(a.assists));
//         final topPlayers = players.take(20).toList();
//
//         if (topPlayers.isEmpty) {
//           return _buildEmptyState('কোন অ্যাসিস্ট নেই', Icons.sports_handball);
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: topPlayers.length,
//           itemBuilder: (context, index) {
//             final player = topPlayers[index];
//             return _buildPlayerCard(
//               rank: index + 1,
//               player: player,
//               primaryStat: player.assists,
//               primaryStatLabel: 'অ্যাসিস্ট',
//               primaryStatIcon: Icons.sports_handball,
//               secondaryStat: player.goals,
//               secondaryStatLabel: 'গোল',
//               color: const Color(0xFF2196F3),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🟨 Yellow Cards
//   Widget _buildYellowCards() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_player_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন হলুদ কার্ড নেই', Icons.credit_card);
//         }
//
//         final players = snapshot.data!.docs
//             .map((doc) => TournamentPlayerStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .where((player) => player.yellowCards > 0)
//             .toList();
//
//         players.sort((a, b) => b.yellowCards.compareTo(a.yellowCards));
//         final topPlayers = players.take(20).toList();
//
//         if (topPlayers.isEmpty) {
//           return _buildEmptyState('কোন হলুদ কার্ড নেই', Icons.credit_card);
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: topPlayers.length,
//           itemBuilder: (context, index) {
//             final player = topPlayers[index];
//             return _buildPlayerCard(
//               rank: index + 1,
//               player: player,
//               primaryStat: player.yellowCards,
//               primaryStatLabel: 'হলুদ কার্ড',
//               primaryStatIcon: Icons.credit_card,
//               secondaryStat: player.redCards,
//               secondaryStatLabel: 'লাল কার্ড',
//               color: const Color(0xFFFFC107),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🟥 Red Cards
//   Widget _buildRedCards() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_player_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন লাল কার্ড নেই', Icons.credit_card);
//         }
//
//         final players = snapshot.data!.docs
//             .map((doc) => TournamentPlayerStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .where((player) => player.redCards > 0)
//             .toList();
//
//         players.sort((a, b) => b.redCards.compareTo(a.redCards));
//         final topPlayers = players.take(20).toList();
//
//         if (topPlayers.isEmpty) {
//           return _buildEmptyState('কোন লাল কার্ড নেই', Icons.credit_card);
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: topPlayers.length,
//           itemBuilder: (context, index) {
//             final player = topPlayers[index];
//             return _buildPlayerCard(
//               rank: index + 1,
//               player: player,
//               primaryStat: player.redCards,
//               primaryStatLabel: 'লাল কার্ড',
//               primaryStatIcon: Icons.credit_card,
//               secondaryStat: player.yellowCards,
//               secondaryStatLabel: 'হলুদ কার্ড',
//               color: const Color(0xFFF44336),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🏆 Best Overall Players
//   Widget _buildBestPlayers() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_player_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন খেলোয়াড় নেই', Icons.emoji_events);
//         }
//
//         final players = snapshot.data!.docs
//             .map((doc) => TournamentPlayerStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .toList();
//
//         // Calculate performance score: Goals * 3 + Assists * 2 - Yellow Cards * 0.5 - Red Cards * 2
//         players.sort((a, b) {
//           final scoreA = (a.goals * 3) +
//               (a.assists * 2) -
//               (a.yellowCards * 0.5) -
//               (a.redCards * 2);
//           final scoreB = (b.goals * 3) +
//               (b.assists * 2) -
//               (b.yellowCards * 0.5) -
//               (b.redCards * 2);
//           return scoreB.compareTo(scoreA);
//         });
//
//         final topPlayers = players.take(20).toList();
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: topPlayers.length,
//           itemBuilder: (context, index) {
//             final player = topPlayers[index];
//             return _buildDetailedPlayerCard(
//               rank: index + 1,
//               player: player,
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🎨 Professional Player Card
//   Widget _buildPlayerCard({
//     required int rank,
//     required TournamentPlayerStats player,
//     required int primaryStat,
//     required String primaryStatLabel,
//     required IconData primaryStatIcon,
//     required int secondaryStat,
//     required String secondaryStatLabel,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: rank <= 3 ? color.withOpacity(0.6) : Colors.white12,
//           width: rank <= 3 ? 2.5 : 1,
//         ),
//         boxShadow: [
//           if (rank <= 3)
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Rank badge (top-left corner)
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: rank <= 3 ? color : const Color(0xFF0F3460),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//               ),
//               child: Text(
//                 '#$rank',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: rank == 1 ? 16 : 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           // Main content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Player Photo
//                 Container(
//                   width: 70,
//                   height: 70,
//                   margin: const EdgeInsets.only(right: 16),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: rank <= 3 ? color : Colors.white24,
//                       width: 3,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: player.playerPhoto.isNotEmpty
//                         ? Image.network(
//                       player.playerPhoto,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return _buildDefaultAvatar(player.playerName);
//                       },
//                     )
//                         : _buildDefaultAvatar(player.playerName),
//                   ),
//                 ),
//
//                 // Player Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         player.playerName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.shield,
//                             color: color.withOpacity(0.7),
//                             size: 14,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               player.teamName,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7),
//                                 fontSize: 13,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           _buildStatBadge(
//                             icon: Icons.stadium,
//                             value: player.matchesPlayed,
//                             label: 'ম্যাচ',
//                             color: Colors.white38,
//                           ),
//                           const SizedBox(width: 8),
//                           if (secondaryStat > 0)
//                             _buildStatBadge(
//                               icon: primaryStatIcon == Icons.sports_soccer
//                                   ? Icons.sports_handball
//                                   : Icons.sports_soccer,
//                               value: secondaryStat,
//                               label: secondaryStatLabel,
//                               color: Colors.white38,
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Primary Stat
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: color.withOpacity(0.5),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(primaryStatIcon, color: color, size: 24),
//                       const SizedBox(height: 6),
//                       Text(
//                         '$primaryStat',
//                         style: TextStyle(
//                           color: color,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🏆 Detailed Player Card (for Best Players tab)
//   Widget _buildDetailedPlayerCard({
//     required int rank,
//     required TournamentPlayerStats player,
//   }) {
//     final performanceScore = (player.goals * 3) +
//         (player.assists * 2) -
//         (player.yellowCards * 0.5) -
//         (player.redCards * 2);
//
//     Color rankColor = const Color(0xFF0F3460);
//     if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
//     if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
//     if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
//           width: rank <= 3 ? 3 : 1,
//         ),
//         boxShadow: [
//           if (rank <= 3)
//             BoxShadow(
//               color: rankColor.withOpacity(0.4),
//               blurRadius: 20,
//               offset: const Offset(0, 8),
//             ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header with rank and photo
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.2),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 // Rank Circle
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: rankColor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: rankColor.withOpacity(0.5),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       '$rank',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Player Photo
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: rankColor,
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipOval(
//                     child: player.playerPhoto.isNotEmpty
//                         ? Image.network(
//                       player.playerPhoto,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return _buildDefaultAvatar(player.playerName);
//                       },
//                     )
//                         : _buildDefaultAvatar(player.playerName),
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Player Name and Team
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         player.playerName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.shield,
//                             color: Colors.white54,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               player.teamName,
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF28A745).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: const Color(0xFF28A745),
//                             width: 1,
//                           ),
//                         ),
//                         child: Text(
//                           'স্কোর: ${performanceScore.toStringAsFixed(1)}',
//                           style: const TextStyle(
//                             color: Color(0xFF28A745),
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Stats Grid
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildDetailStatItem(
//                     icon: Icons.sports_soccer,
//                     value: player.goals,
//                     label: 'গোল',
//                     color: const Color(0xFF4CAF50),
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildDetailStatItem(
//                     icon: Icons.sports_handball,
//                     value: player.assists,
//                     label: 'অ্যাসিস্ট',
//                     color: const Color(0xFF2196F3),
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildDetailStatItem(
//                     icon: Icons.stadium,
//                     value: player.matchesPlayed,
//                     label: 'ম্যাচ',
//                     color: const Color(0xFF9C27B0),
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildDetailStatItem(
//                     icon: Icons.credit_card,
//                     value: player.yellowCards + player.redCards,
//                     label: 'কার্ড',
//                     color: const Color(0xFFFFC107),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatBadge({
//     required IconData icon,
//     required int value,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 12),
//           const SizedBox(width: 4),
//           Text(
//             '$value',
//             style: TextStyle(
//               color: color,
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailStatItem({
//     required IconData icon,
//     required int value,
//     required String label,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 28),
//         const SizedBox(height: 6),
//         Text(
//           '$value',
//           style: TextStyle(
//             color: color,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 11,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDefaultAvatar(String name) {
//     return Container(
//       color: const Color(0xFF28A745),
//       child: Center(
//         child: Text(
//           name.isNotEmpty ? name[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF28A745)),
//           SizedBox(height: 16),
//           Text(
//             'লোড হচ্ছে...',
//             style: TextStyle(color: Colors.white54, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(String message, IconData icon) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 80, color: Colors.white24),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: const TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Tab 5: Team Stats
// // Tab 5: Team Stats (✅ WITHOUT INDEX REQUIREMENT)
// // 🏆 PROFESSIONAL TEAM STATS TAB
// class _TeamStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const _TeamStatsTab({required this.tournamentId});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Column(
//         children: [
//           Container(
//             color: const Color(0xFF16213E),
//             child: const TabBar(
//               indicatorColor: Color(0xFF28A745),
//               indicatorWeight: 3,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white60,
//               isScrollable: true,
//               labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               tabs: [
//                 Tab(text: '⚽ আক্রমণ'),
//                 Tab(text: '🛡️ রক্ষণ'),
//                 Tab(text: '📊 সামগ্রিক'),
//                 Tab(text: '🏆 গ্রুপ'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _buildAttackStats(),
//                 _buildDefenseStats(),
//                 _buildOverallStats(),
//                 _buildGroupStats(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ⚽ Attack Stats
//   Widget _buildAttackStats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন তথ্য নেই');
//         }
//
//         final teams = snapshot.data!.docs
//             .map((doc) => TournamentTeamStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .toList();
//
//         teams.sort((a, b) => b.goalsFor.compareTo(a.goalsFor));
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             final team = teams[index];
//             return _buildTeamStatCard(
//               rank: index + 1,
//               team: team,
//               primaryStat: team.goalsFor,
//               primaryStatLabel: 'গোল করেছে',
//               primaryStatIcon: Icons.sports_soccer,
//               secondaryStat: (team.matchesPlayed > 0)
//                   ? (team.goalsFor / team.matchesPlayed).toStringAsFixed(1)
//                   : '0.0',
//               secondaryStatLabel: 'প্রতি ম্যাচে গড়',
//               color: const Color(0xFF4CAF50),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🛡️ Defense Stats
//   Widget _buildDefenseStats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন তথ্য নেই');
//         }
//
//         final teams = snapshot.data!.docs
//             .map((doc) => TournamentTeamStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .toList();
//
//         // Sort by goals against (ascending - best defense first)
//         teams.sort((a, b) => a.goalsAgainst.compareTo(b.goalsAgainst));
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             final team = teams[index];
//             return _buildTeamStatCard(
//               rank: index + 1,
//               team: team,
//               primaryStat: team.goalsAgainst,
//               primaryStatLabel: 'গোল খেয়েছে',
//               primaryStatIcon: Icons.shield,
//               secondaryStat: (team.matchesPlayed > 0)
//                   ? (team.goalsAgainst / team.matchesPlayed).toStringAsFixed(1)
//                   : '0.0',
//               secondaryStatLabel: 'প্রতি ম্যাচে গড়',
//               color: const Color(0xFF2196F3),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 📊 Overall Stats
//   Widget _buildOverallStats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন তথ্য নেই');
//         }
//
//         final teams = snapshot.data!.docs
//             .map((doc) => TournamentTeamStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .toList();
//
//         // Sort by points, then goal difference
//         teams.sort((a, b) {
//           final pointsCompare = b.points.compareTo(a.points);
//           if (pointsCompare != 0) return pointsCompare;
//           return b.goalDifference.compareTo(a.goalDifference);
//         });
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             final team = teams[index];
//             return _buildDetailedTeamCard(
//               rank: index + 1,
//               team: team,
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🏆 Group Stats
//   Widget _buildGroupStats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState('কোন তথ্য নেই');
//         }
//
//         final teams = snapshot.data!.docs
//             .map((doc) => TournamentTeamStats.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         ))
//             .toList();
//
//         // Group teams by group
//         final groupedTeams = <String, List<TournamentTeamStats>>{};
//         for (var team in teams) {
//           if (team.group.isNotEmpty) {
//             groupedTeams.putIfAbsent(team.group, () => []).add(team);
//           }
//         }
//
//         // Sort teams within each group
//         groupedTeams.forEach((group, teams) {
//           teams.sort((a, b) {
//             final pointsCompare = b.points.compareTo(a.points);
//             if (pointsCompare != 0) return pointsCompare;
//             return b.goalDifference.compareTo(a.goalDifference);
//           });
//         });
//
//         final sortedGroups = groupedTeams.keys.toList()..sort();
//
//         if (sortedGroups.isEmpty) {
//           return _buildEmptyState('কোন গ্রুপ নেই');
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: sortedGroups.length,
//           itemBuilder: (context, groupIndex) {
//             final groupName = sortedGroups[groupIndex];
//             final groupTeams = groupedTeams[groupName]!;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Group Header
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF28A745),
//                         const Color(0xFF20883A),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF28A745).withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.emoji_events,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         groupName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           '${groupTeams.length} টিম',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Teams in this group
//                 ...groupTeams.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final team = entry.value;
//                   return _buildGroupTeamCard(
//                     position: index + 1,
//                     team: team,
//                   );
//                 }),
//
//                 const SizedBox(height: 24),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // 🎨 Team Stat Card
//   Widget _buildTeamStatCard({
//     required int rank,
//     required TournamentTeamStats team,
//     required int primaryStat,
//     required String primaryStatLabel,
//     required IconData primaryStatIcon,
//     required String secondaryStat,
//     required String secondaryStatLabel,
//     required Color color,
//   }) {
//     Color rankColor = const Color(0xFF0F3460);
//     if (rank == 1) rankColor = const Color(0xFFFFD700);
//     if (rank == 2) rankColor = const Color(0xFFC0C0C0);
//     if (rank == 3) rankColor = const Color(0xFFCD7F32);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
//           width: rank <= 3 ? 2.5 : 1,
//         ),
//         boxShadow: [
//           if (rank <= 3)
//             BoxShadow(
//               color: rankColor.withOpacity(0.3),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Rank badge
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: rankColor,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   bottomRight: Radius.circular(16),
//                 ),
//               ),
//               child: Text(
//                 '#$rank',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           // Main content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 // Team Logo
//                 Container(
//                   width: 60,
//                   height: 60,
//                   margin: const EdgeInsets.only(right: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: rank <= 3 ? rankColor : Colors.white24,
//                       width: 2.5,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: team.teamLogo.isNotEmpty
//                         ? Image.network(
//                       team.teamLogo,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return _buildDefaultLogo(team.teamName);
//                       },
//                     )
//                         : _buildDefaultLogo(team.teamName),
//                   ),
//                 ),
//
//                 // Team Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         team.teamName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           _buildSmallStatBadge(
//                             icon: Icons.stadium,
//                             value: '${team.matchesPlayed}',
//                             label: 'ম্যাচ',
//                           ),
//                           const SizedBox(width: 8),
//                           _buildSmallStatBadge(
//                             icon: Icons.analytics,
//                             value: secondaryStat,
//                             label: 'গড়',
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Primary Stat
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: color.withOpacity(0.5),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(primaryStatIcon, color: color, size: 24),
//                       const SizedBox(height: 6),
//                       Text(
//                         '$primaryStat',
//                         style: TextStyle(
//                           color: color,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 📊 Detailed Team Card (for Overall Stats)
//   Widget _buildDetailedTeamCard({
//     required int rank,
//     required TournamentTeamStats team,
//   }) {
//     Color rankColor = const Color(0xFF0F3460);
//     if (rank == 1) rankColor = const Color(0xFFFFD700);
//     if (rank == 2) rankColor = const Color(0xFFC0C0C0);
//     if (rank == 3) rankColor = const Color(0xFFCD7F32);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
//           width: rank <= 3 ? 3 : 1,
//         ),
//         boxShadow: [
//           if (rank <= 3)
//             BoxShadow(
//               color: rankColor.withOpacity(0.4),
//               blurRadius: 20,
//               offset: const Offset(0, 8),
//             ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.2),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 // Rank
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: rankColor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: rankColor.withOpacity(0.5),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       '$rank',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Team Logo
//                 Container(
//                   width: 70,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: rankColor,
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipOval(
//                     child: team.teamLogo.isNotEmpty
//                         ? Image.network(
//                       team.teamLogo,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return _buildDefaultLogo(team.teamName);
//                       },
//                     )
//                         : _buildDefaultLogo(team.teamName),
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Team Name and Points
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         team.teamName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF28A745),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.emoji_events,
//                                   color: Colors.white,
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   '${team.points} পয়েন্ট',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (team.group.isNotEmpty) ...[
//                             const SizedBox(width: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.white30,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Text(
//                                 team.group,
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Stats Grid
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.stadium,
//                         value: team.matchesPlayed,
//                         label: 'ম্যাচ',
//                         color: const Color(0xFF9C27B0),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.check_circle,
//                         value: team.wins,
//                         label: 'জয়',
//                         color: const Color(0xFF4CAF50),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.remove_circle,
//                         value: team.draws,
//                         label: 'ড্র',
//                         color: const Color(0xFFFFC107),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.cancel,
//                         value: team.losses,
//                         label: 'হার',
//                         color: const Color(0xFFF44336),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.sports_soccer,
//                         value: team.goalsFor,
//                         label: 'গোল',
//                         color: const Color(0xFF4CAF50),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.shield,
//                         value: team.goalsAgainst,
//                         label: 'খেয়েছে',
//                         color: const Color(0xFFF44336),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.compare_arrows,
//                         value: team.goalDifference,
//                         label: 'GD',
//                         color: team.goalDifference >= 0
//                             ? const Color(0xFF4CAF50)
//                             : const Color(0xFFF44336),
//                       ),
//                     ),
//                     Expanded(
//                       child: _buildDetailStatItem(
//                         icon: Icons.percent,
//                         value: team.matchesPlayed > 0
//                             ? ((team.wins / team.matchesPlayed) * 100).round()
//                             : 0,
//                         label: 'জয়%',
//                         color: const Color(0xFF2196F3),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🏆 Group Team Card
//   Widget _buildGroupTeamCard({
//     required int position,
//     required TournamentTeamStats team,
//   }) {
//     Color positionColor = const Color(0xFF0F3460);
//     if (position == 1) positionColor = const Color(0xFFFFD700);
//     if (position == 2) positionColor = const Color(0xFFC0C0C0);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: position <= 2 ? positionColor.withOpacity(0.5) : Colors.white12,
//           width: position <= 2 ? 2 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           // Position
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: positionColor,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 '$position',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Team Logo
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               border: Border.all(color: positionColor, width: 2),
//             ),
//             child: ClipOval(
//               child: team.teamLogo.isNotEmpty
//                   ? Image.network(
//                 team.teamLogo,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildDefaultLogo(team.teamName);
//                 },
//               )
//                   : _buildDefaultLogo(team.teamName),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Team Name
//           Expanded(
//             child: Text(
//               team.teamName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//
//           // Stats
//           Row(
//             children: [
//               _buildMiniStat('${team.matchesPlayed}', 'M'),
//               const SizedBox(width: 8),
//               _buildMiniStat('${team.wins}', 'W'),
//               const SizedBox(width: 8),
//               _buildMiniStat('${team.goalDifference}', 'GD'),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF28A745),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   '${team.points}',
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
//   Widget _buildSmallStatBadge({
//     required IconData icon,
//     required String value,
//     required String label,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white54, size: 12),
//           const SizedBox(width: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailStatItem({
//     required IconData icon,
//     required int value,
//     required String label,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 6),
//         Text(
//           '$value',
//           style: TextStyle(
//             color: color,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMiniStat(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 9,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDefaultLogo(String teamName) {
//     return Container(
//       color: const Color(0xFF28A745),
//       child: Center(
//         child: Text(
//           teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF28A745)),
//           SizedBox(height: 16),
//           Text(
//             'লোড হচ্ছে...',
//             style: TextStyle(color: Colors.white54, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.bar_chart, size: 80, color: Colors.white24),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: const TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // Tab 6: Teams
// class _TeamsTab extends StatelessWidget {
//   final String tournamentId;
//   final TeamProvider teamProvider;
//
//   const _TeamsTab({
//     required this.tournamentId,
//     required this.teamProvider,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_teams')
//           .where('tournamentId', isEqualTo: tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF28A745)),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         final teamIds = snapshot.data!.docs
//             .map((doc) => (doc.data() as Map<String, dynamic>)['teamId'])
//             .whereType<String>()
//             .toList();
//
//         final teams = teamIds
//             .map((id) => teamProvider.getTeamById(id))
//             .whereType<TeamModel>()
//             .toList();
//
//         if (teams.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 1,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//           ),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             final team = teams[index];
//             return _buildTeamCard(team);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTeamCard(TeamModel team) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white12,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Team Logo
//           if (team.logoUrl.isNotEmpty)
//             ClipOval(
//               child: Image.network(
//                 team.logoUrl,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildDefaultLogo();
//                 },
//               ),
//             )
//           else
//             _buildDefaultLogo(),
//
//           const SizedBox(height: 12),
//
//           // Team Name
//           Text(
//             team.name,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           // Team Info
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.people,
//                 color: Color(0xFF28A745),
//                 size: 16,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '${team.playersCount} খেলোয়াড়',
//                 style: const TextStyle(
//                   color: Colors.white54,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDefaultLogo() {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: const Color(0xFF28A745).withOpacity(0.2),
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(
//         Icons.shield,
//         color: Color(0xFF28A745),
//         size: 30,
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.groups, size: 80, color: Colors.white24),
//           const SizedBox(height: 16),
//           const Text(
//             'কোন টিম নেই',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament/tournament_model.dart';
import '../providers/team_provider.dart';
import '../widgets/tournament_tabs_widget.dart';


// ============================================================================
// MAIN TOURNAMENT DETAILS SCREEN
// ============================================================================
class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Tournament? _tournament;
  bool _isLoading = true;
  late TeamProvider _teamProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _teamProvider = TeamProvider();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load teams first
      await _teamProvider.fetchTeams();

      // Load tournament
      final doc = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _tournament = Tournament.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_tournament == null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(),
            _buildSliverTabBar(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            TournamentInfoTab(tournament: _tournament!),
            MatchesTab(
              tournamentId: widget.tournamentId,
              teamProvider: _teamProvider,
            ),
            PointsTableTab(tournamentId: widget.tournamentId),
            PlayerStatsTab(tournamentId: widget.tournamentId),
            TeamStatsTab(tournamentId: widget.tournamentId),
            TeamsTab(
              tournamentId: widget.tournamentId,
              teamProvider: _teamProvider,
            ),
          ],
        ),
      ),
    );
  }

  // Loading Screen
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF28A745),
        ),
      ),
    );
  }

  // Error Screen
  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'টুর্নামেন্ট খুঁজে পাওয়া যায়নি',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
              ),
              child: const Text('ফিরে যান'),
            ),
          ],
        ),
      ),
    );
  }

  // Sliver App Bar (Header with Image)
  Widget _buildSliverAppBar() {
    final tournament = _tournament!;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: const Color(0xFF16213E),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            tournament.imageUrl.isNotEmpty
                ? Image.network(
              tournament.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultHeaderImage();
              },
            )
                : _buildDefaultHeaderImage(),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // Tournament Info
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(tournament.status),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(tournament.status)
                              .withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      tournament.statusInBengali,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tournament Name
                  Text(
                    tournament.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF28A745),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tournament.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Default Header Image
  Widget _buildDefaultHeaderImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F3460), Color(0xFF1A5490)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.emoji_events,
          size: 80,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  // Sliver Tab Bar
  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF28A745),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'তথ্য'),
            Tab(text: 'ম্যাচ'),
            Tab(text: 'টেবিল'),
            Tab(text: 'খেলোয়াড়'),
            Tab(text: 'টিম স্ট্যাট'),
            Tab(text: 'টিম'),
          ],
        ),
      ),
    );
  }

  // Get Status Color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color(0xFF2196F3);
      case 'ongoing':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF757575);
    }
  }
}

// ============================================================================
// SLIVER APP BAR DELEGATE
// ============================================================================
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF16213E),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}