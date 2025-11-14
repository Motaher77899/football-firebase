import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import '../providers/team_provider.dart';

class MatchInfoTab extends StatelessWidget {
  final MatchModel match;
  final TeamProvider teamProvider;

  const MatchInfoTab({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: "তারিখ",
            value: DateFormat('EEEE, dd MMM yyyy').format(match.date),
          ),
          _buildInfoCard(
            icon: Icons.access_time,
            title: "সময়",
            value: DateFormat('hh:mm a').format(match.time),
          ),
          if (match.venue != null)
            _buildInfoCard(
              icon: Icons.stadium,
              title: "স্টেডিয়াম",
              value: match.venue!,
            ),
          if (match.tournament != null)
            _buildInfoCard(
              icon: Icons.emoji_events,
              title: "টুর্নামেন্ট",
              value: match.tournament!,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
