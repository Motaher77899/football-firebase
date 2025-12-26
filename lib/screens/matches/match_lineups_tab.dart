// import 'package:flutter/material.dart';
// import '../../models/match_model.dart';
//
// class MatchLineupsTab extends StatelessWidget {
//   final MatchModel match;
//
//   const MatchLineupsTab({
//     Key? key,
//     required this.match,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (match.lineUpA == null && match.lineUpB == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.sports_outlined,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'লাইনআপ নেই',
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
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           // Team Tabs
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF16213E),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.1),
//                 width: 1,
//               ),
//             ),
//             child: TabBar(
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.3),
//                     Colors.blue.withOpacity(0.2),
//                   ],
//                 ),
//               ),
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white54,
//               labelStyle: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               unselectedLabelStyle: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.normal,
//               ),
//               tabs: [
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Flexible(
//                         child: Text(
//                           match.teamA,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Flexible(
//                         child: Text(
//                           match.teamB,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Team Lineup Content
//           Expanded(
//             child: TabBarView(
//               children: [
//                 // Team A Lineup
//                 _buildSingleTeamLineup(
//                   match.teamA,
//                   match.lineUpA,
//                   Colors.blue,
//                 ),
//                 // Team B Lineup
//                 _buildSingleTeamLineup(
//                   match.teamB,
//                   match.lineUpB,
//                   Colors.orange,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSingleTeamLineup(
//       String teamName, LineUp? lineUp, Color teamColor) {
//     if (lineUp == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.sports_outlined,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'লাইনআপ নেই',
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
//     // Group players by position (exclude substitutes)
//     final gk = lineUp.players
//         .where((p) => p.position == 'গোলকিপার' && !p.isSubstitute)
//         .toList();
//     final def = lineUp.players
//         .where((p) => p.position == 'ডিফেন্ডার' && !p.isSubstitute)
//         .toList();
//     final mid = lineUp.players
//         .where((p) => p.position == 'মিডফিল্ডার' && !p.isSubstitute)
//         .toList();
//     final fwd = lineUp.players
//         .where((p) => p.position == 'ফরওয়ার্ড' && !p.isSubstitute)
//         .toList();
//     final subs = lineUp.players.where((p) => p.isSubstitute).toList();
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           // Formation Display
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   teamColor.withOpacity(0.2),
//                   teamColor.withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: teamColor.withOpacity(0.3),
//                 width: 2,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.shield,
//                       color: teamColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         teamName.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: teamColor.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.sports_soccer,
//                         color: teamColor,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Formation: ${lineUp.formation}',
//                         style: TextStyle(
//                           color: teamColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Starting XI Header
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: teamColor,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'স্টার্টিং ইলেভেন',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Positions
//           if (gk.isNotEmpty) ...[
//             _buildPositionGroupFull('গোলরক্ষক', gk, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (def.isNotEmpty) ...[
//             _buildPositionGroupFull('ডিফেন্ডার', def, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (mid.isNotEmpty) ...[
//             _buildPositionGroupFull('মিডফিল্ডার', mid, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (fwd.isNotEmpty) ...[
//             _buildPositionGroupFull('ফরোয়ার্ড', fwd, teamColor),
//           ],
//
//           // Substitutes
//           if (subs.isNotEmpty) ...[
//             const SizedBox(height: 32),
//             Row(
//               children: [
//                 Container(
//                   width: 4,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white54,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'সাবস্টিটিউট',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...subs.map((player) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _buildPlayerCardFull(player, teamColor),
//             )),
//           ],
//
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPositionGroupFull(
//       String position, List<PlayerLineUp> players, Color color) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             position,
//             style: TextStyle(
//               color: color,
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...players.map((player) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _buildPlayerCardFull(player, color),
//         )),
//       ],
//     );
//   }
//
//   Widget _buildPlayerCardFull(PlayerLineUp player, Color color) {
//     // Get first letter of player name
//     String firstLetter = player.playerName.isNotEmpty
//         ? player.playerName[0].toUpperCase()
//         : '?';
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: player.isCaptain
//               ? Colors.amber.withOpacity(0.5)
//               : color.withOpacity(0.2),
//           width: player.isCaptain ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Avatar with First Letter
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.4),
//                   color.withOpacity(0.2),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: color,
//                 width: 2,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 firstLetter,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           // Player Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         player.playerName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (player.isCaptain)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.amber.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.amber,
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Captain',
//                               style: TextStyle(
//                                 color: Colors.amber,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         _getPositionFullName(player.position),
//                         style: TextStyle(
//                           color: color,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Jersey Number
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.3),
//                   color.withOpacity(0.1),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: color.withOpacity(0.5),
//                 width: 2,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 '${player.jerseyNumber}',
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getPositionFullName(String position) {
//     switch (position) {
//       case 'গোলরক্ষক':
//         return 'গোলরক্ষক';
//       case 'ডিফেন্ডার':
//         return 'ডিফেন্ডার';
//       case 'মিডফিল্ডার':
//         return 'মিডফিল্ডার';
//       case 'ফরোয়ার্ড':
//         return 'ফরোয়ার্ড';
//       default:
//         return position;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/match_model.dart';

class MatchLineupsTab extends StatelessWidget {
  final MatchModel match;

  const MatchLineupsTab({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (match.lineUpA == null && match.lineUpB == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_outlined,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'লাইনআপ নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Team Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.2),
                  ],
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          match.teamA,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          match.teamB,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Team Lineup Content
          Expanded(
            child: TabBarView(
              children: [
                // Team A Lineup
                _buildSingleTeamLineup(
                  match.teamA,
                  match.lineUpA,
                  Colors.blue,
                ),
                // Team B Lineup
                _buildSingleTeamLineup(
                  match.teamB,
                  match.lineUpB,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTeamLineup(
      String teamName, LineUp? lineUp, Color teamColor) {
    if (lineUp == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_outlined,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'লাইনআপ নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Group players by position (exclude substitutes)
    final gk = lineUp.players
        .where((p) => p.position == 'গোলকিপার' && !p.isSubstitute)
        .toList();
    final def = lineUp.players
        .where((p) => p.position == 'ডিফেন্ডার' && !p.isSubstitute)
        .toList();
    final mid = lineUp.players
        .where((p) => p.position == 'মিডফিল্ডার' && !p.isSubstitute)
        .toList();
    final fwd = lineUp.players
        .where((p) => p.position == 'ফরওয়ার্ড' && !p.isSubstitute)
        .toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Formation Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  teamColor.withOpacity(0.2),
                  teamColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: teamColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      color: teamColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        teamName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: teamColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        color: teamColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Formation: ${lineUp.formation}',
                        style: TextStyle(
                          color: teamColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Starting XI Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: teamColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'স্টার্টিং ইলেভেন',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Positions
          if (gk.isNotEmpty) ...[
            _buildPositionGroupFull('গোলরক্ষক', gk, teamColor),
            const SizedBox(height: 16),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroupFull('ডিফেন্ডার', def, teamColor),
            const SizedBox(height: 16),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroupFull('মিডফিল্ডার', mid, teamColor),
            const SizedBox(height: 16),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroupFull('ফরোয়ার্ড', fwd, teamColor),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'সাবস্টিটিউট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...subs.map((player) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPlayerCardFull(player, teamColor),
            )),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPositionGroupFull(
      String position, List<PlayerLineUp> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            position,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPlayerCardFull(player, color),
        )),
      ],
    );
  }

  // ✅ Updated: Player card with photo support
  Widget _buildPlayerCardFull(PlayerLineUp player, Color color) {
    String firstLetter = player.playerName.isNotEmpty
        ? player.playerName[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : color.withOpacity(0.2),
          width: player.isCaptain ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ Avatar with Photo or First Letter
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: player.profilePhotoUrl != null &&
                  player.profilePhotoUrl!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: player.profilePhotoUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.4),
                        color.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.4),
                        color.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        color: color,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.4),
                      color.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        player.playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (player.isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Captain',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getPositionFullName(player.position),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Jersey Number
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${player.jerseyNumber}',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPositionFullName(String position) {
    switch (position) {
      case 'গোলরক্ষক':
        return 'গোলরক্ষক';
      case 'ডিফেন্ডার':
        return 'ডিফেন্ডার';
      case 'মিডফিল্ডার':
        return 'মিডফিল্ডার';
      case 'ফরোয়ার্ড':
        return 'ফরোয়ার্ড';
      default:
        return position;
    }
  }
}