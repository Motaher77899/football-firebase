import 'package:flutter/material.dart';
import 'package:football_user_app/screens/team_list_screen.dart';
import 'package:intl/intl.dart';
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
    await _teamProvider.fetchTeams();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          '⚽ Football Live Score',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamListScreen()),
              );
            },
          ),
        ],
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
              stream: _matchProvider.streamMatches(),
              builder: (context, snapshot) {
                // Debug information
                debugPrint('📊 Connection State: ${snapshot.connectionState}');
                debugPrint('📊 Has Data: ${snapshot.hasData}');
                debugPrint('📊 Data Length: ${snapshot.data?.length ?? 0}');
                debugPrint('📊 Has Error: ${snapshot.hasError}');
                if (snapshot.hasError) {
                  debugPrint('❌ Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF0F3460),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Data lodding...',
                          style: TextStyle(color: Colors.white70),
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
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Try again'),
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
                          'No Match',
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
                            backgroundColor: const Color(0xFF0F3460),
                            foregroundColor: Colors.white,
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
                    .where((m) => m.status == 'finished')
                    .toList();

                debugPrint('🔴 Live: ${liveMatches.length}');
                debugPrint('📅 Upcoming: ${upcomingMatches.length}');
                debugPrint('✅ Finished: ${finishedMatches.length}');

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
                          'No Match This Date',
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
                  color: const Color(0xFF0F3460),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Live Matches Section
                      if (liveMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                            '🔴 Live', liveMatches.length),
                        const SizedBox(height: 12),
                        ...liveMatches.map((match) => _buildMatchCard(match)),
                        const SizedBox(height: 24),
                      ],

                      // Upcoming Matches Section
                      if (upcomingMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                            '📅 Upcoming', upcomingMatches.length),
                        const SizedBox(height: 12),
                        ...upcomingMatches
                            .map((match) => _buildMatchCard(match)),
                        const SizedBox(height: 24),
                      ],

                      // Finished Matches Section
                      if (finishedMatches.isNotEmpty) ...[
                        _buildSectionHeader(
                            '✅ Finished', finishedMatches.length),
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

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF0F3460),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
