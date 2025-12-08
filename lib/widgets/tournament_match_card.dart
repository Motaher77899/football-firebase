//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/tournament/tournament_match_model.dart';
// import '../models/team_model.dart';
// import '../providers/team_provider.dart';
//
//
// class TournamentMatchCard extends StatelessWidget {
//   final TournamentMatch match;
//   final TeamProvider teamProvider;
//
//   const TournamentMatchCard({
//     Key? key,
//     required this.match,
//     required this.teamProvider,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Dynamically fetch team data using team IDs
//     final TeamModel? homeTeam = teamProvider.getTeamById(match.homeTeamId);
//     final TeamModel? awayTeam = teamProvider.getTeamById(match.awayTeamId);
//
//     final dateFormat = DateFormat('dd MMM yyyy');
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _getMatchStatusColor(match.status).withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Round & Date & Status Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Round
//               if (match.round.isNotEmpty)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF28A745).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     match.round,
//                     style: const TextStyle(
//                       color: Color(0xFF28A745),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               const Spacer(),
//               // Status Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getMatchStatusColor(match.status).withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (match.status == 'live')
//                       Container(
//                         width: 6,
//                         height: 6,
//                         margin: const EdgeInsets.only(right: 4),
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     Text(
//                       match.statusInBengali,
//                       style: TextStyle(
//                         color: _getMatchStatusColor(match.status),
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//
//           // Date & Time
//           Text(
//             '${dateFormat.format(match.matchDate)} • ${match.matchTime}',
//             style: const TextStyle(
//               color: Colors.white54,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Teams Row
//           Row(
//             children: [
//               // Home Team
//               Expanded(
//                 child: _buildTeamColumn(
//                   team: homeTeam,
//                   teamId: match.homeTeamId,
//                   alignment: CrossAxisAlignment.center,
//                 ),
//               ),
//
//               // Score/Status Container
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _getMatchStatusColor(match.status),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _getMatchStatusColor(match.status).withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: match.status == 'completed' || match.status == 'live'
//                     ? Text(
//                   '${match.homeScore} - ${match.awayScore}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//                     : const Icon(
//                   Icons.schedule,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//
//               // Away Team
//               Expanded(
//                 child: _buildTeamColumn(
//                   team: awayTeam,
//                   teamId: match.awayTeamId,
//                   alignment: CrossAxisAlignment.center,
//                 ),
//               ),
//             ],
//           ),
//
//           // Venue
//           if (match.venue.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0F3460),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.location_on, size: 14, color: Colors.white54),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       match.venue,
//                       style: const TextStyle(
//                         color: Colors.white54,
//                         fontSize: 12,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamColumn({
//     required TeamModel? team,
//     required String teamId,
//     required CrossAxisAlignment alignment,
//   }) {
//     return Column(
//       crossAxisAlignment: alignment,
//       children: [
//         // Team Logo - ✅ Using logoUrl field
//         if (team != null && team.logoUrl.isNotEmpty)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               team.logoUrl,  // ✅ Correct field name
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 debugPrint('❌ Error loading team logo: ${team.logoUrl}');
//                 return _buildTeamPlaceholder();
//               },
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                           loadingProgress.expectedTotalBytes!
//                           : null,
//                       strokeWidth: 2,
//                       color: const Color(0xFF28A745),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         else
//           _buildTeamPlaceholder(),
//         const SizedBox(height: 8),
//
//         // Team Name
//         Text(
//           team?.name ?? 'Unknown Team',
//           textAlign: TextAlign.center,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: team != null ? Colors.white : Colors.white54,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         // Debug info (only if team not found)
//         if (team == null) ...[
//           const SizedBox(height: 4),
//           Text(
//             'ID: $teamId',
//             style: const TextStyle(
//               color: Colors.red,
//               fontSize: 10,
//               fontFamily: 'monospace',
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildTeamPlaceholder() {
//     return Container(
//       width: 60,
//       height: 60,
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F3460),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: const Icon(Icons.shield, color: Colors.white54, size: 30),
//     );
//   }
//
//   Color _getMatchStatusColor(String status) {
//     switch (status) {
//       case 'live':
//         return const Color(0xFF4CAF50);
//       case 'completed':
//         return const Color(0xFF0F3460);
//       case 'upcoming':
//         return const Color(0xFF2196F3);
//       default:
//         return const Color(0xFF1A5490);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament/tournament_match_model.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';

class TournamentMatchCard extends StatelessWidget {
  final TournamentMatch match;
  final TeamProvider teamProvider;

  const TournamentMatchCard({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Dynamically fetch team data using team IDs
    final TeamModel? homeTeam = teamProvider.getTeamById(match.homeTeamId);
    final TeamModel? awayTeam = teamProvider.getTeamById(match.awayTeamId);

    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getMatchStatusColor(match.status).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Tournament Name Header (✅ FIXED - Shows actual tournament name)
          if (match.tournamentId.isNotEmpty)
            _buildTournamentNameHeader(),

          // Round & Date & Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Round
              if (match.round.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28A745).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match.round,
                    style: const TextStyle(
                      color: Color(0xFF28A745),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMatchStatusColor(match.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (match.status == 'live')
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      match.statusInBengali,
                      style: TextStyle(
                        color: _getMatchStatusColor(match.status),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date & Time
          Text(
            '${dateFormat.format(match.matchDate)} • ${match.matchTime}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Teams Row
          Row(
            children: [
              // Home Team
              Expanded(
                child: _buildTeamColumn(
                  team: homeTeam,
                  teamId: match.homeTeamId,
                  alignment: CrossAxisAlignment.center,
                ),
              ),

              // Score/Status Container
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _getMatchStatusColor(match.status),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getMatchStatusColor(match.status).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: match.status == 'completed' || match.status == 'live'
                    ? Text(
                  '${match.homeScore} - ${match.awayScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              // Away Team
              Expanded(
                child: _buildTeamColumn(
                  team: awayTeam,
                  teamId: match.awayTeamId,
                  alignment: CrossAxisAlignment.center,
                ),
              ),
            ],
          ),

          // Venue
          if (match.venue.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.white54),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      match.venue,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ NEW: Fetch and display tournament name from Firestore
  Widget _buildTournamentNameHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('tournaments')
          .doc(match.tournamentId)
          .get(),
      builder: (context, snapshot) {
        String tournamentName = match.tournamentId; // Fallback to ID

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null && data['name'] != null) {
            tournamentName = data['name'];
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withOpacity(0.3),
                Colors.cyan.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.cyan.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.cyan,
                size: 14,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  tournamentName,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamColumn({
    required TeamModel? team,
    required String teamId,
    required CrossAxisAlignment alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Team Logo - ✅ Using logoUrl field
        if (team != null && team.logoUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              team.logoUrl, // ✅ Correct field name
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ Error loading team logo: ${team.logoUrl}');
                return _buildTeamPlaceholder();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: const Color(0xFF28A745),
                    ),
                  ),
                );
              },
            ),
          )
        else
          _buildTeamPlaceholder(),
        const SizedBox(height: 8),

        // Team Name
        Text(
          team?.name ?? 'Unknown Team',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: team != null ? Colors.white : Colors.white54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Debug info (only if team not found)
        if (team == null) ...[
          const SizedBox(height: 4),
          Text(
            'ID: $teamId',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTeamPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.shield, color: Colors.white54, size: 30),
    );
  }

  Color _getMatchStatusColor(String status) {
    switch (status) {
      case 'live':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF0F3460);
      case 'upcoming':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF1A5490);
    }
  }
}