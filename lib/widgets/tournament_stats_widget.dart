import 'package:flutter/material.dart';

class TournamentStatsWidget extends StatelessWidget {
  final int totalTeams;
  final int totalMatches;
  final int liveMatches;
  final int completedMatches;

  const TournamentStatsWidget({
    Key? key,
    required this.totalTeams,
    required this.totalMatches,
    required this.liveMatches,
    required this.completedMatches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.groups,
            label: 'টিম',
            value: totalTeams.toString(),
            color: const Color(0xFF00D9FF),
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.sports_soccer,
            label: 'ম্যাচ',
            value: totalMatches.toString(),
            color: const Color(0xFFFF6B6B),
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.play_circle_filled,
            label: 'লাইভ',
            value: liveMatches.toString(),
            color: Colors.red,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'সমাপ্ত',
            value: completedMatches.toString(),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.white24,
    );
  }
}