//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/match_model.dart';
// import '../providers/team_provider.dart';
//
// class MatchCard extends StatelessWidget {
//   final MatchModel match;
//   final TeamProvider teamProvider;
//
//   const MatchCard({
//     Key? key,
//     required this.match,
//     required this.teamProvider,
//   }) : super(key: key);
//
//   String _getTeamLogoUrl(String teamName) {
//     final team = teamProvider.getTeamByName(teamName);
//     return team?.logoUrl ?? '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final teamALogo = _getTeamLogoUrl(match.teamA);
//     final teamBLogo = _getTeamLogoUrl(match.teamB);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF16213E),
//             const Color(0xFF0F3460),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: _getStatusBorderColor(match.status),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: _getStatusBorderColor(match.status).withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: Column(
//           children: [
//             // Tournament Name Header (যদি থাকে)
//             if (match.tournament != null && match.tournament!.isNotEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF00D9FF).withOpacity(0.15),
//                   border: Border(
//                     bottom: BorderSide(
//                       color: const Color(0xFF00D9FF).withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.emoji_events,
//                       color: Color(0xFF00D9FF),
//                       size: 18,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         match.tournament!,
//                         style: const TextStyle(
//                           color: Color(0xFF00D9FF),
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     // Status Badge
//                     _buildStatusBadge(),
//                   ],
//                 ),
//               ),
//
//             // Match Content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // যদি tournament না থাকে তাহলে এখানে status badge
//                   if (match.tournament == null ||
//                       match.tournament!.isEmpty) ...[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildStatusBadge(),
//                         _buildDateTime(),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                   ] else ...[
//                     // Tournament থাকলে শুধু time
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         _buildDateTime(),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//
//                   // Teams and Score
//                   Row(
//                     children: [
//                       // Team A
//                       Expanded(
//                         child: _buildTeam(
//                           name: match.teamA,
//                           logo: teamALogo,
//                           isWinner: match.status == 'finished' &&
//                               match.scoreA > match.scoreB,
//                         ),
//                       ),
//
//                       // Score Section
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.05),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.1),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             if (match.status == 'upcoming') ...[
//                               const Text(
//                                 'VS',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                             ] else ...[
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     '${match.scoreA}',
//                                     style: TextStyle(
//                                       color: match.scoreA > match.scoreB
//                                           ? Colors.greenAccent
//                                           : Colors.white,
//                                       fontSize: 32,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 8),
//                                     child: Text(
//                                       ':',
//                                       style: TextStyle(
//                                         color: Colors.white54,
//                                         fontSize: 24,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     '${match.scoreB}',
//                                     style: TextStyle(
//                                       color: match.scoreB > match.scoreA
//                                           ? Colors.greenAccent
//                                           : Colors.white,
//                                       fontSize: 32,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                             if (match.status == 'live') ...[
//                               const SizedBox(height: 6),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 3,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Text(
//                                   'LIVE',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 1,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//
//                       // Team B
//                       Expanded(
//                         child: _buildTeam(
//                           name: match.teamB,
//                           logo: teamBLogo,
//                           isWinner: match.status == 'finished' &&
//                               match.scoreB > match.scoreA,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Venue (যদি থাকে)
//                   if (match.venue != null && match.venue!.isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             color: Colors.white60,
//                             size: 14,
//                           ),
//                           const SizedBox(width: 6),
//                           Flexible(
//                             child: Text(
//                               match.venue!,
//                               style: const TextStyle(
//                                 color: Colors.white60,
//                                 fontSize: 12,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge() {
//     Color statusColor;
//     String statusText;
//     IconData statusIcon;
//
//     switch (match.status) {
//       case 'live':
//         statusColor = Colors.red;
//         statusText = 'লাইভ';
//         statusIcon = Icons.play_circle_filled;
//         break;
//       case 'upcoming':
//         statusColor = Colors.orange;
//         statusText = 'আসন্ন';
//         statusIcon = Icons.schedule;
//         break;
//       case 'finished':
//         statusColor = Colors.green;
//         statusText = 'সমাপ্ত';
//         statusIcon = Icons.check_circle;
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusText = 'অজানা';
//         statusIcon = Icons.help;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: statusColor,
//           width: 1.5,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             statusIcon,
//             color: statusColor,
//             size: 14,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             statusText,
//             style: TextStyle(
//               color: statusColor,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateTime() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Icon(
//           Icons.calendar_today,
//           color: Colors.white54,
//           size: 12,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           DateFormat('dd MMM').format(match.date),
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(width: 8),
//         const Icon(
//           Icons.access_time,
//           color: Colors.white54,
//           size: 12,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           DateFormat('hh:mm a').format(match.time),
//           style: const TextStyle(
//             color: Colors.white54,
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTeam({
//     required String name,
//     required String logo,
//     required bool isWinner,
//   }) {
//     return Column(
//       children: [
//         // Team Logo
//         Container(
//           width: 70,
//           height: 70,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: isWinner
//                   ? Colors.greenAccent
//                   : Colors.white.withOpacity(0.2),
//               width: isWinner ? 3 : 2,
//             ),
//             boxShadow: isWinner
//                 ? [
//               BoxShadow(
//                 color: Colors.greenAccent.withOpacity(0.4),
//                 blurRadius: 12,
//                 spreadRadius: 2,
//               ),
//             ]
//                 : null,
//           ),
//           child: ClipOval(
//             child: logo.isNotEmpty
//                 ? CachedNetworkImage(
//               imageUrl: logo,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 color: const Color(0xFF0F3460),
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 ),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 color: const Color(0xFF0F3460),
//                 child: const Icon(
//                   Icons.sports_soccer,
//                   color: Colors.white60,
//                   size: 35,
//                 ),
//               ),
//             )
//                 : Container(
//               color: const Color(0xFF0F3460),
//               child: const Icon(
//                 Icons.sports_soccer,
//                 color: Colors.white60,
//                 size: 35,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         // Team Name
//         Text(
//           name,
//           textAlign: TextAlign.center,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: isWinner ? Colors.greenAccent : Colors.white,
//             fontSize: 14,
//             fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
//             height: 1.2,
//           ),
//         ),
//         if (isWinner) ...[
//           const SizedBox(height: 4),
//           const Icon(
//             Icons.emoji_events,
//             color: Colors.greenAccent,
//             size: 16,
//           ),
//         ],
//       ],
//     );
//   }
//
//   Color _getStatusBorderColor(String status) {
//     switch (status) {
//       case 'live':
//         return Colors.red;
//       case 'upcoming':
//         return Colors.orange;
//       case 'finished':
//         return Colors.green;
//       default:
//         return Colors.white24;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/match_model.dart';
import '../providers/team_provider.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final TeamProvider teamProvider;

  const MatchCard({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  String _getTeamLogoUrl(String teamName) {
    final team = teamProvider.getTeamByName(teamName);
    return team?.logoUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final teamALogo = _getTeamLogoUrl(match.teamA);
    final teamBLogo = _getTeamLogoUrl(match.teamB);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusBorderColor(match.status),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getStatusBorderColor(match.status).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            // Tournament Name Header (✅ FIXED - Shows actual tournament name)
            if (match.tournament != null && match.tournament!.isNotEmpty)
              _buildTournamentHeader(match.tournament!),

            // Match Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // যদি tournament না থাকে তাহলে এখানে status badge
                  if (match.tournament == null ||
                      match.tournament!.isEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusBadge(),
                        _buildDateTime(),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Tournament থাকলে শুধু time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildDateTime(),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Teams and Score
                  Row(
                    children: [
                      // Team A
                      Expanded(
                        child: _buildTeam(
                          name: match.teamA,
                          logo: teamALogo,
                          isWinner: match.status == 'finished' &&
                              match.scoreA > match.scoreB,
                        ),
                      ),

                      // Score Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (match.status == 'upcoming') ...[
                              const Text(
                                'VS',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ] else ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${match.scoreA}',
                                    style: TextStyle(
                                      color: match.scoreA > match.scoreB
                                          ? Colors.greenAccent
                                          : Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      ':',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${match.scoreB}',
                                    style: TextStyle(
                                      color: match.scoreB > match.scoreA
                                          ? Colors.greenAccent
                                          : Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (match.status == 'live') ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Team B
                      Expanded(
                        child: _buildTeam(
                          name: match.teamB,
                          logo: teamBLogo,
                          isWinner: match.status == 'finished' &&
                              match.scoreB > match.scoreA,
                        ),
                      ),
                    ],
                  ),

                  // Venue (যদি থাকে)
                  if (match.venue != null && match.venue!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white60,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              match.venue!,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Fetch and display tournament name from Firestore
  Widget _buildTournamentHeader(String tournamentId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .get(),
      builder: (context, snapshot) {
        String tournamentName = tournamentId; // Fallback to ID

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null && data['name'] != null) {
            tournamentName = data['name']; // ✅ Get actual tournament name
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF00D9FF).withOpacity(0.15),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF00D9FF).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFF00D9FF),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tournamentName, // ✅ Shows "Moon Cup" instead of ID
                  style: const TextStyle(
                    color: Color(0xFF00D9FF),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status Badge
              _buildStatusBadge(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (match.status) {
      case 'live':
        statusColor = Colors.red;
        statusText = 'লাইভ';
        statusIcon = Icons.play_circle_filled;
        break;
      case 'upcoming':
        statusColor = Colors.orange;
        statusText = 'আসন্ন';
        statusIcon = Icons.schedule;
        break;
      case 'finished':
      case 'completed':
        statusColor = Colors.green;
        statusText = 'সমাপ্ত';
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'অজানা';
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.calendar_today,
          color: Colors.white54,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('dd MMM').format(match.date),
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.access_time,
          color: Colors.white54,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('hh:mm a').format(match.time),
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTeam({
    required String name,
    required String logo,
    required bool isWinner,
  }) {
    return Column(
      children: [
        // Team Logo
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isWinner
                  ? Colors.greenAccent
                  : Colors.white.withOpacity(0.2),
              width: isWinner ? 3 : 2,
            ),
            boxShadow: isWinner
                ? [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
                : null,
          ),
          child: ClipOval(
            child: logo.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: logo,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF0F3460),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF0F3460),
                child: const Icon(
                  Icons.sports_soccer,
                  color: Colors.white60,
                  size: 35,
                ),
              ),
            )
                : Container(
              color: const Color(0xFF0F3460),
              child: const Icon(
                Icons.sports_soccer,
                color: Colors.white60,
                size: 35,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Team Name
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isWinner ? Colors.greenAccent : Colors.white,
            fontSize: 14,
            fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
            height: 1.2,
          ),
        ),
        if (isWinner) ...[
          const SizedBox(height: 4),
          const Icon(
            Icons.emoji_events,
            color: Colors.greenAccent,
            size: 16,
          ),
        ],
      ],
    );
  }

  Color _getStatusBorderColor(String status) {
    switch (status) {
      case 'live':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      case 'finished':
      case 'completed':
        return Colors.green;
      default:
        return Colors.white24;
    }
  }
}