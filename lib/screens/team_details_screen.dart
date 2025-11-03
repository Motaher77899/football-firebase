import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:football_user_app/screens/player_screen.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../models/player_model.dart';

class TeamDetailsScreen extends StatefulWidget {
  final TeamModel team;

  const TeamDetailsScreen({Key? key, required this.team}) : super(key: key);

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int totalMatches = 0;
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int goalsScored = 0;
  int goalsConceded = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calculateStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _calculateStats() async {
    final matchesSnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('status', isEqualTo: 'finished')
        .get();

    int w = 0, l = 0, d = 0, scored = 0, conceded = 0;

    for (var doc in matchesSnapshot.docs) {
      final data = doc.data();
      final teamA = data['teamA'] as String;
      final teamB = data['teamB'] as String;
      final scoreA = data['scoreA'] as int;
      final scoreB = data['scoreB'] as int;

      if (teamA.toLowerCase() == widget.team.name.toLowerCase()) {
        scored += scoreA;
        conceded += scoreB;
        if (scoreA > scoreB) {
          w++;
        } else if (scoreA < scoreB) {
          l++;
        } else {
          d++;
        }
      } else if (teamB.toLowerCase() == widget.team.name.toLowerCase()) {
        scored += scoreB;
        conceded += scoreA;
        if (scoreB > scoreA) {
          w++;
        } else if (scoreB < scoreA) {
          l++;
        } else {
          d++;
        }
      }
    }

    setState(() {
      totalMatches = w + l + d;
      wins = w;
      losses = l;
      draws = d;
      goalsScored = scored;
      goalsConceded = conceded;
    });
  }

  String _getTeamLogoUrl(String teamName) {
    final name = teamName.toLowerCase();
    final flags = {
      // 'bangladesh': 'https://flagcdn.com/w80/bd.png',

    };

    for (var entry in flags.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }

    return widget.team.logoUrl;
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = _getTeamLogoUrl(widget.team.name);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          // App Bar with Team Header
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF16213E),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0F3460),
                      const Color(0xFF16213E),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Team Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: logoUrl.isEmpty
                            ? Container(
                          color: const Color(0xFF0F3460),
                          child: const Icon(
                            Icons.shield,
                            color: Colors.white60,
                            size: 50,
                          ),
                        )
                            : CachedNetworkImage(
                          imageUrl: logoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF0F3460),
                            child: const Icon(
                              Icons.shield,
                              color: Colors.white60,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Team Name
                    Text(
                      widget.team.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white60,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.team.upazila,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0F3460),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'পরিসংখ্যান'),
                Tab(text: 'ম্যাচসমূহ'),
                Tab(text: 'খেলোয়াড়'),
              ],
            ),
          ),

          // Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatsTab(),
                _buildMatchesTab(),
                _buildPlayersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stats Tab
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Stats
          _buildStatsCard(
            title: 'সামগ্রিক পরিসংখ্যান',
            icon: Icons.bar_chart,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      label: 'মোট ম্যাচ',
                      value: totalMatches.toString(),
                      icon: Icons.sports_soccer,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      label: 'খেলোয়াড়',
                      value: widget.team.playersCount.toString(),
                      icon: Icons.group,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      label: 'জয়',
                      value: wins.toString(),
                      icon: Icons.emoji_events,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      label: 'পরাজয়',
                      value: losses.toString(),
                      icon: Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      label: 'ড্র',
                      value: draws.toString(),
                      icon: Icons.handshake,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Goals Stats
          _buildStatsCard(
            title: 'গোল পরিসংখ্যান',
            icon: Icons.sports_soccer,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      label: 'গোল করেছে',
                      value: goalsScored.toString(),
                      icon: Icons.arrow_upward,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      label: 'গোল খেয়েছে',
                      value: goalsConceded.toString(),
                      icon: Icons.arrow_downward,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      label: 'গোল পার্থক্য',
                      value: (goalsScored - goalsConceded).toString(),
                      icon: Icons.trending_up,
                      color: (goalsScored - goalsConceded) >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatBox(
                      label: 'জয়ের হার',
                      value: totalMatches > 0
                          ? '${((wins / totalMatches) * 100).toStringAsFixed(0)}%'
                          : '0%',
                      icon: Icons.percent,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Win Rate Chart (Visual)
          if (totalMatches > 0)
            _buildStatsCard(
              title: 'ফলাফল বিতরণ',
              icon: Icons.pie_chart,
              children: [
                _buildResultBar(
                  label: 'জয়',
                  value: wins,
                  total: totalMatches,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildResultBar(
                  label: 'পরাজয়',
                  value: losses,
                  total: totalMatches,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                _buildResultBar(
                  label: 'ড্র',
                  value: draws,
                  total: totalMatches,
                  color: Colors.grey,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResultBar({
    required String label,
    required int value,
    required int total,
    required Color color,
  }) {
    double percentage = total > 0 ? (value / total) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              '$value (${(percentage * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // Matches Tab
  Widget _buildMatchesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'কোন ম্যাচ পাওয়া যায়নি',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        // Filter matches for this team
        final teamMatches = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final teamA = (data['teamA'] as String).toLowerCase();
          final teamB = (data['teamB'] as String).toLowerCase();
          final teamName = widget.team.name.toLowerCase();
          return teamA == teamName || teamB == teamName;
        }).toList();

        if (teamMatches.isEmpty) {
          return const Center(
            child: Text(
              'এই দলের কোন ম্যাচ নেই',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teamMatches.length,
          itemBuilder: (context, index) {
            final doc = teamMatches[index];
            final match = MatchModel.fromFirestore(doc);
            return _buildMatchCard(match);
          },
        );
      },
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final isTeamA = match.teamA.toLowerCase() == widget.team.name.toLowerCase();
    final opponentName = isTeamA ? match.teamB : match.teamA;
    final teamScore = isTeamA ? match.scoreA : match.scoreB;
    final opponentScore = isTeamA ? match.scoreB : match.scoreA;

    String result = '';
    Color resultColor = Colors.grey;

    if (match.status == 'finished') {
      if (teamScore > opponentScore) {
        result = 'জয়';
        resultColor = Colors.green;
      } else if (teamScore < opponentScore) {
        result = 'পরাজয়';
        resultColor = Colors.red;
      } else {
        result = 'ড্র';
        resultColor = Colors.grey;
      }
    } else if (match.status == 'live') {
      result = 'লাইভ';
      resultColor = Colors.orange;
    } else {
      result = 'আসন্ন';
      resultColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Result Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: resultColor, width: 1),
            ),
            child: Text(
              result,
              style: TextStyle(
                color: resultColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Score Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Team Score (highlighted)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$teamScore',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '-',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 24,
                  ),
                ),
              ),
              // Opponent Score
              Text(
                '$opponentScore',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Opponent Name
          Text(
            'vs $opponentName',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .where('teamName', isEqualTo: widget.team.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'এই দলের কোনো খেলোয়াড় পাওয়া যায়নি',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        final players = snapshot.data!.docs
            .map((doc) => PlayerModel.fromFirestore(doc))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerCard(player);
          },
        );
      },
    );
  }


  Widget _buildPlayerCard(PlayerModel player) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerScreen(player: player,),
          ),
        );

      },

        child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0F3460),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: player.imageUrl.isEmpty
                  ? Container(
                color: const Color(0xFF0F3460),
                child: const Icon(
                  Icons.person,
                  color: Colors.white60,
                  size: 30,
                ),
              )
                  : CachedNetworkImage(
                imageUrl: player.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF0F3460),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white60,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            player.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              player.position,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white54,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}