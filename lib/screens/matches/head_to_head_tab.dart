// import 'package:flutter/material.dart';
// import '../../models/match_model.dart';
//
// class HeadToHeadTab extends StatelessWidget {
//   final MatchModel match;
//
//   const HeadToHeadTab({
//     Key? key,
//     required this.match,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (match.h2h == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.history,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'পূর্ববর্তী রেকর্ড নেই',
//               style: TextStyle(
//                 color: Colors.white54,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     final h2h = match.h2h!;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Total Matches Card
//           _buildH2HCard(
//             title: 'মোট ম্যাচ',
//             value: '${h2h.totalMatches}',
//             icon: Icons.sports_soccer,
//             color: Colors.white,
//           ),
//
//           const SizedBox(height: 16),
//
//           // Win Comparison Row
//           Row(
//             children: [
//               Expanded(
//                 child: _buildH2HCard(
//                   title: match.teamA,
//                   subtitle: 'জয়',
//                   value: '${h2h.teamAWins}',
//                   color: Colors.blue,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'ড্র',
//                   value: '${h2h.draws}',
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: match.teamB,
//                   subtitle: 'জয়',
//                   value: '${h2h.teamBWins}',
//                   color: Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Goals Comparison Row
//           Row(
//             children: [
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'গোল',
//                   subtitle: match.teamA,
//                   value: '${h2h.teamAGoals}',
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'গোল',
//                   subtitle: match.teamB,
//                   value: '${h2h.teamBGoals}',
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildH2HCard({
//     required String title,
//     required String value,
//     String? subtitle,
//     IconData? icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           if (icon != null) ...[
//             Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//             const SizedBox(height: 8),
//           ],
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 12,
//             ),
//           ),
//           if (subtitle != null) ...[
//             const SizedBox(height: 2),
//             Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }