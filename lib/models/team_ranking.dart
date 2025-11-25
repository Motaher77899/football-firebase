import 'package:cloud_firestore/cloud_firestore.dart';

class TeamRanking {
  final String teamId;
  final String teamName;
  final String teamLogo;
  final String upazila;
  final String district;
  final int points;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int yellowCards;
  final int redCards;
  final DateTime? updatedAt;

  TeamRanking({
    required this.teamId,
    required this.teamName,
    this.teamLogo = '',
    this.upazila = '',
    this.district = '',
    required this.points,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    this.yellowCards = 0,
    this.redCards = 0,
    this.updatedAt,
  });

  factory TeamRanking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamRanking(
      teamId: doc.id,
      teamName: data['teamName'] ?? '',
      teamLogo: data['teamLogo'] ?? '',
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      points: data['points'] ?? 0,
      matchesPlayed: data['matchesPlayed'] ?? 0,
      wins: data['wins'] ?? 0,
      draws: data['draws'] ?? 0,
      losses: data['losses'] ?? 0,
      goalsFor: data['goalsFor'] ?? 0,
      goalsAgainst: data['goalsAgainst'] ?? 0,
      goalDifference: data['goalDifference'] ?? 0,
      yellowCards: data['yellowCards'] ?? 0,
      redCards: data['redCards'] ?? 0,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}