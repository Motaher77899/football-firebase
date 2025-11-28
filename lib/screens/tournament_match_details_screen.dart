import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tournament/tournament_match_model.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';

/// Tournament Match Details Screen - Complete Implementation
/// Features: Match Info, Timeline, Stats, Lineup
class TournamentMatchDetailsScreen extends StatefulWidget {
  final TournamentMatch match;
  final TeamProvider teamProvider;

  const TournamentMatchDetailsScreen({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  State<TournamentMatchDetailsScreen> createState() =>
      _TournamentMatchDetailsScreenState();
}

class _TournamentMatchDetailsScreenState
    extends State<TournamentMatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper Methods
  String _getTeamLogoUrl(String teamId) {
    TeamModel? team = widget.teamProvider.getTeamById(teamId);
    return team?.logoUrl ?? '';
  }

  String _getTeamName(String teamId) {
    TeamModel? team = widget.teamProvider.getTeamById(teamId);
    return team?.name ?? 'Unknown';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      case 'finished':
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return '🔴 লাইভ চলছে';
      case 'upcoming':
        return '📅 আসন্ন ম্যাচ';
      case 'finished':
      case 'completed':
        return '✅ ম্যাচ সমাপ্ত';
      default:
        return status;
    }
  }

  String _getPositionFullName(String position) {
    switch (position.toUpperCase()) {
      case 'GK':
        return 'গোলরক্ষক';
      case 'DEF':
        return 'ডিফেন্ডার';
      case 'MID':
        return 'মিডফিল্ডার';
      case 'FWD':
        return 'ফরোয়ার্ড';
      default:
        return position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournament_matches')
            .doc(widget.match.id)
            .snapshots(),
        builder: (context, snapshot) {
          TournamentMatch match = widget.match;

          if (snapshot.hasData && snapshot.data != null) {
            try {
              match = TournamentMatch.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
                snapshot.data!.id,
              );
            } catch (e) {
              print('Error parsing match: $e');
            }
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(match),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildTabBar(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildMatchInfoTab(match),
                          _buildTimelineTab(match),
                          _buildStatsTab(match),
                          _buildLineupTab(match),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== APP BAR ====================
  Widget _buildAppBar(TournamentMatch match) {
    String teamALogoUrl = _getTeamLogoUrl(match.teamAId);
    String teamBLogoUrl = _getTeamLogoUrl(match.teamBId);
    String teamAName = _getTeamName(match.teamAId);
    String teamBName = _getTeamName(match.teamBId);

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF16213E),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF16213E),
                const Color(0xFF0F3460),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(match.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(match.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Teams and Score
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Team A
                    Expanded(
                      child: Column(
                        children: [
                          _buildTeamLogo(teamALogoUrl, size: 70),
                          const SizedBox(height: 8),
                          Text(
                            teamAName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${match.scoreA}',
                            style: TextStyle(
                              color: match.scoreA > match.scoreB
                                  ? Colors.greenAccent
                                  : Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              ':',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          Text(
                            '${match.scoreB}',
                            style: TextStyle(
                              color: match.scoreB > match.scoreA
                                  ? Colors.greenAccent
                                  : Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Team B
                    Expanded(
                      child: Column(
                        children: [
                          _buildTeamLogo(teamBLogoUrl, size: 70),
                          const SizedBox(height: 8),
                          Text(
                            teamBName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Round and Venue
                Column(
                  children: [
                    if (match.round.isNotEmpty)
                      Text(
                        match.round,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (match.venue.isNotEmpty) ...[
                      const SizedBox(height: 4),
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
                            match.venue,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String logoUrl, {double size = 70}) {
    if (logoUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF0F3460),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.shield,
          color: Colors.white60,
          size: size * 0.5,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xFF0F3460),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFF0F3460),
            child: Icon(
              Icons.shield,
              color: Colors.white60,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== TAB BAR ====================
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'ম্যাচ তথ্য'),
          Tab(text: 'টাইমলাইন'),
          Tab(text: 'পরিসংখ্যান'),
          Tab(text: 'লাইনআপ'),
        ],
      ),
    );
  }

  // ==================== MATCH INFO TAB ====================
  Widget _buildMatchInfoTab(TournamentMatch match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'টুর্নামেন্ট',
            value: match.tournamentId.toUpperCase(),
            icon: Icons.emoji_events,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'রাউন্ড',
            value: match.round,
            icon: Icons.flag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'স্থান',
            value: match.venue,
            icon: Icons.location_on,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'তারিখ',
            value: DateFormat('dd MMM yyyy, hh:mm a').format(match.matchDate),
            icon: Icons.calendar_today,
          ),

          const SizedBox(height: 32),

          // Winner Badge (for finished matches)
          if (match.status.toLowerCase() == 'finished' ||
              match.status.toLowerCase() == 'completed')
            _buildResultCard(match),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(TournamentMatch match) {
    String result;
    Color resultColor;
    IconData resultIcon;

    if (match.scoreA > match.scoreB) {
      result = '${_getTeamName(match.teamAId)} জয়ী!';
      resultColor = Colors.greenAccent;
      resultIcon = Icons.emoji_events;
    } else if (match.scoreB > match.scoreA) {
      result = '${_getTeamName(match.teamBId)} জয়ী!';
      resultColor = Colors.greenAccent;
      resultIcon = Icons.emoji_events;
    } else {
      result = 'ড্র ম্যাচ';
      resultColor = Colors.orange;
      resultIcon = Icons.handshake;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            resultColor.withOpacity(0.2),
            resultColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: resultColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(resultIcon, color: resultColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              result,
              style: TextStyle(
                color: resultColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TIMELINE TAB ====================
  Widget _buildTimelineTab(TournamentMatch match) {
    print('🔍 Timeline Debug:');
    print('Timeline length: ${match.timeline.length}');

    if (match.timeline.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'কোন ইভেন্ট নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Sort timeline descending (latest first)
    final sortedTimeline = List<TimelineEvent>.from(match.timeline)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    print('Timeline events:');
    for (var event in sortedTimeline) {
      print('  - Minute: ${event.minute}, Player: ${event.playerName}, Team: ${event.team}, Type: ${event.type}');
    }

    String teamAName = _getTeamName(match.teamAId);
    String teamBName = _getTeamName(match.teamBId);

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedTimeline.length,
      itemBuilder: (context, index) {
        final event = sortedTimeline[index];

        // Check if this is Team A or Team B event
        bool isTeamA = event.team.toUpperCase() == 'A' ||
            event.team.toLowerCase() == 'teama';

        return _buildTimelineEvent(
          event: event,
          isTeamA: isTeamA,
          teamName: isTeamA ? teamAName : teamBName,
        );
      },
    );
  }

  Widget _buildTimelineEvent({
    required TimelineEvent event,
    required bool isTeamA,
    required String teamName,
  }) {
    Color teamColor = isTeamA ? Colors.blue : Colors.orange;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team A events (left side)
          if (isTeamA) ...[
            Expanded(
              child: _buildEventCard(event, teamColor, teamName, isLeft: true),
            ),
            const SizedBox(width: 16),
            _buildMinuteBadge(event),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()),
          ]
          // Team B events (right side)
          else ...[
            const Expanded(child: SizedBox()),
            const SizedBox(width: 16),
            _buildMinuteBadge(event),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEventCard(event, teamColor, teamName, isLeft: false),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventCard(
      TimelineEvent event,
      Color teamColor,
      String teamName, {
        required bool isLeft,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: teamColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: isLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            event.playerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEventDisplayText(event),
            style: TextStyle(
              color: teamColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinuteBadge(TimelineEvent event) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: event.color, width: 2),
      ),
      child: Center(
        child: Text(
          "${event.minute}'",
          style: TextStyle(
            color: event.color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getEventDisplayText(TimelineEvent event) {
    switch (event.type.toLowerCase()) {
      case 'goal':
        if (event.goalType != null) {
          switch (event.goalType!.toLowerCase()) {
            case 'penalty':
              return '⚽ পেনাল্টি গোল';
            case 'free_kick':
              return '⚽ ফ্রি-কিক গোল';
            case 'header':
              return '⚽ হেডার গোল';
            default:
              return '⚽ গোল';
          }
        }
        return '⚽ গোল';
      case 'yellow_card':
        return '🟨 হলুদ কার্ড';
      case 'red_card':
        return '🟥 লাল কার্ড';
      case 'substitution':
        return '🔄 প্রতিস্থাপন';
      default:
        return event.type;
    }
  }

  // ==================== STATS TAB ====================
  Widget _buildStatsTab(TournamentMatch match) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF16213E),
            child: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(text: 'ম্যাচ পরিসংখ্যান'),
                Tab(text: 'H2H'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMatchStatsView(match),
                _buildH2HView(match),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStatsView(TournamentMatch match) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .doc(match.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || data['stats'] == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: Colors.white30,
                ),
                const SizedBox(height: 16),
                Text(
                  'পরিসংখ্যান নেই',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final stats = data['stats'] as Map<String, dynamic>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildStatBar(
                'বল নিয়ন্ত্রণ',
                stats['possessionA'] ?? 0,
                stats['possessionB'] ?? 0,
                isPercentage: true,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'শট',
                stats['shotsA'] ?? 0,
                stats['shotsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'টার্গেট শট',
                stats['shotsOnTargetA'] ?? 0,
                stats['shotsOnTargetB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'কর্নার',
                stats['cornersA'] ?? 0,
                stats['cornersB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'ফাউল',
                stats['foulsA'] ?? 0,
                stats['foulsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'হলুদ কার্ড',
                stats['yellowCardsA'] ?? 0,
                stats['yellowCardsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'লাল কার্ড',
                stats['redCardsA'] ?? 0,
                stats['redCardsB'] ?? 0,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBar(
      String label,
      int valueA,
      int valueB, {
        bool isPercentage = false,
      }) {
    int total = valueA + valueB;
    double percentageA = total > 0 ? (valueA / total) : 0.5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isPercentage ? '$valueA%' : '$valueA',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              isPercentage ? '$valueB%' : '$valueB',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentageA,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildH2HView(TournamentMatch match) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .doc(match.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || data['h2h'] == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.white30,
                ),
                const SizedBox(height: 16),
                Text(
                  'পূর্ববর্তী রেকর্ড নেই',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final h2h = data['h2h'] as Map<String, dynamic>;
        final teamAName = _getTeamName(match.teamAId);
        final teamBName = _getTeamName(match.teamBId);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildH2HCard(
                title: 'মোট ম্যাচ',
                value: '${h2h['totalMatches'] ?? 0}',
                icon: Icons.sports_soccer,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildH2HCard(
                      title: teamAName,
                      subtitle: 'জয়',
                      value: '${h2h['teamAWins'] ?? 0}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildH2HCard(
                      title: 'ড্র',
                      value: '${h2h['draws'] ?? 0}',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildH2HCard(
                      title: teamBName,
                      subtitle: 'জয়',
                      value: '${h2h['teamBWins'] ?? 0}',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildH2HCard({
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? Colors.white).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? Colors.white,
              size: 24,
            ),
          if (icon != null) const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== LINEUP TAB ====================
  Widget _buildLineupTab(TournamentMatch match) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .doc(match.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        print('🔍 [Lineup Tab] Full data keys: ${data?.keys.toList()}');
        print('🔍 [Lineup Tab] lineUpA exists: ${data?.containsKey('lineUpA')}');

        if (data == null) {
          return _buildNoLineupMessage();
        }

        // Handle both structures
        dynamic lineupAData;
        dynamic lineupBData;

        if (data['lineUpA'] != null) {
          final lineupAMap = data['lineUpA'] as Map<String, dynamic>;

          if (lineupAMap.containsKey('lineUpA')) {
            lineupAData = {
              'formation': lineupAMap['lineUpA'],
              'players': lineupAMap['players'] ?? []
            };
          } else if (lineupAMap.containsKey('formation')) {
            lineupAData = lineupAMap;
          }
        }

        if (data['lineUpB'] != null) {
          final lineupBMap = data['lineUpB'] as Map<String, dynamic>;

          if (lineupBMap.containsKey('lineUpB')) {
            lineupBData = {
              'formation': lineupBMap['lineUpB'],
              'players': lineupBMap['players'] ?? []
            };
          } else if (lineupBMap.containsKey('formation')) {
            lineupBData = lineupBMap;
          }
        }

        if (lineupAData == null && lineupBData == null) {
          return _buildNoLineupMessage();
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
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
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: [
                    Tab(text: _getTeamName(match.teamAId)),
                    Tab(text: _getTeamName(match.teamBId)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSingleTeamLineup(
                      lineupAData,
                      _getTeamName(match.teamAId),
                      Colors.blue,
                    ),
                    _buildSingleTeamLineup(
                      lineupBData,
                      _getTeamName(match.teamBId),
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoLineupMessage() {
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

  Widget _buildSingleTeamLineup(
      dynamic lineupData,
      String teamName,
      Color teamColor,
      ) {
    if (lineupData == null) {
      return _buildNoLineupMessage();
    }

    final lineup = lineupData as Map<String, dynamic>;
    final String formation = lineup['formation'] ?? '4-4-2';
    final List<dynamic> playersData = lineup['players'] ?? [];

    if (playersData.isEmpty) {
      return _buildNoLineupMessage();
    }

    // Parse players
    List<Map<String, dynamic>> players = [];
    for (var playerData in playersData) {
      if (playerData is Map) {
        players.add(Map<String, dynamic>.from(playerData as Map));
      }
    }

    // Group by position
    final gk = players.where((p) =>
    (p['position']?.toString().toUpperCase() == 'GK') &&
        !(p['isSubstitute'] ?? false)).toList();

    final def = players.where((p) =>
    (p['position']?.toString().toUpperCase() == 'DEF') &&
        !(p['isSubstitute'] ?? false)).toList();

    final mid = players.where((p) =>
    (p['position']?.toString().toUpperCase() == 'MID') &&
        !(p['isSubstitute'] ?? false)).toList();

    final fwd = players.where((p) =>
    (p['position']?.toString().toUpperCase() == 'FWD') &&
        !(p['isSubstitute'] ?? false)).toList();

    final subs = players.where((p) =>
    p['isSubstitute'] == true).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Formation Header
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
              border: Border.all(color: teamColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  teamName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Formation: $formation',
                  style: TextStyle(
                    color: teamColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Positions
          if (gk.isNotEmpty) ...[
            _buildPositionGroup('গোলরক্ষক', gk, teamColor),
            const SizedBox(height: 16),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroup('ডিফেন্ডার', def, teamColor),
            const SizedBox(height: 16),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroup('মিডফিল্ডার', mid, teamColor),
            const SizedBox(height: 16),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroup('ফরোয়ার্ড', fwd, teamColor),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              'সাবস্টিটিউট',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...subs.map((player) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPlayerCard(player, teamColor),
            )),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPositionGroup(
      String position,
      List<Map<String, dynamic>> players,
      Color color,
      ) {
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
          child: _buildPlayerCard(player, color),
        )),
      ],
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player, Color color) {
    final String playerName = player['playerName']?.toString() ?? 'Unknown';
    final int jerseyNumber = player['jerseyNumber'] is int
        ? player['jerseyNumber']
        : int.tryParse(player['jerseyNumber']?.toString() ?? '0') ?? 0;
    final bool isCaptain = player['isCaptain'] == true;
    final String position = player['position']?.toString() ?? '';

    String firstLetter = playerName.isNotEmpty
        ? playerName[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCaptain ? Colors.amber : color.withOpacity(0.3),
          width: isCaptain ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
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
                        playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber),
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
                              'C',
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
                    _getPositionFullName(position),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Text(
                '$jerseyNumber',
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
}