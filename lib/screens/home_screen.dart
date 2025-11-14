

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';
import '../providers/match_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/match_card.dart';
import '../widgets/date_scroll_bar.dart';
import 'match_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MatchProvider _matchProvider = MatchProvider();
  final TeamProvider _teamProvider = TeamProvider();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint('🔄 Loading data...');

    // ✅ Load teams FIRST before loading matches
    await _teamProvider.fetchTeams();
    debugPrint('✅ Teams loaded: ${_teamProvider.teams.length}');
    for (var team in _teamProvider.teams) {
      debugPrint('   📋 Team: ${team.id} - ${team.name}');
    }

    await _matchProvider.fetchMatches();
    debugPrint('✅ Data loaded');
  }

  // Filter matches by selected date
  List<MatchModel> _filterMatchesByDate(List<MatchModel> matches) {
    if (_selectedDate == null) return matches;

    return matches.where((match) {
      final matchDate = DateFormat('yyyyMMdd').format(match.date);
      final selectedDateStr = DateFormat('yyyyMMdd').format(_selectedDate!);
      return matchDate == selectedDateStr;
    }).toList();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    debugPrint('📅 Selected date: ${DateFormat('dd MMM yyyy').format(date)}');
  }

  // ✅ Convert tournament match to MatchModel with actual team names
  MatchModel? _tournamentMatchToMatchModel(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      // Get team IDs
      final homeTeamId = data['homeTeamId'] ?? '';
      final awayTeamId = data['awayTeamId'] ?? '';

      debugPrint('🏆 Converting tournament match:');
      debugPrint('   Home Team ID: $homeTeamId');
      debugPrint('   Away Team ID: $awayTeamId');

      // ✅ Get actual team objects from provider
      final homeTeam = _teamProvider.getTeamById(homeTeamId);
      final awayTeam = _teamProvider.getTeamById(awayTeamId);

      if (homeTeam == null || awayTeam == null) {
        debugPrint('   ❌ Teams not found: home=$homeTeam, away=$awayTeam');
        return null;
      }

      debugPrint('   ✅ Teams found: ${homeTeam.name} vs ${awayTeam.name}');

      return MatchModel(
        id: doc.id,
        teamA: homeTeam.name,  // ✅ Use actual team name
        teamB: awayTeam.name,  // ✅ Use actual team name
        scoreA: data['homeScore'] ?? 0,
        scoreB: data['awayScore'] ?? 0,
        time: _parseTimestamp(data['matchDate']),
        date: _parseTimestamp(data['matchDate']),
        status: data['status'] ?? 'upcoming',
        tournament: data['tournamentId'] ?? '',
        venue: data['venue'] ?? '',
      );
    } catch (e) {
      debugPrint('❌ Error converting tournament match ${doc.id}: $e');
      return null;
    }
  }

  DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'ফুটবল লাইভ স্কোর',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date Scroll Bar
          Container(
            color: const Color(0xFF16213E),
            child: DateScrollBar(
              onDateSelected: _onDateSelected,
            ),
          ),

          // Matches List
          Expanded(
            child: StreamBuilder<List<MatchModel>>(
              stream: _getCombinedMatchesStream(),
              builder: (context, snapshot) {
                // Debug information
                debugPrint('📊 Connection State: ${snapshot.connectionState}');
                debugPrint('📊 Has Data: ${snapshot.hasData}');
                debugPrint('📊 Data Length: ${snapshot.data?.length ?? 0}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF00D9FF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'ডেটা লোড হচ্ছে...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('আবার চেষ্টা করুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D9FF),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sports_soccer,
                          color: Colors.white30,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'কোন ম্যাচ নেই',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Firebase এ ডেটা যোগ করুন',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh করুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D9FF),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter matches by selected date
                List<MatchModel> allMatches = snapshot.data!;
                List<MatchModel> filteredMatches =
                _filterMatchesByDate(allMatches);

                // Separate by status
                List<MatchModel> liveMatches =
                filteredMatches.where((m) => m.status == 'live').toList();
                List<MatchModel> upcomingMatches = filteredMatches
                    .where((m) => m.status == 'upcoming')
                    .toList();
                List<MatchModel> finishedMatches = filteredMatches
                    .where((m) =>
                m.status == 'finished' || m.status == 'completed')
                    .toList();

                // Show empty state if no matches for selected date
                if (filteredMatches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          color: Colors.white30,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'এই তারিখে কোন ম্যাচ নেই',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('dd MMMM yyyy').format(_selectedDate!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Build matches list grouped by status
                return RefreshIndicator(
                  onRefresh: _loadData,
                  color: const Color(0xFF00D9FF),
                  backgroundColor: const Color(0xFF16213E),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Live Matches Section
                      if (liveMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.play_circle_filled,
                          title: 'লাইভ ম্যাচ',
                          count: liveMatches.length,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        ...liveMatches.map((match) => _buildMatchCard(match)),
                        const SizedBox(height: 24),
                      ],

                      // Upcoming Matches Section
                      if (upcomingMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.schedule,
                          title: 'আসন্ন ম্যাচ',
                          count: upcomingMatches.length,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        ...upcomingMatches
                            .map((match) => _buildMatchCard(match)),
                        const SizedBox(height: 24),
                      ],

                      // Finished Matches Section
                      if (finishedMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.check_circle,
                          title: 'সমাপ্ত ম্যাচ',
                          count: finishedMatches.length,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        ...finishedMatches
                            .map((match) => _buildMatchCard(match)),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Combined Stream: Fetches from both collections with team names
  Stream<List<MatchModel>> _getCombinedMatchesStream() async* {
    await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
      try {
        final List<MatchModel> allMatches = [];

        // 1. Fetch regular matches
        final regularSnapshot =
        await FirebaseFirestore.instance.collection('matches').get();

        for (var doc in regularSnapshot.docs) {
          try {
            allMatches.add(MatchModel.fromFirestore(doc));
          } catch (e) {
            debugPrint('❌ Error parsing regular match: $e');
          }
        }

        // 2. Fetch tournament matches (✅ WITH team name conversion)
        final tournamentSnapshot = await FirebaseFirestore.instance
            .collection('tournament_matches')
            .get();

        for (var doc in tournamentSnapshot.docs) {
          try {
            final match = _tournamentMatchToMatchModel(doc);
            if (match != null) {
              allMatches.add(match);
            }
          } catch (e) {
            debugPrint('❌ Error parsing tournament match: $e');
          }
        }

        debugPrint('📊 Regular Matches: ${regularSnapshot.docs.length}');
        debugPrint('🏆 Tournament Matches: ${tournamentSnapshot.docs.length}');
        debugPrint('🎯 Total Combined: ${allMatches.length}');

        yield allMatches;
      } catch (e) {
        debugPrint('❌ Error in combined stream: $e');
        yield [];
      }
    }
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailsScreen(
              match: match,
              teamProvider: _teamProvider,
            ),
          ),
        );
      },
      child: MatchCard(
        match: match,
        teamProvider: _teamProvider,
      ),
    );
  }
}