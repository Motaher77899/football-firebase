import 'package:flutter/material.dart';
import '../models/tournament/tournament_match_model.dart';


// ============================================================================
// TOURNAMENT MATCH TIMELINE WIDGET
// ============================================================================
class TournamentMatchTimelineWidget extends StatelessWidget {
  final TournamentMatch match;

  const TournamentMatchTimelineWidget({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (match.timeline.isEmpty) {
      return _buildEmptyState();
    }

    // Sort timeline by minute
    final sortedTimeline = List<TimelineEvent>.from(match.timeline);
    sortedTimeline.sort((a, b) => a.minute.compareTo(b.minute));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedTimeline.length,
      itemBuilder: (context, index) {
        final event = sortedTimeline[index];
        final isTeamA = event.team == 'A';

        return _buildTimelineEvent(event, isTeamA);
      },
    );
  }

  Widget _buildTimelineEvent(TimelineEvent event, bool isTeamA) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side (Team A events)
          if (isTeamA) ...[
            Expanded(
              child: _buildEventCard(event, isLeft: true),
            ),
            const SizedBox(width: 8),
          ] else ...[
            const Expanded(child: SizedBox()),
            const SizedBox(width: 8),
          ],

          // Center timeline badge
          _buildTimelineBadge(event),

          // Right side (Team B events)
          if (!isTeamA) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _buildEventCard(event, isLeft: false),
            ),
          ] else ...[
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineBadge(TimelineEvent event) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: event.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: event.color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(event.icon, color: Colors.white, size: 18),
              Text(
                event.displayMinute,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 2,
          height: 20,
          color: event.color.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildEventCard(TimelineEvent event, {required bool isLeft}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeft ? 4 : 12),
          topRight: Radius.circular(isLeft ? 12 : 4),
          bottomLeft: Radius.circular(isLeft ? 4 : 12),
          bottomRight: Radius.circular(isLeft ? 12 : 4),
        ),
        border: Border.all(
          color: event.color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          // Player name
          Text(
            event.playerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: isLeft ? TextAlign.left : TextAlign.right,
          ),

          const SizedBox(height: 4),

          // Event type
          Text(
            event.typeInBengali,
            style: TextStyle(
              color: event.color,
              fontSize: 12,
            ),
          ),

          // Goal specific details
          if (event.type == 'goal') ...[
            if (event.assistPlayerName != null &&
                event.assistPlayerName!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports_handball,
                    color: Colors.white54,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'অ্যাসিস্ট: ${event.assistPlayerName}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                      textAlign: isLeft ? TextAlign.left : TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ],

          // Substitution details
          if (event.type == 'substitution') ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.redAccent,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    event.playerOutName ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    textAlign: isLeft ? TextAlign.left : TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.greenAccent,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    event.playerInName ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    textAlign: isLeft ? TextAlign.left : TextAlign.right,
                  ),
                ),
              ],
            ),
          ],

          // Details
          if (event.details.isNotEmpty && event.details != event.type) ...[
            const SizedBox(height: 4),
            Text(
              event.details,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.timeline,
            size: 80,
            color: Colors.white24,
          ),
          SizedBox(height: 16),
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
}

// ============================================================================
// TIMELINE STATS SUMMARY WIDGET
// ============================================================================
class TournamentMatchTimelineStats extends StatelessWidget {
  final TournamentMatch match;

  const TournamentMatchTimelineStats({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (match.timeline.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate stats
    int goals = 0;
    int yellowCards = 0;
    int redCards = 0;
    int substitutions = 0;

    for (var event in match.timeline) {
      switch (event.type) {
        case 'goal':
          goals++;
          break;
        case 'yellow_card':
          yellowCards++;
          break;
        case 'red_card':
          redCards++;
          break;
        case 'substitution':
          substitutions++;
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.sports_soccer,
            label: 'গোল',
            value: goals,
            color: const Color(0xFF4CAF50),
          ),
          _buildStatItem(
            icon: Icons.credit_card,
            label: 'হলুদ',
            value: yellowCards,
            color: const Color(0xFFFFC107),
          ),
          _buildStatItem(
            icon: Icons.credit_card,
            label: 'লাল',
            value: redCards,
            color: const Color(0xFFF44336),
          ),
          _buildStatItem(
            icon: Icons.swap_horiz,
            label: 'সাব',
            value: substitutions,
            color: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
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
}