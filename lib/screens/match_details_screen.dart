

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchDetailsScreen extends StatefulWidget {
  final MatchModel match;
  final TeamProvider teamProvider;

  const MatchDetailsScreen({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen>
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

  String? _getDefaultLogoUrl(String teamName) {
    final name = teamName.toLowerCase();
    final flags = {
      'bangladesh': 'https://flagcdn.com/w80/bd.png',

    };

    for (var entry in flags.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  String _getTeamLogoUrl(String teamName) {
    TeamModel? team = widget.teamProvider.getTeamByName(teamName);
    if (team != null && team.logoUrl.isNotEmpty) {
      return team.logoUrl;
    }
    String? defaultUrl = _getDefaultLogoUrl(teamName);
    if (defaultUrl != null) {
      return defaultUrl;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    String teamALogoUrl = _getTeamLogoUrl(widget.match.teamA);
    String teamBLogoUrl = _getTeamLogoUrl(widget.match.teamB);
    TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
    TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          // App Bar with Match Score
          SliverAppBar(
            expandedHeight: 360,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF16213E),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF16213E),
                      Color(0xFF0F3460),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.match.status),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor(widget.match.status)
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.match.status == 'live')
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Text(
                              _getStatusText(widget.match.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Score Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Team A
                          Expanded(
                            child: Column(
                              children: [
                                _buildTeamLogo(teamALogoUrl, size: 70),
                                const SizedBox(height: 12),
                                Text(
                                  widget.match.teamA.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Score
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
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
                                  '${widget.match.scoreA}',
                                  style: TextStyle(
                                    color: widget.match.scoreA >
                                        widget.match.scoreB
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${widget.match.scoreB}',
                                  style: TextStyle(
                                    color: widget.match.scoreB >
                                        widget.match.scoreA
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    fontSize: 42,
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
                                const SizedBox(height: 12),
                                Text(
                                  widget.match.teamB.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tournament & Venue
                      if (widget.match.tournament != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.match.tournament!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      if (widget.match.venue != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.match.venue!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: const Color(0xFF16213E),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'ম্যাচ তথ্য'),
                    Tab(text: 'টাইমলাইন'),
                    Tab(text: 'পরিসংখ্যান'),
                    Tab(text: 'লাইনআপ'),
                  ],
                ),
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMatchInfoTab(),
                _buildTimelineTab(),
                _buildStatsTab(),
                _buildLineupTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Match Info Tab
  Widget _buildMatchInfoTab() {
    TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
    TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Basic Match Info
          _buildInfoCard(
            title: 'ম্যাচ বিবরণ',
            icon: Icons.info_outline,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'তারিখ',
                value: DateFormat('EEEE, dd MMMM yyyy')
                    .format(widget.match.date),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.access_time,
                label: 'সময়',
                value: DateFormat('hh:mm a').format(widget.match.time),
              ),
              if (widget.match.tournament != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.emoji_events,
                  label: 'টুর্নামেন্ট',
                  value: widget.match.tournament!,
                ),
              ],
              if (widget.match.venue != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.stadium,
                  label: 'স্টেডিয়াম',
                  value: widget.match.venue!,
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Teams Info
          if (teamA != null || teamB != null)
            _buildInfoCard(
              title: 'টিম তথ্য',
              icon: Icons.group,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTeamInfoBox(
                        teamName: widget.match.teamA,
                        players: teamA?.playersCount.toString() ?? '-',
                        location: teamA?.upazila ?? '-',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTeamInfoBox(
                        teamName: widget.match.teamB,
                        players: teamB?.playersCount.toString() ?? '-',
                        location: teamB?.upazila ?? '-',
                      ),
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Match Result (for finished matches)
          if (widget.match.status == 'finished') _buildResultCard(),
        ],
      ),
    );
  }

  // Timeline Tab
  Widget _buildTimelineTab() {
    if (widget.match.timeline.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
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

    // Sort timeline by minute in descending order (latest events on top)
    final sortedTimeline = List<MatchEvent>.from(widget.match.timeline)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedTimeline.length,
      itemBuilder: (context, index) {
        final event = sortedTimeline[index];
        final isLast = index == sortedTimeline.length - 1;
        return _buildTimelineItem(event, isLast);
      },
    );
  }

  Widget _buildTimelineItem(MatchEvent event, bool isLast) {
    IconData icon;
    Color color;
    String eventText;

    switch (event.type) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = Colors.greenAccent;
        eventText = '⚽ গোল';
        break;
      case 'card':
        icon = Icons.square;
        color = event.details == 'red_card' ? Colors.red : Colors.yellow;
        eventText = event.details == 'red_card' ? '🟥 লাল কার্ড' : '🟨 হলুদ কার্ড';
        break;
      case 'substitution':
        icon = Icons.swap_horiz;
        color = Colors.blueAccent;
        eventText = '🔄 সাবস্টিটিউশন';
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
        eventText = event.details ?? '';
    }

    bool isTeamA = event.team == 'teamA';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team A Event (Left Side)
          Expanded(
            child: isTeamA
                ? _buildEventCard(
              playerName: event.playerName,
              eventText: eventText,
              color: Colors.blue,
              isLeft: true,
            )
                : const SizedBox(),
          ),

          const SizedBox(width: 12),

          // Center Timeline
          Column(
            children: [
              // Minute Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  "${event.minute}'",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Timeline Line
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withOpacity(0.5),
                        Colors.white24,
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Team B Event (Right Side)
          Expanded(
            child: !isTeamA
                ? _buildEventCard(
              playerName: event.playerName,
              eventText: eventText,
              color: Colors.orange,
              isLeft: false,
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String playerName,
    required String eventText,
    required Color color,
    required bool isLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            playerName,
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              eventText,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Tab
  Widget _buildStatsTab() {
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
                _buildMatchStatsView(),
                _buildH2HView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStatsView() {
    if (widget.match.stats == null) {
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

    final stats = widget.match.stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatBar(
            'বল নিয়ন্ত্রণ',
            stats.possessionA,
            stats.possessionB,
            isPercentage: true,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'শট',
            stats.shotsA,
            stats.shotsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'টার্গেট শট',
            stats.shotsOnTargetA,
            stats.shotsOnTargetB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'কর্নার',
            stats.cornersA,
            stats.cornersB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'ফাউল',
            stats.foulsA,
            stats.foulsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'হলুদ কার্ড',
            stats.yellowCardsA,
            stats.yellowCardsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'লাল কার্ড',
            stats.redCardsA,
            stats.redCardsB,
          ),
        ],
      ),
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

  Widget _buildH2HView() {
    if (widget.match.h2h == null) {
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

    final h2h = widget.match.h2h!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Total Matches
          _buildH2HCard(
            title: 'মোট ম্যাচ',
            value: '${h2h.totalMatches}',
            icon: Icons.sports_soccer,
          ),

          const SizedBox(height: 16),

          // Win Comparison
          Row(
            children: [
              Expanded(
                child: _buildH2HCard(
                  title: widget.match.teamA,
                  subtitle: 'জয়',
                  value: '${h2h.teamAWins}',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: 'ড্র',
                  value: '${h2h.draws}',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: widget.match.teamB,
                  subtitle: 'জয়',
                  value: '${h2h.teamBWins}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Goals Comparison
          Row(
            children: [
              Expanded(
                child: _buildH2HCard(
                  title: 'গোল',
                  subtitle: widget.match.teamA,
                  value: '${h2h.teamAGoals}',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: 'গোল',
                  subtitle: widget.match.teamB,
                  value: '${h2h.teamBGoals}',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
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

  // Lineup Tab
  Widget _buildLineupTab() {
    if (widget.match.lineUpA == null && widget.match.lineUpB == null) {
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

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Team Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
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
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.match.teamA,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.match.teamB,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Team Lineup Content
          Expanded(
            child: TabBarView(
              children: [
                // Team A Lineup
                _buildSingleTeamLineup(
                  widget.match.teamA,
                  widget.match.lineUpA,
                  Colors.blue,
                ),
                // Team B Lineup
                _buildSingleTeamLineup(
                  widget.match.teamB,
                  widget.match.lineUpB,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTeamLineup(
      String teamName, LineUp? lineUp, Color teamColor) {
    if (lineUp == null) {
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

    // Group players by position (exclude substitutes)
    final gk = lineUp.players
        .where((p) => p.position == 'GK' && !p.isSubstitute)
        .toList();
    final def = lineUp.players
        .where((p) => p.position == 'DEF' && !p.isSubstitute)
        .toList();
    final mid = lineUp.players
        .where((p) => p.position == 'MID' && !p.isSubstitute)
        .toList();
    final fwd = lineUp.players
        .where((p) => p.position == 'FWD' && !p.isSubstitute)
        .toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Formation Display
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
              border: Border.all(
                color: teamColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      color: teamColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        teamName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: teamColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        color: teamColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Formation: ${lineUp.formation}',
                        style: TextStyle(
                          color: teamColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Starting XI Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: teamColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'স্টার্টিং ইলেভেন',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Positions
          if (gk.isNotEmpty) ...[
            _buildPositionGroupFull('গোলরক্ষক', gk, teamColor),
            const SizedBox(height: 16),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroupFull('ডিফেন্ডার', def, teamColor),
            const SizedBox(height: 16),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroupFull('মিডফিল্ডার', mid, teamColor),
            const SizedBox(height: 16),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroupFull('ফরোয়ার্ড', fwd, teamColor),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'সাবস্টিটিউট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...subs.map((player) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPlayerCardFull(player, teamColor),
            )),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTeamLineup(String teamName, LineUp lineUp, Color color) {
    // Group players by position
    final gk = lineUp.players.where((p) => p.position == 'GK').toList();
    final def = lineUp.players.where((p) => p.position == 'DEF').toList();
    final mid = lineUp.players.where((p) => p.position == 'MID').toList();
    final fwd = lineUp.players.where((p) => p.position == 'FWD').toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shield, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                teamName.toUpperCase(),
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
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lineUp.formation,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Starting XI
          if (gk.isNotEmpty) ...[
            _buildPositionGroup('গোলরক্ষক', gk, color),
            const SizedBox(height: 12),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroup('ডিফেন্ডার', def, color),
            const SizedBox(height: 12),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroup('মিডফিল্ডার', mid, color),
            const SizedBox(height: 12),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroup('ফরোয়ার্ড', fwd, color),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Text(
              'সাবস্টিটিউট',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...subs.map((player) => _buildPlayerCard(player, color)),
          ],
        ],
      ),
    );
  }

  // Compact version for side-by-side layout
  Widget _buildTeamLineupCompact(
      String teamName, LineUp lineUp, Color color, bool isLeftSide) {
    // Group players by position (exclude substitutes from main list)
    final gk = lineUp.players
        .where((p) => p.position == 'GK' && !p.isSubstitute)
        .toList();
    final def = lineUp.players
        .where((p) => p.position == 'DEF' && !p.isSubstitute)
        .toList();
    final mid = lineUp.players
        .where((p) => p.position == 'MID' && !p.isSubstitute)
        .toList();
    final fwd = lineUp.players
        .where((p) => p.position == 'FWD' && !p.isSubstitute)
        .toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Header - Simple text only
          Center(
            child: Column(
              children: [
                Text(
                  teamName.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                // Formation Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    lineUp.formation,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Starting XI
          if (gk.isNotEmpty) ...[
            _buildPositionGroupCompact('গোলরক্ষক', gk, color),
            const SizedBox(height: 10),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroupCompact('ডিফেন্ডার', def, color),
            const SizedBox(height: 10),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroupCompact('মিডফিল্ডার', mid, color),
            const SizedBox(height: 10),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroupCompact('ফরোয়ার্ড', fwd, color),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'সাবস্টিটিউট',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...subs.map((player) => _buildPlayerCardCompact(player, color)),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionGroup(
      String position, List<PlayerLineUp> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...players.map((player) => _buildPlayerCard(player, color)),
      ],
    );
  }

  Widget _buildPositionGroupCompact(
      String position, List<PlayerLineUp> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ...players.map((player) => _buildPlayerCardCompact(player, color)),
      ],
    );
  }

  Widget _buildPositionGroupFull(
      String position, List<PlayerLineUp> players, Color color) {
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
          child: _buildPlayerCardFull(player, color),
        )),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerLineUp player, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: player.isCaptain ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Jersey Number
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${player.jerseyNumber}',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Player Name
          Expanded(
            child: Text(
              player.playerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Captain Badge
          if (player.isCaptain)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: const Text(
                'C',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardCompact(PlayerLineUp player, Color color) {
    // Get first letter of player name
    String firstLetter = player.playerName.isNotEmpty
        ? player.playerName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: player.isCaptain ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar with First Letter (Left)
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                firstLetter,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Player Name (Middle) - Flexible
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  player.playerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Captain Badge below name if captain
                if (player.isCaptain)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 9,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Captain',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Jersey Number (Right)
          Container(
            constraints: const BoxConstraints(
              minWidth: 32,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '${player.jerseyNumber}',
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardFull(PlayerLineUp player, Color color) {
    // Get first letter of player name
    String firstLetter = player.playerName.isNotEmpty
        ? player.playerName[0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : color.withOpacity(0.2),
          width: player.isCaptain ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with First Letter
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
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
                        player.playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (player.isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber,
                            width: 1,
                          ),
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
                              'Captain',
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
                Row(
                  children: [
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
                        _getPositionFullName(player.position),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${player.jerseyNumber}',
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

  String _getPositionFullName(String position) {
    switch (position) {
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

  // Helper Widgets
  Widget _buildInfoCard({
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
                child: Icon(icon, color: Colors.white, size: 20),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfoBox({
    required String teamName,
    required String players,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    players,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'খেলোয়াড়',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            location,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    String winner = widget.match.scoreA > widget.match.scoreB
        ? widget.match.teamA
        : widget.match.scoreB > widget.match.scoreA
        ? widget.match.teamB
        : 'Draw';

    if (winner == 'Draw') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C757D), Color(0xFF495057)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake, color: Colors.white, size: 30),
            SizedBox(width: 12),
            Text(
              'ম্যাচ ড্র',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28A745), Color(0xFF20C997)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28A745).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Column(
            children: [
              const Text(
                'বিজয়ী',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                winner.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String logoUrl, {double size = 80}) {
    if (logoUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF0F3460),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
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
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'live':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      case 'finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'live':
        return '🔴 লাইভ চলছে';
      case 'upcoming':
        return '📅 আসন্ন ম্যাচ';
      case 'finished':
        return '✅ ম্যাচ সমাপ্ত';
      default:
        return status;
    }
  }
}