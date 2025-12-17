import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchLineupsTab extends StatelessWidget {
  final String matchId;

  const MatchLineupsTab({Key? key, required this.matchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final lineups = data['lineups'] ?? {};

        final teamA = List<String>.from(lineups['teamA'] ?? []);
        final teamB = List<String>.from(lineups['teamB'] ?? []);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: _buildTeamList("Team A", teamA)),
              const SizedBox(width: 16),
              Expanded(child: _buildTeamList("Team B", teamB)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeamList(String teamName, List<String> players) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(teamName,
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const Divider(color: Colors.white24),
          ...players.map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(p,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14)),
          )),
        ],
      ),
    );
  }
}
