
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart'; // ✅ rxdart ইম্পোর্ট করা হয়েছে
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
  // Provider ইনস্ট্যান্সগুলো সাধারণত এখানে থাকে,
  // তবে এটি StatefulWidget হওয়ায় আমরা এগুলোকে উপরেই রাখছি।
  final MatchProvider _matchProvider = MatchProvider();
  final TeamProvider _teamProvider = TeamProvider();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // প্রাথমিকভাবে ডেটা লোড করার জন্য
    _loadData();
  }

  // ✅ ডেটা লোড করার ফাংশন
  Future<void> _loadData() async {
    debugPrint('🔄 Loading data...');

    // Team ডেটা আগে লোড করুন, কারণ এটি Match-এর কনভার্সনের জন্য প্রয়োজনীয়
    await _teamProvider.fetchTeams();
    debugPrint('✅ Teams loaded: ${_teamProvider.teams.length}');

    // matchProvider-এ কোনো fetchMatches দরকার নেই, কারণ আমরা Stream ব্যবহার করছি
    // তবে, যদি provider-এর ভিতরের কোনো ডেটা দরকার হয়, তবে কল করতে পারেন।
    // এই মুহূর্তে, StreamBuilder সমস্ত ডেটা লোড করবে।

    debugPrint('✅ Initial data loading finished');
  }

  // ডেট অনুযায়ী ম্যাচ ফিল্টার করার ফাংশন
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

  // ✅ Tournament ম্যাচকে MatchModel-এ রূপান্তর করার ফাংশন
  MatchModel? _tournamentMatchToMatchModel(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      final homeTeamId = data['homeTeamId'] ?? data['teamAId'] ?? '';
      final awayTeamId = data['awayTeamId'] ?? data['teamBId'] ?? '';

      // ✅ Get actual team objects from provider
      final homeTeam = _teamProvider.getTeamById(homeTeamId);
      final awayTeam = _teamProvider.getTeamById(awayTeamId);

      if (homeTeam == null || awayTeam == null) {
        // এই ক্ষেত্রে, কনসোল স্প্যামিং এড়াতে এই প্রিন্টগুলো বাদ দেওয়া ভালো
        // debugPrint('   ❌ Teams not found: home=$homeTeamId, away=$awayTeamId');
        return null;
      }

      // debugPrint('   ✅ Teams found: ${homeTeam.name} vs ${awayTeam.name}'); // রিয়েল-টাইমে প্রিন্ট এড়িয়ে যাওয়া ভালো

      return MatchModel(
        id: doc.id,
        teamA: homeTeam.name,
        teamB: awayTeam.name,
        scoreA: data['homeScore'] ?? data['scoreA'] ?? 0,
        scoreB: data['awayScore'] ?? data['scoreB'] ?? 0,
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

  // **********************************************
  // ** 🔥 সংশোধিত Combined Stream ফাংশন (rxdart) **
  // **********************************************
  Stream<List<MatchModel>> _getCombinedMatchesStream() {
    // 1. Regular Matches Stream
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

    // 2. Tournament Matches Stream (Conversion লজিক এখানে কল হবে)
    final tournamentMatchesStream = FirebaseFirestore.instance
        .collection('tournament_matches')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          // _tournamentMatchToMatchModel ফাংশনটি কল করা হচ্ছে
          final match = _tournamentMatchToMatchModel(doc);
          return match;
        } catch (e) {
          debugPrint('❌ Error parsing tournament match: $e');
          return null;
        }
      }).whereType<MatchModel>().toList();
    });

    // 3. CombineLatestStream ব্যবহার করে দুটি স্ট্রিমকে একত্রিত করুন
    return CombineLatestStream.combine2(
      regularMatchesStream,
      tournamentMatchesStream,
          (List<MatchModel> regularMatches, List<MatchModel> tournamentMatches) {
        final allMatches = [...regularMatches, ...tournamentMatches];

        // ✅ শুধুমাত্র একবার প্রিন্ট হবে যখন ডেটা আপডেট হবে
        debugPrint('--- Combined Stream Update ---');
        debugPrint('📊 Regular Matches: ${regularMatches.length}');
        debugPrint('🏆 Tournament Matches: ${tournamentMatches.length}');
        debugPrint('🎯 Total Combined: ${allMatches.length}');

        return allMatches;
      },
    );
  }
  // **********************************************

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
            // ✅ সংশোধিত StreamBuilder
            child: StreamBuilder<List<MatchModel>>(
              stream: _getCombinedMatchesStream(),
              builder: (context, snapshot) {
                // Debug information
                debugPrint('📊 Connection State: ${snapshot.connectionState}');

                if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
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

                // Filter matches by selected date
                List<MatchModel> allMatches = snapshot.data!;
                List<MatchModel> filteredMatches =
                _filterMatchesByDate(allMatches);

                // ... (বাকি কোড অপরিবর্তিত) ...

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