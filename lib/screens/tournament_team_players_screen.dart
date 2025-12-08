// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // Models
// import '../models/team_model.dart';
// import '../models/player_model.dart';
//
// /// User screen to view tournament team players (read-only)
// class TournamentTeamPlayersScreen extends StatelessWidget {
//   final String tournamentId;
//   final String tournamentName;
//   final TeamModel team;
//
//   const TournamentTeamPlayersScreen({
//     Key? key,
//     required this.tournamentId,
//     required this.tournamentName,
//     required this.team,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16213E),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               team.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               tournamentName,
//               style: const TextStyle(fontSize: 12, color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('tournament_team_players')
//             .doc('${tournamentId}_${team.id}')
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF28A745)),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return _buildErrorState(snapshot.error.toString());
//           }
//
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return _buildEmptyState();
//           }
//
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           final playerIds = List<String>.from(data['playerIds'] ?? []);
//
//           if (playerIds.isEmpty) {
//             return _buildEmptyState();
//           }
//
//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('players')
//                 .where('playerId', whereIn: playerIds)
//                 .snapshots(),
//             builder: (context, playerSnapshot) {
//               if (playerSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF28A745)),
//                 );
//               }
//
//               if (playerSnapshot.hasError) {
//                 return _buildErrorState(playerSnapshot.error.toString());
//               }
//
//               if (!playerSnapshot.hasData ||
//                   playerSnapshot.data!.docs.isEmpty) {
//                 return _buildEmptyState();
//               }
//
//               final players = playerSnapshot.data!.docs
//                   .map((doc) {
//                 try {
//                   return PlayerModel.fromFirestore(doc);
//                 } catch (e) {
//                   debugPrint('Error parsing player: $e');
//                   return null;
//                 }
//               })
//                   .whereType<PlayerModel>()
//                   .toList();
//
//               // Sort by jersey number, then name
//               players.sort((a, b) {
//                 if (a.jerseyNumber != null && b.jerseyNumber != null) {
//                   return a.jerseyNumber!.compareTo(b.jerseyNumber!);
//                 }
//                 return a.name.compareTo(b.name);
//               });
//
//               return Column(
//                 children: [
//                   // Info Header
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF28A745).withOpacity(0.8),
//                           const Color(0xFF20C997).withOpacity(0.8),
//                         ],
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         // Team Logo
//                         if (team.logoUrl.isNotEmpty)
//                           Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: ClipOval(
//                               child: Image.network(
//                                 team.logoUrl,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return _buildTeamPlaceholder();
//                                 },
//                               ),
//                             ),
//                           )
//                         else
//                           _buildTeamPlaceholder(),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'টুর্নামেন্ট স্কোয়াড',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${players.length}টি খেলোয়াড়',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Players List
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: players.length,
//                       itemBuilder: (context, index) {
//                         return _buildPlayerCard(players[index], index);
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTeamPlaceholder() {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         color: const Color(0xFF28A745),
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           team.name.isNotEmpty ? team.name[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlayerCard(PlayerModel player, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF28A745).withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // Index Number
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF28A745).withOpacity(0.3),
//                     const Color(0xFF20C997).withOpacity(0.3),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(
//                   '${index + 1}',
//                   style: const TextStyle(
//                     color: Color(0xFF28A745),
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Player Photo
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: const Color(0xFF28A745),
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF28A745).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: player.photoUrl != null && player.photoUrl!.isNotEmpty
//                     ? Image.network(
//                   player.photoUrl!,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return _buildPlayerPlaceholder(player.name);
//                   },
//                 )
//                     : _buildPlayerPlaceholder(player.name),
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Player Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     player.name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       // Jersey Number
//                       if (player.jerseyNumber != null)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF28A745).withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                               color: const Color(0xFF28A745),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             '#${player.jerseyNumber}',
//                             style: const TextStyle(
//                               color: Color(0xFF28A745),
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       if (player.jerseyNumber != null &&
//                           player.position != null &&
//                           player.position!.isNotEmpty)
//                         const SizedBox(width: 8),
//                       // Position
//                       if (player.position != null &&
//                           player.position!.isNotEmpty)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             player.position!,
//                             style: const TextStyle(
//                               color: Colors.blue,
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlayerPlaceholder(String playerName) {
//     return Container(
//       color: const Color(0xFF28A745).withOpacity(0.3),
//       child: Center(
//         child: Text(
//           playerName.isNotEmpty ? playerName[0].toUpperCase() : '?',
//           style: const TextStyle(
//             color: Color(0xFF28A745),
//             fontSize: 28,
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
//           Icon(
//             Icons.people_outline,
//             size: 80,
//             color: Colors.white24,
//           ),
//           SizedBox(height: 16),
//           Text(
//             'কোন খেলোয়াড় নির্বাচিত নেই',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'এই টিমের জন্য এখনো খেলোয়াড় নির্বাচন করা হয়নি',
//             style: TextStyle(
//               color: Colors.white38,
//               fontSize: 12,
//             ),
//             textAlign: TextAlign.center,
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
//           const Icon(
//             Icons.error_outline,
//             size: 80,
//             color: Colors.red,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Error',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               error,
//               style: const TextStyle(
//                 color: Colors.white38,
//                 fontSize: 12,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../models/team_model.dart';
import '../models/player_model.dart';

/// User app screen to VIEW selected players for a team in a tournament (Read-only)
class TournamentTeamPlayersScreen extends StatefulWidget {
  final String tournamentId;
  final String tournamentName;
  final TeamModel team;

  const TournamentTeamPlayersScreen({
    Key? key,
    required this.tournamentId,
    required this.tournamentName,
    required this.team,
  }) : super(key: key);

  @override
  State<TournamentTeamPlayersScreen> createState() =>
      _TournamentTeamPlayersScreenState();
}

class _TournamentTeamPlayersScreenState
    extends State<TournamentTeamPlayersScreen> {
  Set<String> _selectedPlayerIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedPlayers();
  }

  Future<void> _loadSelectedPlayers() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tournament_team_players')
          .doc('${widget.tournamentId}_${widget.team.id}')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final playerIds = List<String>.from(data['playerIds'] ?? []);

        setState(() {
          _selectedPlayerIds = playerIds.toSet();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading selected players: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1C2128),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.team.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.cyan, width: 1),
                ),
                child: Text(
                  widget.tournamentName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.cyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (_selectedPlayerIds.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan.shade600, Colors.cyan.shade800],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.shade700.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${_selectedPlayerIds.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.cyan.shade700,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'খেলোয়াড় তালিকা লোড হচ্ছে...',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .where('teamId', isEqualTo: widget.team.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final players = snapshot.data!.docs
            .map((doc) {
          try {
            return PlayerModel.fromFirestore(doc);
          } catch (e) {
            debugPrint('Error parsing player: $e');
            return null;
          }
        })
            .whereType<PlayerModel>()
            .toList();

        // Sort: Selected first, then by name
        players.sort((a, b) {
          final aSelected = _selectedPlayerIds.contains(a.playerId);
          final bSelected = _selectedPlayerIds.contains(b.playerId);

          if (aSelected && !bSelected) return -1;
          if (!aSelected && bSelected) return 1;
          return a.name.compareTo(b.name);
        });

        // Filter: Only show selected players
        final selectedPlayers = players
            .where((p) => _selectedPlayerIds.contains(p.playerId))
            .toList();

        if (selectedPlayers.isEmpty) {
          return _buildNoSelectionState();
        }

        return Column(
          children: [
            _buildStatsHeader(selectedPlayers.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: selectedPlayers.length,
                itemBuilder: (context, index) {
                  final player = selectedPlayers[index];
                  return _buildPlayerCard(player, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsHeader(int count) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.shade800,
            Colors.cyan.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.shade900.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'টুর্নামেন্ট স্কোয়াড',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count জন খেলোয়াড় নির্বাচিত',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(PlayerModel player, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.cyan.shade600,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.shade600.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Position Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan.shade600, Colors.cyan.shade800],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Player Photo
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyan.shade600,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.cyan.shade700.withOpacity(0.15),
                    backgroundImage: player.profilePhotoUrl != null &&
                        player.profilePhotoUrl!.isNotEmpty
                        ? NetworkImage(player.profilePhotoUrl!)
                        : null,
                    child: player.profilePhotoUrl == null ||
                        player.profilePhotoUrl!.isEmpty
                        ? Text(
                      player.name.isNotEmpty
                          ? player.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors.cyan.shade600,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan.shade600, Colors.cyan.shade800],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1C2128),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (player.jerseyNumber != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tag,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${player.jerseyNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (player.jerseyNumber != null &&
                          player.position != null &&
                          player.position!.isNotEmpty)
                        const SizedBox(width: 8),
                      if (player.position != null && player.position!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.cyan.shade800.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.cyan.shade700.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            player.position!,
                            style: TextStyle(
                              color: Colors.cyan.shade300,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'এই টিমে কোন খেলোয়াড় নেই',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSelectionState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 80,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'টুর্নামেন্ট স্কোয়াড নির্বাচন করা হয়নি',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'অ্যাডমিন এখনো এই টিমের জন্য খেলোয়াড় নির্বাচন করেনি',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.red.shade300, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}