import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Models
import '../models/team_model.dart';
import '../models/tournament/tournament_match_model.dart';
import '../models/tournament/tournament_model.dart' hide TournamentMatch;

import '../models/match_model.dart';

// Providers
import '../providers/team_provider.dart';

// Widgets
import '../screens/match_details_screen.dart';
import '../widgets/tournament_match_card.dart';

// Screens


// ============================================================================
// TAB 1: TOURNAMENT INFO
// ============================================================================
class TournamentInfoTab extends StatelessWidget {
  final Tournament tournament;

  const TournamentInfoTab({Key? key, required this.tournament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
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

          // Schedule
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

          // Prize Pool
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
                  border:
                  Border.all(color: const Color(0xFFFFD700), width: 2),
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

          // Organizer
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
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

// ============================================================================
// TAB 2: MATCHES
// ============================================================================
class MatchesTab extends StatelessWidget {
  final String tournamentId;
  final TeamProvider teamProvider;

  const MatchesTab({
    Key? key,
    required this.tournamentId,
    required this.teamProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          return _buildErrorState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন ম্যাচ নেই', Icons.sports_soccer);
        }

        // Parse matches
        final matches = snapshot.data!.docs
            .map((doc) {
          try {
            return TournamentMatch.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          } catch (e) {
            debugPrint('❌ Error parsing match: $e');
            return null;
          }
        })
            .whereType<TournamentMatch>()
            .toList();

        if (matches.isEmpty) {
          return _buildEmptyState('কোন ম্যাচ নেই', Icons.sports_soccer);
        }

        // Sort by date
        matches.sort((a, b) => a.matchDate.compareTo(b.matchDate));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            final matchModel = _convertToMatchModel(match, teamProvider);

            return GestureDetector(
              onTap: matchModel != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailsScreen(
                      match: matchModel,
                      teamProvider: teamProvider,
                    ),
                  ),
                );
              }
                  : null,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TournamentMatchCard(
                  match: match,
                  teamProvider: teamProvider,
                ),
              ),
            );
          },
        );
      },
    );
  }

  MatchModel? _convertToMatchModel(
      TournamentMatch match,
      TeamProvider teamProvider,
      ) {
    try {
      final homeTeam = teamProvider.getTeamById(match.homeTeamId);
      final awayTeam = teamProvider.getTeamById(match.awayTeamId);

      if (homeTeam == null || awayTeam == null) return null;

      return MatchModel(
        id: match.id,
        teamA: homeTeam.name,
        teamB: awayTeam.name,
        scoreA: match.homeScore,
        scoreB: match.awayScore,
        time: match.matchDate,
        date: match.matchDate,
        status: match.status,
        tournament: tournamentId,
        venue: match.venue,
      );
    } catch (e) {
      debugPrint('❌ Error converting match: $e');
      return null;
    }
  }

  Widget _buildEmptyState(String message, IconData icon) {
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
            ),
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
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 3: POINTS TABLE
// ============================================================================
class PointsTableTab extends StatelessWidget {
  final String tournamentId;

