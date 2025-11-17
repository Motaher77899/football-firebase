// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class TournamentTeamItemWidget extends StatelessWidget {
//   final Map<String, dynamic> team;
//
//   const TournamentTeamItemWidget({
//     Key? key,
//     required this.team,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final name = team['name'] ?? 'টিম';
//     final upazila = team['upazila'] ?? 'অজানা';
//     final logoUrl = team['logoUrl'];
//     final playersCount = team['playersCount'] ?? 0;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
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
//                   color: const Color(0xFF00D9FF).withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: ClipOval(
//               child: logoUrl != null && logoUrl.isNotEmpty
//                   ? CachedNetworkImage(
//                 imageUrl: logoUrl,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => const Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF00D9FF),
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => const Icon(
//                   Icons.sports_soccer,
//                   color: Color(0xFF00D9FF),
//                   size: 40,
//                 ),
//               )
//                   : const Icon(
//                 Icons.sports_soccer,
//                 color: Color(0xFF00D9FF),
//                 size: 40,
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Team Name
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               name,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // Location
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.location_on,
//                 color: Color(0xFF00D9FF),
//                 size: 14,
//               ),
//               const SizedBox(width: 4),
//               Flexible(
//                 child: Text(
//                   upazila,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//
//           // Players Count
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 6,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFF0F3460),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.person,
//                   color: Color(0xFF00D9FF),
//                   size: 16,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   '$playersCount খেলোয়াড়',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }