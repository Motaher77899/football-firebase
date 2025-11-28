import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';  // ✅ Add this import
import 'package:rxdart/rxdart.dart';

// Models
import '../models/match_model.dart';

// Providers
import '../providers/match_provider.dart';
import '../providers/team_provider.dart';

// Widgets
import '../widgets/match_card.dart';
import '../widgets/date_scroll_bar.dart';

// Screens
import 'match_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // ✅ Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // ✅ Fixed: Load data using provider from context
  Future<void> _loadData() async {
    if (!mounted) return;

    debugPrint('═══════════════════════════════════');
    debugPrint('🔄 Starting data load...');
    debugPrint('═══════════════════════════════════');

    try {
      // ✅ Get TeamProvider from context (same instance from MultiProvider)
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);

      // ✅ Load teams
      await teamProvider.fetchTeams();

      debugPrint('✅ Teams loaded: ${teamProvider.teams.length}');

      if (teamProvider.teams.isEmpty) {
        debugPrint('⚠️ WARNING: No teams loaded!');
      } else {
        debugPrint('📋 Available teams:');
        for (var team in teamProvider.teams) {
          debugPrint('   - ${team.id}: ${team.name}');
        }
      }

      debugPrint('═══════════════════════════════════');
      debugPrint('✅ Data loading complete!');
      debugPrint('═══════════════════════════════════');

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('═══════════════════════════════════');
      debugPrint('❌ Error loading data: $e');
      debugPrint('═══════════════════════════════════');
    }
  }

  // Filter matches by date
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

  // ✅ Fixed: Tournament Match to Match Model Conversion
  MatchModel? _tournamentMatchToMatchModel(
      DocumentSnapshot doc,
      TeamProvider teamProvider,  // ✅ Pass provider as parameter
      ) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      final homeTeamId = data['teamAId'] ?? data['homeTeamId'] ?? '';
      final awayTeamId = data['teamBId'] ?? data['awayTeamId'] ?? '';

      // ✅ Use passed provider
      final homeTeam = teamProvider.getTeamById(homeTeamId);
      final awayTeam = teamProvider.getTeamById(awayTeamId);

      if (homeTeam == null) {
        debugPrint('   ❌ Home team "$homeTeamId" NOT FOUND');
        return null;
      }

      if (awayTeam == null) {
        debugPrint('   ❌ Away team "$awayTeamId" NOT FOUND');
        return null;
      }

      // Parse date
      DateTime matchDate = DateTime.now();
      if (data['matchDate'] != null) {
        matchDate = _parseTimestampFixed(data['matchDate']);
      } else if (data['rankingUpdatedAt'] != null) {
        matchDate = _parseTimestampFixed(data['rankingUpdatedAt']);
      }

      return MatchModel(
        id: doc.id,
        teamA: homeTeam.name,
        teamB: awayTeam.name,
        scoreA: data['scoreA'] ?? 0,
        scoreB: data['scoreB'] ?? 0,
        time: matchDate,
        date: matchDate,
        status: data['status'] ?? 'upcoming',
        tournament: data['tournamentId'] ?? '',
        venue: data['venue'] ?? '',
      );
    } catch (e) {
      debugPrint('❌ Error converting tournament match ${doc.id}: $e');
      return null;
    }
  }

  DateTime _parseTimestampFixed(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) {
      final utcDate = value.toDate();
      return DateTime(
        utcDate.year,
        utcDate.month,
        utcDate.day,
        utcDate.hour,
        utcDate.minute,
        utcDate.second,
      );
    }

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  // ✅ Fixed: Combined Stream with proper provider usage
  Stream<List<MatchModel>> _getCombinedMatchesStream(TeamProvider teamProvider) {
    final regularMatchesStream = FirebaseFirestore.instance
        .collection('matches')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return MatchModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('❌ Error parsing regular match: $e');
          return null;
        }
      }).whereType<MatchModel>().toList();
    });

    final tournamentMatchesStream = FirebaseFirestore.instance
        .collection('tournament_matches')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          // ✅ Pass teamProvider to conversion function
          final match = _tournamentMatchToMatchModel(doc, teamProvider);
          return match;
        } catch (e) {
          debugPrint('❌ Error parsing tournament match: $e');
          return null;
        }
      }).whereType<MatchModel>().toList();
    });

    return CombineLatestStream.combine2(
      regularMatchesStream,
      tournamentMatchesStream,
          (List<MatchModel> regularMatches, List<MatchModel> tournamentMatches) {
        final allMatches = [...regularMatches, ...tournamentMatches];
        return allMatches;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Get TeamProvider from context
    final teamProvider = Provider.of<TeamProvider>(context);

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
            child: !_isInitialized
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00D9FF)),
                  SizedBox(height: 16),
                  Text(
                    'ডেটা লোড হচ্ছে...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
                : StreamBuilder<List<MatchModel>>(
              stream: _getCombinedMatchesStream(teamProvider),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00D9FF),
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
                          Icons.event_busy,
                          color: Colors.white30,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'কোন ম্যাচ নেই',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<MatchModel> allMatches = snapshot.data!;
                List<MatchModel> filteredMatches =
                _filterMatchesByDate(allMatches);

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

                return RefreshIndicator(
                  onRefresh: _loadData,
                  color: const Color(0xFF00D9FF),
                  backgroundColor: const Color(0xFF16213E),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (liveMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.play_circle_filled,
                          title: 'লাইভ ম্যাচ',
                          count: liveMatches.length,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        ...liveMatches.map((match) => _buildMatchCard(match, teamProvider)),
                        const SizedBox(height: 24),
                      ],
                      if (upcomingMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.schedule,
                          title: 'আসন্ন ম্যাচ',
                          count: upcomingMatches.length,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        ...upcomingMatches.map((match) => _buildMatchCard(match, teamProvider)),
                        const SizedBox(height: 24),
                      ],
                      if (finishedMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                          icon: Icons.check_circle,
                          title: 'সমাপ্ত ম্যাচ',
                          count: finishedMatches.length,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        ...finishedMatches.map((match) => _buildMatchCard(match, teamProvider)),
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
            child: Icon(icon, color: color, size: 20),
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

  Widget _buildMatchCard(MatchModel match, TeamProvider teamProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailsScreen(
              match: match,
              teamProvider: teamProvider,
            ),
          ),
        );
      },
      child: MatchCard(
        match: match,
        teamProvider: teamProvider,
      ),
    );
  }
}