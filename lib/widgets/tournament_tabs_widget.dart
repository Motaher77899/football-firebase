import 'package:flutter/material.dart';
import 'tournament_match_item_widget.dart';
import 'tournament_team_item_widget.dart';

class TournamentTabsWidget extends StatefulWidget {
  final List matches;
  final List teams;

  const TournamentTabsWidget({
    Key? key,
    required this.matches,
    required this.teams,
  }) : super(key: key);

  @override
  State<TournamentTabsWidget> createState() => _TournamentTabsWidgetState();
}

class _TournamentTabsWidgetState extends State<TournamentTabsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF00D9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'ম্যাচসমূহ'),
              Tab(text: 'টিমসমূহ'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMatchesTab(),
              _buildTeamsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchesTab() {
    if (widget.matches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer,
              size: 60,
              color: Colors.white30,
            ),
            SizedBox(height: 16),
            Text(
              'কোন ম্যাচ নেই',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.matches.length,
      itemBuilder: (context, index) {
        final match = widget.matches[index];
        return TournamentMatchItemWidget(match: match);
      },
    );
  }

  Widget _buildTeamsTab() {
    if (widget.teams.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 60,
              color: Colors.white30,
            ),
            SizedBox(height: 16),
            Text(
              'কোন টিম নেই',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: widget.teams.length,
      itemBuilder: (context, index) {
        final team = widget.teams[index];
        return TournamentTeamItemWidget(team: team);
      },
    );
  }
}