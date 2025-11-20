import 'package:cloud_firestore/cloud_firestore.dart';
class TeamRanking {
  final String teamId;
  final String teamName;
  final String? teamLogo;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;
  final int yellowCards;
  final int redCards;
  final DateTime lastUpdated;

  TeamRanking({
    required this.teamId,
    required this.teamName,
    this.teamLogo,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
    this.yellowCards = 0,
    this.redCards = 0,
    required this.lastUpdated,
  });

  factory TeamRanking.fromMap(Map<String, dynamic> map, String id) {
    return TeamRanking(
      teamId: id,
      teamName: map['teamName'] ?? '',
      teamLogo: map['teamLogo'],
      matchesPlayed: map['matchesPlayed'] ?? 0,
      wins: map['wins'] ?? 0,
      draws: map['draws'] ?? 0,
      losses: map['losses'] ?? 0,
      goalsFor: map['goalsFor'] ?? 0,
      goalsAgainst: map['goalsAgainst'] ?? 0,
      goalDifference: map['goalDifference'] ?? 0,
      points: map['points'] ?? 0,
      yellowCards: map['yellowCards'] ?? 0,
      redCards: map['redCards'] ?? 0,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
      'teamLogo': teamLogo,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'goalDifference': goalDifference,
      'points': points,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}