  const PointsTableTab({Key? key, required this.tournamentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF28A745)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        // Parse and sort teams
        final teams = snapshot.data!.docs
            .map((doc) => TournamentTeamStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        // Sort by points, then goal difference
        teams.sort((a, b) {
          final pointsCompare = b.points.compareTo(a.points);
          if (pointsCompare != 0) return pointsCompare;
          return b.goalDifference.compareTo(a.goalDifference);
        });

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFF16213E),
                ),
                dataRowColor: MaterialStateProperty.resolveWith(
                      (states) => const Color(0xFF1A1A2E),
                ),
                border: TableBorder.all(
                  color: Colors.white12,
                  width: 1,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      '#',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'টিম',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ম্যাচ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'জয়',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ড্র',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'হার',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'GD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'পয়েন্ট',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(
                  teams.length,
                      (index) {
                    final team = teams[index];
                    final position = index + 1;

                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPositionColor(position),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$position',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            team.teamName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${team.matchesPlayed}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${team.wins}',
                            style: const TextStyle(color: Colors.greenAccent),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${team.draws}',
                            style:
                            const TextStyle(color: Colors.orangeAccent),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${team.losses}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${team.goalDifference}',
                            style: TextStyle(
                              color: team.goalDifference >= 0
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF28A745),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${team.points}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPositionColor(int position) {
    if (position == 1) return const Color(0xFFFFD700); // Gold
    if (position == 2) return const Color(0xFFC0C0C0); // Silver
    if (position == 3) return const Color(0xFFCD7F32); // Bronze
    return const Color(0xFF16213E);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.table_chart, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'পয়েন্ট টেবিল নেই',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Note: PlayerStatsTab and TeamStatsTab are in separate files due to length
// Import them from:
// - tournament_player_stats_tab.dart
// 🏆 PROFESSIONAL PLAYER STATS TAB
class PlayerStatsTab extends StatelessWidget {
  final String tournamentId;

  const PlayerStatsTab({required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF16213E),
            child: const TabBar(
              indicatorColor: Color(0xFF28A745),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: '⚽ গোল'),
                Tab(text: '🎯 অ্যাসিস্ট'),
                Tab(text: '🟨 হলুদ কার্ড'),
                Tab(text: '🟥 লাল কার্ড'),
                Tab(text: '🏆 সেরা খেলোয়াড়'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTopScorers(),
                _buildTopAssisters(),
                _buildYellowCards(),
                _buildRedCards(),
                _buildBestPlayers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ⚽ Top Scorers
  Widget _buildTopScorers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন গোলদাতা নেই', Icons.sports_soccer);
        }

        final players = snapshot.data!.docs
            .map((doc) => TournamentPlayerStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .where((player) => player.goals > 0)
            .toList();

        players.sort((a, b) => b.goals.compareTo(a.goals));
        final topPlayers = players.take(20).toList();

        if (topPlayers.isEmpty) {
          return _buildEmptyState('কোন গোলদাতা নেই', Icons.sports_soccer);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            return _buildPlayerCard(
              rank: index + 1,
              player: player,
              primaryStat: player.goals,
              primaryStatLabel: 'গোল',
              primaryStatIcon: Icons.sports_soccer,
              secondaryStat: player.assists,
              secondaryStatLabel: 'অ্যাসিস্ট',
              color: const Color(0xFF4CAF50),
            );
          },
        );
      },
    );
  }

  // 🎯 Top Assisters
  Widget _buildTopAssisters() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন অ্যাসিস্ট নেই', Icons.sports_handball);
        }

        final players = snapshot.data!.docs
            .map((doc) => TournamentPlayerStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .where((player) => player.assists > 0)
            .toList();

        players.sort((a, b) => b.assists.compareTo(a.assists));
        final topPlayers = players.take(20).toList();

        if (topPlayers.isEmpty) {
          return _buildEmptyState('কোন অ্যাসিস্ট নেই', Icons.sports_handball);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            return _buildPlayerCard(
              rank: index + 1,
              player: player,
              primaryStat: player.assists,
              primaryStatLabel: 'অ্যাসিস্ট',
              primaryStatIcon: Icons.sports_handball,
              secondaryStat: player.goals,
              secondaryStatLabel: 'গোল',
              color: const Color(0xFF2196F3),
            );
          },
        );
      },
    );
  }

  // 🟨 Yellow Cards
  Widget _buildYellowCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন হলুদ কার্ড নেই', Icons.credit_card);
        }

        final players = snapshot.data!.docs
            .map((doc) => TournamentPlayerStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .where((player) => player.yellowCards > 0)
            .toList();

        players.sort((a, b) => b.yellowCards.compareTo(a.yellowCards));
        final topPlayers = players.take(20).toList();

        if (topPlayers.isEmpty) {
          return _buildEmptyState('কোন হলুদ কার্ড নেই', Icons.credit_card);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            return _buildPlayerCard(
              rank: index + 1,
              player: player,
              primaryStat: player.yellowCards,
              primaryStatLabel: 'হলুদ কার্ড',
              primaryStatIcon: Icons.credit_card,
              secondaryStat: player.redCards,
              secondaryStatLabel: 'লাল কার্ড',
              color: const Color(0xFFFFC107),
            );
          },
        );
      },
    );
  }

  // 🟥 Red Cards
  Widget _buildRedCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন লাল কার্ড নেই', Icons.credit_card);
        }

        final players = snapshot.data!.docs
            .map((doc) => TournamentPlayerStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .where((player) => player.redCards > 0)
            .toList();

        players.sort((a, b) => b.redCards.compareTo(a.redCards));
        final topPlayers = players.take(20).toList();

        if (topPlayers.isEmpty) {
          return _buildEmptyState('কোন লাল কার্ড নেই', Icons.credit_card);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            return _buildPlayerCard(
              rank: index + 1,
              player: player,
              primaryStat: player.redCards,
              primaryStatLabel: 'লাল কার্ড',
              primaryStatIcon: Icons.credit_card,
              secondaryStat: player.yellowCards,
              secondaryStatLabel: 'হলুদ কার্ড',
              color: const Color(0xFFF44336),
            );
          },
        );
      },
    );
  }

  // 🏆 Best Overall Players
  Widget _buildBestPlayers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_player_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন খেলোয়াড় নেই', Icons.emoji_events);
        }

        final players = snapshot.data!.docs
            .map((doc) => TournamentPlayerStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        // Calculate performance score: Goals * 3 + Assists * 2 - Yellow Cards * 0.5 - Red Cards * 2
        players.sort((a, b) {
          final scoreA = (a.goals * 3) +
              (a.assists * 2) -
              (a.yellowCards * 0.5) -
              (a.redCards * 2);
          final scoreB = (b.goals * 3) +
              (b.assists * 2) -
              (b.yellowCards * 0.5) -
              (b.redCards * 2);
          return scoreB.compareTo(scoreA);
        });

        final topPlayers = players.take(20).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            return _buildDetailedPlayerCard(
              rank: index + 1,
              player: player,
            );
          },
        );
      },
    );
  }

  // 🎨 Professional Player Card
  Widget _buildPlayerCard({
    required int rank,
    required TournamentPlayerStats player,
    required int primaryStat,
    required String primaryStatLabel,
    required IconData primaryStatIcon,
    required int secondaryStat,
    required String secondaryStatLabel,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rank <= 3 ? color.withOpacity(0.6) : Colors.white12,
          width: rank <= 3 ? 2.5 : 1,
        ),
        boxShadow: [
          if (rank <= 3)
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Stack(
        children: [
          // Rank badge (top-left corner)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: rank <= 3 ? color : const Color(0xFF0F3460),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: rank == 1 ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Player Photo
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: rank <= 3 ? color : Colors.white24,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: player.playerPhoto.isNotEmpty
                        ? Image.network(
                      player.playerPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(player.playerName);
                      },
                    )
                        : _buildDefaultAvatar(player.playerName),
                  ),
                ),

                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.playerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.shield,
                            color: color.withOpacity(0.7),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              player.teamName,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatBadge(
                            icon: Icons.stadium,
                            value: player.matchesPlayed,
                            label: 'ম্যাচ',
                            color: Colors.white38,
                          ),
                          const SizedBox(width: 8),
                          if (secondaryStat > 0)
                            _buildStatBadge(
                              icon: primaryStatIcon == Icons.sports_soccer
                                  ? Icons.sports_handball
                                  : Icons.sports_soccer,
                              value: secondaryStat,
                              label: secondaryStatLabel,
                              color: Colors.white38,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Primary Stat
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(primaryStatIcon, color: color, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        '$primaryStat',
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🏆 Detailed Player Card (for Best Players tab)
  Widget _buildDetailedPlayerCard({
    required int rank,
    required TournamentPlayerStats player,
  }) {
    final performanceScore = (player.goals * 3) +
        (player.assists * 2) -
        (player.yellowCards * 0.5) -
        (player.redCards * 2);

    Color rankColor = const Color(0xFF0F3460);
    if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
    if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
    if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
          width: rank <= 3 ? 3 : 1,
        ),
        boxShadow: [
          if (rank <= 3)
            BoxShadow(
              color: rankColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          // Header with rank and photo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Rank Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: rankColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Player Photo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: rankColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: player.playerPhoto.isNotEmpty
                        ? Image.network(
                      player.playerPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(player.playerName);
                      },
                    )
                        : _buildDefaultAvatar(player.playerName),
                  ),
                ),

                const SizedBox(width: 16),

                // Player Name and Team
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.playerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.shield,
                            color: Colors.white54,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              player.teamName,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
                        child: Text(
                          'স্কোর: ${performanceScore.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Color(0xFF28A745),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailStatItem(
                    icon: Icons.sports_soccer,
                    value: player.goals,
                    label: 'গোল',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                Expanded(
                  child: _buildDetailStatItem(
                    icon: Icons.sports_handball,
                    value: player.assists,
                    label: 'অ্যাসিস্ট',
                    color: const Color(0xFF2196F3),
                  ),
                ),
                Expanded(
                  child: _buildDetailStatItem(
                    icon: Icons.stadium,
                    value: player.matchesPlayed,
                    label: 'ম্যাচ',
                    color: const Color(0xFF9C27B0),
                  ),
                ),
                Expanded(
                  child: _buildDetailStatItem(
                    icon: Icons.credit_card,
                    value: player.yellowCards + player.redCards,
                    label: 'কার্ড',
                    color: const Color(0xFFFFC107),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStatItem({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Container(
      color: const Color(0xFF28A745),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF28A745)),
          SizedBox(height: 16),
          Text(
            'লোড হচ্ছে...',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
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
            ),
          ),
        ],
      ),
    );
  }
}
// - tournament_team_stats_tab.dart

