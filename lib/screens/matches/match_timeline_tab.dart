import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchTimelineTab extends StatelessWidget {
  final String matchId;

  const MatchTimelineTab({Key? key, required this.matchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .collection('timeline')
          .orderBy('minute')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        final events = snapshot.data!.docs;

        if (events.isEmpty) {
          return const Center(
            child: Text('No timeline events yet.',
                style: TextStyle(color: Colors.white70)),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final event = events[index];
            final data = event.data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getEventColor(data['event']),
                child: Icon(_getEventIcon(data['event']),
                    color: Colors.white, size: 18),
              ),
              title: Text(
                "${data['player'] ?? 'Unknown Player'} (${data['team']})",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              subtitle: Text("${data['minute']}' minute",
                  style: const TextStyle(color: Colors.white70)),
            );
          },
        );
      },
    );
  }

  IconData _getEventIcon(String event) {
    switch (event) {
      case 'goal':
        return Icons.sports_soccer;
      case 'yellow_card':
        return Icons.square;
      case 'red_card':
        return Icons.crop_square;
      case 'substitution':
        return Icons.compare_arrows;
      default:
        return Icons.info_outline;
    }
  }

  Color _getEventColor(String event) {
    switch (event) {
      case 'goal':
        return Colors.greenAccent;
      case 'yellow_card':
        return Colors.amber;
      case 'red_card':
        return Colors.redAccent;
      case 'substitution':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
