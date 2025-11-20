import 'package:cloud_firestore/cloud_firestore.dart';
class PlayerRanking {
  final String playerId;
  final String playerName;
  final String? playerPhoto;
  final String teamId;
  final String teamName;
  final String position;
  final int goals;
  final int assists;
  final int cleanSheets;
  final int yellowCards;
  final int redCards;
  final int totalPoints;
  final int matchesPlayed;
  final DateTime lastUpdated;

  PlayerRanking({
    required this.playerId,
    required this.playerName,
    this.playerPhoto,
    required this.teamId,
    required this.teamName,
    required this.position,
    required this.goals,
    required this.assists,
    required this.cleanSheets,
    required this.yellowCards,
    required this.redCards,
    required this.totalPoints,
    required this.matchesPlayed,
    required this.lastUpdated,
  });

  factory PlayerRanking.fromMap(Map<String, dynamic> map, String id) {
    return PlayerRanking(
      playerId: id,
      playerName: map['playerName'] ?? '',
      playerPhoto: map['playerPhoto'],
      teamId: map['teamId'] ?? '',
      teamName: map['teamName'] ?? '',
      position: map['position'] ?? '',
      goals: map['goals'] ?? 0,
      assists: map['assists'] ?? 0,
      cleanSheets: map['cleanSheets'] ?? 0,
      yellowCards: map['yellowCards'] ?? 0,
      redCards: map['redCards'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      matchesPlayed: map['matchesPlayed'] ?? 0,
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'playerPhoto': playerPhoto,
      'teamId': teamId,
      'teamName': teamName,
      'position': position,
      'goals': goals,
      'assists': assists,
      'cleanSheets': cleanSheets,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'totalPoints': totalPoints,
      'matchesPlayed': matchesPlayed,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // Calculate points based on stats
  static int calculatePoints({
    required int goals,
    required int assists,
    required int cleanSheets,
    required int yellowCards,
    required int redCards,
  }) {
    return (goals * 3) +
        (assists * 2) +
        (cleanSheets * 1) -
        (yellowCards * 1) -
        (redCards * 3);
  }
}