//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class MatchStatsTab extends StatelessWidget {
//   final String matchId;
//
//   const MatchStatsTab({Key? key, required this.matchId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('matches')
//           .doc(matchId)
//           .get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//               child: CircularProgressIndicator(color: Colors.white));
//         }
//
//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final stats = data['stats'] ?? {};
//
//         if (stats.isEmpty) {
//           return const Center(
//               child: Text('No stats available',
//                   style: TextStyle(color: Colors.white70)));
//         }
//
//         return ListView(
//           padding: const EdgeInsets.all(20),
//           children: stats.entries.map((e) {
//             final key = e.key;
//             final value = e.value;
//             return _buildStatRow(key, value);
//           }).toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildStatRow(String stat, dynamic value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(stat.toUpperCase(),
//               style: const TextStyle(color: Colors.white70)),
//           Text(value.toString(),
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }
