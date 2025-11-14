

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../models/tournament.dart';
// import '../models/tournament_model.dart';
// import '../models/tournament_match_model.dart';
// import '../models/tournament_player_stats_model.dart';
// import '../models/tournament_team_stats_model.dart';
// import '../models/tournament_team_model.dart';
// import '../providers/team_provider.dart';
// import '../widgets/tournament_match_card.dart';
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
//   late TeamProvider _teamProvider;  // ✅ Added
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _teamProvider = TeamProvider();  // ✅ Initialize
//     _loadData();  // ✅ Load both tournament and teams
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // ✅ Combined load method
//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
//
//     try {
//       debugPrint('🔍 Loading tournament with ID: ${widget.tournamentId}');
//
//       // ✅ Load teams FIRST
//       await _teamProvider.fetchTeams();
//       debugPrint('✅ Teams loaded: ${_teamProvider.teams.length}');
//       for (var team in _teamProvider.teams) {
//         debugPrint('   📋 Team: ${team.id} - ${team.name}');
//       }
//
//       // Load tournament
//       final doc = await FirebaseFirestore.instance
//           .collection('tournaments')
//           .doc(widget.tournamentId)
//           .get();
//
//       if (doc.exists && mounted) {
//         debugPrint('✅ Tournament found: ${doc.data()?['name']}');
//         setState(() {
//           _tournament = Tournament.fromMap(
//             doc.data() as Map<String, dynamic>,
//             doc.id,
//           );
//           _isLoading = false;
//         });
//       } else {
//         debugPrint('❌ Tournament not found');
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
//                   tabs: const [
//                     Tab(text: '📋 Info'),
//                     Tab(text: '⚽ Matches'),
//                     Tab(text: '🏅 Player Stats'),
//                     Tab(text: '📊 Team Stats'),
//                     Tab(text: '👥 Teams'),
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
//               teamProvider: _teamProvider,  // ✅ Pass TeamProvider
//             ),
//             _PlayerStatsTab(tournamentId: widget.tournamentId),
//             _TeamStatsTab(tournamentId: widget.tournamentId),
//             _TeamsTab(tournamentId: widget.tournamentId),
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
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(tournament.status),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   tournament.statusInBengali,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // Tournament Name
//               Text(
//                 tournament.name,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
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
// // SliverAppBar Delegate for TabBar
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
//           const SizedBox(height: 16),
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
//           const SizedBox(height: 16),
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
//           const SizedBox(height: 16),
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
// // Tab 2: Matches (✅ WITH TeamProvider passed correctly)
// class _MatchesTab extends StatelessWidget {
//   final String tournamentId;
//   final TeamProvider teamProvider;  // ✅ Added
//
//   const _MatchesTab({
//     required this.tournamentId,
//     required this.teamProvider,  // ✅ Required
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('🔍 Matches Tab - Tournament ID: $tournamentId');
//     debugPrint('👥 Matches Tab - Teams available: ${teamProvider.teams.length}');
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_matches')
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
//           debugPrint('❌ Error loading matches: ${snapshot.error}');
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
//               ],
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           debugPrint('📊 No matches found for tournament: $tournamentId');
//           return _buildEmptyState(
//             'এই টুর্নামেন্টের কোন ম্যাচ নেই',
//             Icons.sports_soccer,
//             'Firebase Console এ tournament_matches collection-এ ম্যাচ যোগ করুন',
//           );
//         }
//
//         final docs = snapshot.data!.docs;
//         debugPrint('✅ Found ${docs.length} matches for tournament');
//
//         // Parse matches
//         final matches = docs.map((doc) {
//           try {
//             final match = TournamentMatch.fromMap(
//               doc.data() as Map<String, dynamic>,
//               doc.id,
//             );
//             debugPrint('📄 Match: ${match.homeTeamId} vs ${match.awayTeamId}');
//             return match;
//           } catch (e) {
//             debugPrint('❌ Error parsing match ${doc.id}: $e');
//             return null;
//           }
//         }).whereType<TournamentMatch>().toList();
//
//         if (matches.isEmpty) {
//           return _buildEmptyState(
//             'ম্যাচ parse করতে সমস্যা হয়েছে',
//             Icons.error_outline,
//             'Match data format ঠিক নেই',
//           );
//         }
//
//         // Sort matches by date
//         matches.sort((a, b) => a.matchDate.compareTo(b.matchDate));
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: matches.length,
//           itemBuilder: (context, index) {
//             // ✅ Use TournamentMatchCard with TeamProvider
//             return TournamentMatchCard(
//               match: matches[index],
//               teamProvider: teamProvider,  // ✅ Pass the provider
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState(String message, IconData icon, [String? subtitle]) {
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
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           if (subtitle != null) ...[
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: Colors.white38,
//                   fontSize: 13,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // Tab 3-5: Keep existing Player Stats, Team Stats, Teams tabs...
// // (Keep your existing code for these tabs)
//
// class _PlayerStatsTab extends StatelessWidget {
//   final String tournamentId;
//   const _PlayerStatsTab({required this.tournamentId});
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Player Stats', style: TextStyle(color: Colors.white)));
//   }
// }
//
// class _TeamStatsTab extends StatelessWidget {
//   final String tournamentId;
//   const _TeamStatsTab({required this.tournamentId});
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Team Stats', style: TextStyle(color: Colors.white)));
//   }
// }
//
// class _TeamsTab extends StatelessWidget {
//   final String tournamentId;
//   const _TeamsTab({required this.tournamentId});
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Teams', style: TextStyle(color: Colors.white)));
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/tournament.dart';
import '../models/tournament_model.dart';
import '../models/tournament_match_model.dart';
import '../models/tournament_player_stats_model.dart';
import '../models/tournament_team_stats_model.dart';
import '../models/tournament_team_model.dart';
import '../models/match_model.dart';  // ✅ Added
import '../providers/team_provider.dart';
import '../widgets/tournament_match_card.dart';
import 'match_details_screen.dart';  // ✅ Added

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
  late TeamProvider _teamProvider;  // ✅ Added

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _teamProvider = TeamProvider();  // ✅ Initialize
    _loadData();  // ✅ Load both tournament and teams
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Combined load method
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🔍 Loading tournament with ID: ${widget.tournamentId}');

      // ✅ Load teams FIRST
      await _teamProvider.fetchTeams();
      debugPrint('✅ Teams loaded: ${_teamProvider.teams.length}');
      for (var team in _teamProvider.teams) {
        debugPrint('   📋 Team: ${team.id} - ${team.name}');
      }

      // Load tournament
      final doc = await FirebaseFirestore.instance
          .collection('tournaments')
          .doc(widget.tournamentId)
          .get();

      if (doc.exists && mounted) {
        debugPrint('✅ Tournament found: ${doc.data()?['name']}');
        setState(() {
          _tournament = Tournament.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
          _isLoading = false;
        });
      } else {
        debugPrint('❌ Tournament not found');
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
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF28A745),
          ),
        ),
      );
    }

    if (_tournament == null) {
      return _buildErrorView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: const Color(0xFF16213E),
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderImage(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF28A745),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: '📋 Info'),
                    Tab(text: '⚽ Matches'),
                    Tab(text: '🏅 Player Stats'),
                    Tab(text: '📊 Team Stats'),
                    Tab(text: '👥 Teams'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _TournamentInfoTab(tournament: _tournament!),
            _MatchesTab(
              tournamentId: widget.tournamentId,
              teamProvider: _teamProvider,  // ✅ Pass TeamProvider
            ),
            _PlayerStatsTab(tournamentId: widget.tournamentId),
            _TeamStatsTab(tournamentId: widget.tournamentId),
            _TeamsTab(tournamentId: widget.tournamentId),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final tournament = _tournament!;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
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

        // Content
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
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(tournament.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tournament.statusInBengali,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Tournament Name
              Text(
                tournament.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
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
    );
  }

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

  Widget _buildErrorView() {
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

// SliverAppBar Delegate for TabBar
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

// Tab 1: Tournament Info
class _TournamentInfoTab extends StatelessWidget {
  final Tournament tournament;

  const _TournamentInfoTab({required this.tournament});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: '📋 বিবরণ',
            child: Text(
              tournament.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: '📅 সময়সূচী',
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.play_circle_outline,
                  label: 'শুরু',
                  value: dateFormat.format(tournament.startDate),
                  iconColor: const Color(0xFF4CAF50),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.stop_circle_outlined,
                  label: 'শেষ',
                  value: dateFormat.format(tournament.endDate),
                  iconColor: const Color(0xFFFF5252),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (tournament.prizePool.isNotEmpty)
            _buildSection(
              title: '🏆 পুরস্কার',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.2),
                      const Color(0xFFFFA000).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 40, color: Color(0xFFFFD700)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tournament.prizePool,
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          _buildSection(
            title: '👤 আয়োজক',
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.person,
                  label: 'নাম',
                  value: tournament.organizerName,
                ),
                if (tournament.organizerContact.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: 'যোগাযোগ',
                    value: tournament.organizerContact,
                    iconColor: const Color(0xFF4CAF50),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.white,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Tab 2: Matches (✅ WITH TeamProvider passed correctly)
class _MatchesTab extends StatelessWidget {
  final String tournamentId;
  final TeamProvider teamProvider;  // ✅ Added

  const _MatchesTab({
    required this.tournamentId,
    required this.teamProvider,  // ✅ Required
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 Matches Tab - Tournament ID: $tournamentId');
    debugPrint('👥 Matches Tab - Teams available: ${teamProvider.teams.length}');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF28A745)),
          );
        }

        if (snapshot.hasError) {
          debugPrint('❌ Error loading matches: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          debugPrint('📊 No matches found for tournament: $tournamentId');
          return _buildEmptyState(
            'এই টুর্নামেন্টের কোন ম্যাচ নেই',
            Icons.sports_soccer,
            'Firebase Console এ tournament_matches collection-এ ম্যাচ যোগ করুন',
          );
        }

        final docs = snapshot.data!.docs;
        debugPrint('✅ Found ${docs.length} matches for tournament');

        // Parse matches
        final matches = docs.map((doc) {
          try {
            final match = TournamentMatch.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            debugPrint('📄 Match: ${match.homeTeamId} vs ${match.awayTeamId}');
            return match;
          } catch (e) {
            debugPrint('❌ Error parsing match ${doc.id}: $e');
            return null;
          }
        }).whereType<TournamentMatch>().toList();

        if (matches.isEmpty) {
          return _buildEmptyState(
            'ম্যাচ parse করতে সমস্যা হয়েছে',
            Icons.error_outline,
            'Match data format ঠিক নেই',
          );
        }

        // Sort matches by date
        matches.sort((a, b) => a.matchDate.compareTo(b.matchDate));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];

            // ✅ Convert TournamentMatch to MatchModel
            final matchModel = _convertToMatchModel(match, teamProvider);

            if (matchModel == null) {
              return TournamentMatchCard(
                match: match,
                teamProvider: teamProvider,
              );
            }

            // ✅ Wrap with GestureDetector to navigate to MatchDetailsScreen
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailsScreen(
                      match: matchModel,
                      teamProvider: teamProvider,
                    ),
                  ),
                );
              },
              child: TournamentMatchCard(
                match: match,
                teamProvider: teamProvider,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon, [String? subtitle]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ Convert TournamentMatch to MatchModel for navigation
  MatchModel? _convertToMatchModel(
      TournamentMatch match,
      TeamProvider teamProvider,
      ) {
    try {
      // Get team objects
      final homeTeam = teamProvider.getTeamById(match.homeTeamId);
      final awayTeam = teamProvider.getTeamById(match.awayTeamId);

      if (homeTeam == null || awayTeam == null) {
        debugPrint('❌ Cannot convert: teams not found');
        return null;
      }

      return MatchModel(
        id: match.id,
        teamA: homeTeam.name,
        teamB: awayTeam.name,
        scoreA: match.homeScore,
        scoreB: match.awayScore,
        time: match.matchDate,
        date: match.matchDate,
        status: match.status,
        tournament: match.tournamentId,
        venue: match.venue,
      );
    } catch (e) {
      debugPrint('❌ Error converting tournament match: $e');
      return null;
    }
  }
}

// Tab 3-5: Keep existing Player Stats, Team Stats, Teams tabs...
// (Keep your existing code for these tabs)

class _PlayerStatsTab extends StatelessWidget {
  final String tournamentId;
  const _PlayerStatsTab({required this.tournamentId});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Player Stats', style: TextStyle(color: Colors.white)));
  }
}

class _TeamStatsTab extends StatelessWidget {
  final String tournamentId;
  const _TeamStatsTab({required this.tournamentId});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Team Stats', style: TextStyle(color: Colors.white)));
  }
}

class _TeamsTab extends StatelessWidget {
  final String tournamentId;
  const _TeamsTab({required this.tournamentId});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Teams', style: TextStyle(color: Colors.white)));
  }
}