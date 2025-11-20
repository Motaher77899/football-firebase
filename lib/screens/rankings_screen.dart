// lib/screens/rankings_screen.dart
import 'package:flutter/material.dart';
import '../models/team_ranking.dart';
import '../models/player_ranking.dart';
import '../services/ranking_service.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RankingService _rankingService = RankingService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('র‍্যাঙ্কিং'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'টিম র‍্যাঙ্কিং'),
            Tab(text: 'খেলোয়াড় র‍্যাঙ্কিং'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamRankings(),
          _buildPlayerRankings(),
        ],
      ),
    );
  }

  Widget _buildTeamRankings() {
    return StreamBuilder<List<TeamRanking>>(
      stream: _rankingService.getTeamRankings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final rankings = snapshot.data ?? [];

        if (rankings.isEmpty) {
          return const Center(
            child: Text('এখনো কোনো টিম র‍্যাঙ্কিং নেই'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rankings.length,
          itemBuilder: (context, index) {
            final ranking = rankings[index];
            return _buildTeamRankingCard(ranking, index + 1);
          },
        );
      },
    );
  }

  Widget _buildTeamRankingCard(TeamRanking ranking, int position) {
    Color positionColor;
    if (position == 1) {
      positionColor = Colors.amber;
    } else if (position == 2) {
      positionColor = Colors.grey[400]!;
    } else if (position == 3) {
      positionColor = Colors.brown[300]!;
    } else {
      positionColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Position
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: positionColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Team Logo
            if (ranking.teamLogo != null)
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(ranking.teamLogo!),
              )
            else
              CircleAvatar(
                radius: 25,
                child: Text(
                  ranking.teamName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            const SizedBox(width: 16),

            // Team Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranking.teamName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ম্যাচ: ${ranking.matchesPlayed} | জিত: ${ranking.wins} | ড্র: ${ranking.draws} | হার: ${ranking.losses}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'গোল: ${ranking.goalsFor}-${ranking.goalsAgainst} | GD: ${ranking.goalDifference > 0 ? '+' : ''}${ranking.goalDifference}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Points
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'পয়েন্ট',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${ranking.points}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRankings() {
    return StreamBuilder<List<PlayerRanking>>(
      stream: _rankingService.getPlayerRankings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final rankings = snapshot.data ?? [];

        if (rankings.isEmpty) {
          return const Center(
            child: Text('এখনো কোনো খেলোয়াড় র‍্যাঙ্কিং নেই'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rankings.length,
          itemBuilder: (context, index) {
            final ranking = rankings[index];
            return _buildPlayerRankingCard(ranking, index + 1);
          },
        );
      },
    );
  }

  Widget _buildPlayerRankingCard(PlayerRanking ranking, int position) {
    Color positionColor;
    if (position == 1) {
      positionColor = Colors.amber;
    } else if (position == 2) {
      positionColor = Colors.grey[400]!;
    } else if (position == 3) {
      positionColor = Colors.brown[300]!;
    } else {
      positionColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Position
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: positionColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Player Photo
            if (ranking.playerPhoto != null)
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(ranking.playerPhoto!),
              )
            else
              CircleAvatar(
                radius: 25,
                child: Text(
                  ranking.playerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            const SizedBox(width: 16),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranking.playerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ranking.teamName} • ${ranking.position}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatChip(
                        '⚽ ${ranking.goals}',
                        Colors.green,
                      ),
                      const SizedBox(width: 4),
                      _buildStatChip(
                        '🎯 ${ranking.assists}',
                        Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      _buildStatChip(
                        '🧤 ${ranking.cleanSheets}',
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Points
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[400]!, Colors.purple[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'পয়েন্ট',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${ranking.totalPoints}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}