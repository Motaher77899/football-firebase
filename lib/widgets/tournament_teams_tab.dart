// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
//
// // Models
// import '../models/team_model.dart';
//
// // Providers
// import '../providers/team_provider.dart';
//
// // ============================================================================
// // TEAMS TAB - Fixed Version
// // ============================================================================
// class TeamsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const TeamsTab({
//     Key? key,
//     required this.tournamentId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Get provider inside the widget
//     final teamProvider = Provider.of<TeamProvider>(context);
//
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
//         if (snapshot.hasError) {
//           return _buildErrorState(snapshot.error.toString());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         // ✅ Get team IDs from tournament_teams collection
//         final teamIds = snapshot.data!.docs
//             .map((doc) {
//           try {
//             final data = doc.data() as Map<String, dynamic>;
//             return data['teamId'] as String?;
//           } catch (e) {
//             return null;
//           }
//         })
//             .whereType<String>()
//             .toList();
//
//         if (teamIds.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         // ✅ Get team details from provider
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
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 0.9,
//           ),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             return _buildTeamCard(context, teams[index]);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTeamCard(BuildContext context, TeamModel team) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF28A745).withOpacity(0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Team Logo
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF28A745).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: ClipOval(
//               child: team.logoUrl.isNotEmpty
//                   ? Image.network(
//                 team.logoUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildTeamPlaceholder(team.name);
//                 },
//               )
//                   : _buildTeamPlaceholder(team.name),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Team Name
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               team.name,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamPlaceholder(String teamName) {
//     return Container(
//       color: const Color(0xFF28A745),
//       child: Center(
//         child: Text(
//           teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.groups, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'কোন টিম নেই',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 80, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(
//             'Error: $error',
//             style: const TextStyle(color: Colors.white54, fontSize: 14),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // POINTS TABLE TAB
// // ============================================================================
// class PointsTableTab extends StatelessWidget {
//   final String tournamentId;
//
//   const PointsTableTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
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
//         // Parse and sort by points
//         final teams = snapshot.data!.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'teamId': data['teamId'] ?? '',
//             'teamName': data['teamName'] ?? 'Unknown',
//             'played': data['played'] ?? 0,
//             'won': data['won'] ?? 0,
//             'draw': data['draw'] ?? 0,
//             'lost': data['lost'] ?? 0,
//             'goalsFor': data['goalsFor'] ?? 0,
//             'goalsAgainst': data['goalsAgainst'] ?? 0,
//             'goalDifference': data['goalDifference'] ?? 0,
//             'points': data['points'] ?? 0,
//           };
//         }).toList();
//
//         teams.sort((a, b) {
//           final pointsCompare = (b['points'] as int).compareTo(a['points'] as int);
//           if (pointsCompare != 0) return pointsCompare;
//           return (b['goalDifference'] as int).compareTo(a['goalDifference'] as int);
//         });
//
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: _buildPointsTable(teams),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPointsTable(List<Map<String, dynamic>> teams) {
//     return DataTable(
//       headingRowColor: MaterialStateProperty.all(const Color(0xFF16213E)),
//       dataRowColor: MaterialStateProperty.all(const Color(0xFF0F3460)),
//       border: TableBorder.all(
//         color: const Color(0xFF28A745).withOpacity(0.3),
//         width: 1,
//       ),
//       columns: const [
//         DataColumn(label: Text('#', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('টিম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('ম্যাচ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('জয়', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('ড্র', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('হার', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('পয়েন্ট', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//       ],
//       rows: teams.asMap().entries.map((entry) {
//         final index = entry.key;
//         final team = entry.value;
//         final isTopThree = index < 3;
//
//         return DataRow(
//           cells: [
//             DataCell(Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isTopThree ? _getPositionColor(index) : null,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '${index + 1}',
//                 style: TextStyle(
//                   color: isTopThree ? Colors.white : Colors.white70,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )),
//             DataCell(Text(team['teamName'], style: const TextStyle(color: Colors.white))),
//             DataCell(Text('${team['played']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text('${team['won']}', style: const TextStyle(color: Color(0xFF4CAF50)))),
//             DataCell(Text('${team['draw']}', style: const TextStyle(color: Colors.amber))),
//             DataCell(Text('${team['lost']}', style: const TextStyle(color: Colors.red))),
//             DataCell(Text('${team['goalsFor']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text('${team['goalsAgainst']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text(
//               '${team['goalDifference']}',
//               style: TextStyle(
//                 color: (team['goalDifference'] as int) > 0
//                     ? const Color(0xFF4CAF50)
//                     : (team['goalDifference'] as int) < 0
//                     ? Colors.red
//                     : Colors.white70,
//                 fontWeight: FontWeight.bold,
//               ),
//             )),
//             DataCell(Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF28A745),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 '${team['points']}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             )),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   Color _getPositionColor(int position) {
//     switch (position) {
//       case 0:
//         return const Color(0xFFFFD700); // Gold
//       case 1:
//         return const Color(0xFFC0C0C0); // Silver
//       case 2:
//         return const Color(0xFFCD7F32); // Bronze
//       default:
//         return Colors.transparent;
//     }
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.table_chart, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'পয়েন্ট টেবিল নেই',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // PLAYER STATS TAB (Placeholder)
// // ============================================================================
// class PlayerStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const PlayerStatsTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.sports_soccer, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'খেলোয়াড় পরিসংখ্যান শীঘ্রই আসছে',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // TEAM STATS TAB (Placeholder)
// // ============================================================================
// class TeamStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const TeamStatsTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.bar_chart, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'টিম পরিসংখ্যান শীঘ্রই আসছে',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
//
// // Models
// import '../models/team_model.dart';
//
// // Providers
// import '../providers/team_provider.dart';
//
// // ============================================================================
// // TEAMS TAB - FIXED VERSION (Reads from tournament.teamIds)
// // ============================================================================
// class TeamsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const TeamsTab({
//     Key? key,
//     required this.tournamentId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final teamProvider = Provider.of<TeamProvider>(context);
//
//     return StreamBuilder<DocumentSnapshot>(
//       // ✅ FIXED: Read tournament document to get teamIds
//       stream: FirebaseFirestore.instance
//           .collection('tournaments')
//           .doc(tournamentId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF28A745)),
//           );
//         }
//
//         if (snapshot.hasError) {
//           return _buildErrorState(snapshot.error.toString());
//         }
//
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return _buildErrorState('Tournament not found');
//         }
//
//         // ✅ Get teamIds from tournament document
//         final tournamentData = snapshot.data!.data() as Map<String, dynamic>;
//         final teamIds = List<String>.from(tournamentData['teamIds'] ?? []);
//
//         if (teamIds.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         // ✅ Get team details from provider
//         final teams = teamIds
//             .map((id) => teamProvider.getTeamById(id))
//             .whereType<TeamModel>()
//             .toList();
//
//         if (teams.isEmpty) {
//           return _buildNoTeamsLoadedState();
//         }
//
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 0.9,
//           ),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             return _buildTeamCard(context, teams[index]);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTeamCard(BuildContext context, TeamModel team) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF28A745).withOpacity(0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Team Logo
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF28A745).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: ClipOval(
//               child: team.logoUrl.isNotEmpty
//                   ? Image.network(
//                 team.logoUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return _buildTeamPlaceholder(team.name);
//                 },
//               )
//                   : _buildTeamPlaceholder(team.name),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Team Name
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               team.name,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamPlaceholder(String teamName) {
//     return Container(
//       color: const Color(0xFF28A745),
//       child: Center(
//         child: Text(
//           teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.groups, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'কোন টিম নেই',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'টুর্নামেন্টে এখনো টিম যুক্ত করা হয়নি',
//             style: TextStyle(color: Colors.white38, fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNoTeamsLoadedState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.sync_problem, size: 80, color: Colors.orange),
//           SizedBox(height: 16),
//           Text(
//             'টিম লোড করা যায়নি',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'দয়া করে পেজ রিফ্রেশ করুন',
//             style: TextStyle(color: Colors.white38, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 80, color: Colors.red),
//           const SizedBox(height: 16),
//           const Text(
//             'Error',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               error,
//               style: const TextStyle(color: Colors.white38, fontSize: 12),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // POINTS TABLE TAB
// // ============================================================================
// class PointsTableTab extends StatelessWidget {
//   final String tournamentId;
//
//   const PointsTableTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_team_stats')
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
//         // Parse and sort by points
//         final teams = snapshot.data!.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'teamId': data['teamId'] ?? '',
//             'teamName': data['teamName'] ?? 'Unknown',
//             'played': data['played'] ?? 0,
//             'won': data['won'] ?? 0,
//             'draw': data['draw'] ?? 0,
//             'lost': data['lost'] ?? 0,
//             'goalsFor': data['goalsFor'] ?? 0,
//             'goalsAgainst': data['goalsAgainst'] ?? 0,
//             'goalDifference': data['goalDifference'] ?? 0,
//             'points': data['points'] ?? 0,
//           };
//         }).toList();
//
//         teams.sort((a, b) {
//           final pointsCompare = (b['points'] as int).compareTo(a['points'] as int);
//           if (pointsCompare != 0) return pointsCompare;
//           return (b['goalDifference'] as int).compareTo(a['goalDifference'] as int);
//         });
//
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: _buildPointsTable(teams),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPointsTable(List<Map<String, dynamic>> teams) {
//     return DataTable(
//       headingRowColor: MaterialStateProperty.all(const Color(0xFF16213E)),
//       dataRowColor: MaterialStateProperty.all(const Color(0xFF0F3460)),
//       border: TableBorder.all(
//         color: const Color(0xFF28A745).withOpacity(0.3),
//         width: 1,
//       ),
//       columns: const [
//         DataColumn(label: Text('#', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('টিম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('ম্যাচ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('জয়', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('ড্র', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('হার', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('GD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//         DataColumn(label: Text('পয়েন্ট', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
//       ],
//       rows: teams.asMap().entries.map((entry) {
//         final index = entry.key;
//         final team = entry.value;
//         final isTopThree = index < 3;
//
//         return DataRow(
//           cells: [
//             DataCell(Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isTopThree ? _getPositionColor(index) : null,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '${index + 1}',
//                 style: TextStyle(
//                   color: isTopThree ? Colors.white : Colors.white70,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )),
//             DataCell(Text(team['teamName'], style: const TextStyle(color: Colors.white))),
//             DataCell(Text('${team['played']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text('${team['won']}', style: const TextStyle(color: Color(0xFF4CAF50)))),
//             DataCell(Text('${team['draw']}', style: const TextStyle(color: Colors.amber))),
//             DataCell(Text('${team['lost']}', style: const TextStyle(color: Colors.red))),
//             DataCell(Text('${team['goalsFor']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text('${team['goalsAgainst']}', style: const TextStyle(color: Colors.white70))),
//             DataCell(Text(
//               '${team['goalDifference']}',
//               style: TextStyle(
//                 color: (team['goalDifference'] as int) > 0
//                     ? const Color(0xFF4CAF50)
//                     : (team['goalDifference'] as int) < 0
//                     ? Colors.red
//                     : Colors.white70,
//                 fontWeight: FontWeight.bold,
//               ),
//             )),
//             DataCell(Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF28A745),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 '${team['points']}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             )),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   Color _getPositionColor(int position) {
//     switch (position) {
//       case 0:
//         return const Color(0xFFFFD700); // Gold
//       case 1:
//         return const Color(0xFFC0C0C0); // Silver
//       case 2:
//         return const Color(0xFFCD7F32); // Bronze
//       default:
//         return Colors.transparent;
//     }
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.table_chart, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'পয়েন্ট টেবিল নেই',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // PLAYER STATS TAB (Placeholder)
// // ============================================================================
// class PlayerStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const PlayerStatsTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.sports_soccer, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'খেলোয়াড় পরিসংখ্যান শীঘ্রই আসছে',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // TEAM STATS TAB (Placeholder)
// // ============================================================================
// class TeamStatsTab extends StatelessWidget {
//   final String tournamentId;
//
//   const TeamStatsTab({Key? key, required this.tournamentId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.bar_chart, size: 80, color: Colors.white24),
//           SizedBox(height: 16),
//           Text(
//             'টিম পরিসংখ্যান শীঘ্রই আসছে',
//             style: TextStyle(color: Colors.white54, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Models
import '../models/team_model.dart';

// Providers
import '../providers/team_provider.dart';
import '../screens/tournaments/tournament_team_players_screen.dart';

// Screens


// ============================================================================
// TEAMS TAB - User Version with Navigation (Read-only)
// ============================================================================
class TeamsTab extends StatelessWidget {
  final String tournamentId;
  final String tournamentName;

  const TeamsTab({
    Key? key,
    required this.tournamentId,
    required this.tournamentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF28A745)),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildErrorState('Tournament not found');
        }

        final tournamentData = snapshot.data!.data() as Map<String, dynamic>;
        final teamIds = List<String>.from(tournamentData['teamIds'] ?? []);

        if (teamIds.isEmpty) {
          return _buildEmptyState();
        }

        final teams = teamIds
            .map((id) => teamProvider.getTeamById(id))
            .whereType<TeamModel>()
            .toList();

        if (teams.isEmpty) {
          return _buildNoTeamsLoadedState();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return _buildTeamCard(context, teams[index]);
          },
        );
      },
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamModel team) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // ✅ Navigate to player view screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentTeamPlayersScreen(
                tournamentId: tournamentId,
                tournamentName: tournamentName,
                team: team,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF28A745).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Team Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF28A745).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: team.logoUrl.isNotEmpty
                      ? Image.network(
                    team.logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildTeamPlaceholder(team.name);
                    },
                  )
                      : _buildTeamPlaceholder(team.name),
                ),
              ),
              const SizedBox(height: 12),

              // Team Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  team.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Click Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF28A745).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF28A745),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.people,
                      color: Color(0xFF28A745),
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'খেলোয়াড় দেখুন',
                      style: TextStyle(
                        color: Color(0xFF28A745),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamPlaceholder(String teamName) {
    return Container(
      color: const Color(0xFF28A745),
      child: Center(
        child: Text(
          teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.groups, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'কোন টিম নেই',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'টুর্নামেন্টে এখনো টিম যুক্ত করা হয়নি',
            style: TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoTeamsLoadedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.sync_problem, size: 80, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'টিম লোড করা যায়নি',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'দয়া করে পেজ রিফ্রেশ করুন',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}