// 🏆 PROFESSIONAL TEAM STATS TAB
class TeamStatsTab extends StatelessWidget {
  final String tournamentId;

  const TeamStatsTab({required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF16213E),
            child: const TabBar(
              indicatorColor: Color(0xFF28A745),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: '⚽ আক্রমণ'),
                Tab(text: '🛡️ রক্ষণ'),
                Tab(text: '📊 সামগ্রিক'),
                Tab(text: '🏆 গ্রুপ'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAttackStats(),
                _buildDefenseStats(),
                _buildOverallStats(),
                _buildGroupStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ⚽ Attack Stats
  Widget _buildAttackStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন তথ্য নেই');
        }

        final teams = snapshot.data!.docs
            .map((doc) => TournamentTeamStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        teams.sort((a, b) => b.goalsFor.compareTo(a.goalsFor));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamStatCard(
              rank: index + 1,
              team: team,
              primaryStat: team.goalsFor,
              primaryStatLabel: 'গোল করেছে',
              primaryStatIcon: Icons.sports_soccer,
              secondaryStat: (team.matchesPlayed > 0)
                  ? (team.goalsFor / team.matchesPlayed).toStringAsFixed(1)
                  : '0.0',
              secondaryStatLabel: 'প্রতি ম্যাচে গড়',
              color: const Color(0xFF4CAF50),
            );
          },
        );
      },
    );
  }

  // 🛡️ Defense Stats
  Widget _buildDefenseStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন তথ্য নেই');
        }

        final teams = snapshot.data!.docs
            .map((doc) => TournamentTeamStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        // Sort by goals against (ascending - best defense first)
        teams.sort((a, b) => a.goalsAgainst.compareTo(b.goalsAgainst));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamStatCard(
              rank: index + 1,
              team: team,
              primaryStat: team.goalsAgainst,
              primaryStatLabel: 'গোল খেয়েছে',
              primaryStatIcon: Icons.shield,
              secondaryStat: (team.matchesPlayed > 0)
                  ? (team.goalsAgainst / team.matchesPlayed).toStringAsFixed(1)
                  : '0.0',
              secondaryStatLabel: 'প্রতি ম্যাচে গড়',
              color: const Color(0xFF2196F3),
            );
          },
        );
      },
    );
  }

  // 📊 Overall Stats
  Widget _buildOverallStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন তথ্য নেই');
        }

        final teams = snapshot.data!.docs
            .map((doc) => TournamentTeamStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        // Sort by points, then goal difference
        teams.sort((a, b) {
          final pointsCompare = b.points.compareTo(a.points);
          if (pointsCompare != 0) return pointsCompare;
          return b.goalDifference.compareTo(a.goalDifference);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildDetailedTeamCard(
              rank: index + 1,
              team: team,
            );
          },
        );
      },
    );
  }

  // 🏆 Group Stats
  Widget _buildGroupStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_team_stats')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('কোন তথ্য নেই');
        }

        final teams = snapshot.data!.docs
            .map((doc) => TournamentTeamStats.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ))
            .toList();

        // Group teams by group
        final groupedTeams = <String, List<TournamentTeamStats>>{};
        for (var team in teams) {
          if (team.group.isNotEmpty) {
            groupedTeams.putIfAbsent(team.group, () => []).add(team);
          }
        }

        // Sort teams within each group
        groupedTeams.forEach((group, teams) {
          teams.sort((a, b) {
            final pointsCompare = b.points.compareTo(a.points);
            if (pointsCompare != 0) return pointsCompare;
            return b.goalDifference.compareTo(a.goalDifference);
          });
        });

        final sortedGroups = groupedTeams.keys.toList()..sort();

        if (sortedGroups.isEmpty) {
          return _buildEmptyState('কোন গ্রুপ নেই');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedGroups.length,
          itemBuilder: (context, groupIndex) {
            final groupName = sortedGroups[groupIndex];
            final groupTeams = groupedTeams[groupName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF28A745),
                        const Color(0xFF20883A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF28A745).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        groupName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${groupTeams.length} টিম',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Teams in this group
                ...groupTeams.asMap().entries.map((entry) {
                  final index = entry.key;
                  final team = entry.value;
                  return _buildGroupTeamCard(
                    position: index + 1,
                    team: team,
                  );
                }),

                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  // 🎨 Team Stat Card
  Widget _buildTeamStatCard({
    required int rank,
    required TournamentTeamStats team,
    required int primaryStat,
    required String primaryStatLabel,
    required IconData primaryStatIcon,
    required String secondaryStat,
    required String secondaryStatLabel,
    required Color color,
  }) {
    Color rankColor = const Color(0xFF0F3460);
    if (rank == 1) rankColor = const Color(0xFFFFD700);
    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
    if (rank == 3) rankColor = const Color(0xFFCD7F32);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
          width: rank <= 3 ? 2.5 : 1,
        ),
        boxShadow: [
          if (rank <= 3)
            BoxShadow(
              color: rankColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Stack(
        children: [
          // Rank badge
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: rankColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Team Logo
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: rank <= 3 ? rankColor : Colors.white24,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: team.teamLogo.isNotEmpty
                        ? Image.network(
                      team.teamLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultLogo(team.teamName);
                      },
                    )
                        : _buildDefaultLogo(team.teamName),
                  ),
                ),

                // Team Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSmallStatBadge(
                            icon: Icons.stadium,
                            value: '${team.matchesPlayed}',
                            label: 'ম্যাচ',
                          ),
                          const SizedBox(width: 8),
                          _buildSmallStatBadge(
                            icon: Icons.analytics,
                            value: secondaryStat,
                            label: 'গড়',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Primary Stat
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(primaryStatIcon, color: color, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        '$primaryStat',
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📊 Detailed Team Card (for Overall Stats)
  Widget _buildDetailedTeamCard({
    required int rank,
    required TournamentTeamStats team,
  }) {
    Color rankColor = const Color(0xFF0F3460);
    if (rank == 1) rankColor = const Color(0xFFFFD700);
    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
    if (rank == 3) rankColor = const Color(0xFFCD7F32);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.6) : Colors.white12,
          width: rank <= 3 ? 3 : 1,
        ),
        boxShadow: [
          if (rank <= 3)
            BoxShadow(
              color: rankColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Rank
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: rankColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Team Logo
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: rankColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: team.teamLogo.isNotEmpty
                        ? Image.network(
                      team.teamLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultLogo(team.teamName);
                      },
                    )
                        : _buildDefaultLogo(team.teamName),
                  ),
                ),

                const SizedBox(width: 16),

                // Team Name and Points
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF28A745),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${team.points} পয়েন্ট',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (team.group.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white30,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                team.group,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.stadium,
                        value: team.matchesPlayed,
                        label: 'ম্যাচ',
                        color: const Color(0xFF9C27B0),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.check_circle,
                        value: team.wins,
                        label: 'জয়',
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.remove_circle,
                        value: team.draws,
                        label: 'ড্র',
                        color: const Color(0xFFFFC107),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.cancel,
                        value: team.losses,
                        label: 'হার',
                        color: const Color(0xFFF44336),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.sports_soccer,
                        value: team.goalsFor,
                        label: 'গোল',
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.shield,
                        value: team.goalsAgainst,
                        label: 'খেয়েছে',
                        color: const Color(0xFFF44336),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.compare_arrows,
                        value: team.goalDifference,
                        label: 'GD',
                        color: team.goalDifference >= 0
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailStatItem(
                        icon: Icons.percent,
                        value: team.matchesPlayed > 0
                            ? ((team.wins / team.matchesPlayed) * 100).round()
                            : 0,
                        label: 'জয়%',
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🏆 Group Team Card
  Widget _buildGroupTeamCard({
    required int position,
    required TournamentTeamStats team,
  }) {
    Color positionColor = const Color(0xFF0F3460);
    if (position == 1) positionColor = const Color(0xFFFFD700);
    if (position == 2) positionColor = const Color(0xFFC0C0C0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: position <= 2 ? positionColor.withOpacity(0.5) : Colors.white12,
          width: position <= 2 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Position
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: positionColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$position',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Team Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: positionColor, width: 2),
            ),
            child: ClipOval(
              child: team.teamLogo.isNotEmpty
                  ? Image.network(
                team.teamLogo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultLogo(team.teamName);
                },
              )
                  : _buildDefaultLogo(team.teamName),
            ),
          ),

          const SizedBox(width: 12),

          // Team Name
          Expanded(
            child: Text(
              team.teamName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Stats
          Row(
            children: [
              _buildMiniStat('${team.matchesPlayed}', 'M'),
              const SizedBox(width: 8),
              _buildMiniStat('${team.wins}', 'W'),
              const SizedBox(width: 8),
              _buildMiniStat('${team.goalDifference}', 'GD'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF28A745),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${team.points}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatBadge({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 12),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStatItem({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultLogo(String teamName) {
    return Container(
      color: const Color(0xFF28A745),
      child: Center(
        child: Text(
          teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF28A745)),
          SizedBox(height: 16),
          Text(
            'লোড হচ্ছে...',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 80, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 6: TEAMS
// ============================================================================
class TeamsTab extends StatelessWidget {
  final String tournamentId;
  final TeamProvider teamProvider;

  const TeamsTab({
    Key? key,
    required this.tournamentId,
    required this.teamProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_teams')
          .where('tournamentId', isEqualTo: tournamentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF28A745)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final teamIds = snapshot.data!.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['teamId'])
            .whereType<String>()
            .toList();

        final teams = teamIds
            .map((id) => teamProvider.getTeamById(id))
            .whereType<TeamModel>()
            .toList();

        if (teams.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamCard(team);
          },
        );
      },
    );
  }

  Widget _buildTeamCard(TeamModel team) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Team Logo
          if (team.logoUrl.isNotEmpty)
            ClipOval(
              child: Image.network(
                team.logoUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultLogo();
                },
              ),
            )
          else
            _buildDefaultLogo(),

          const SizedBox(height: 12),

          // Team Name
          Text(
            team.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Team Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people,
                color: Color(0xFF28A745),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${team.playersCount} খেলোয়াড়',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF28A745).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shield,
        color: Color(0xFF28A745),
        size: 30,
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
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}