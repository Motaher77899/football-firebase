import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRanking {
  final String playerId;
  final String playerName;
  final String playerPhoto;
  final String position;
  final String upazila;
  final int points;
  final int matchesPlayed;
  final int goals;
  final int assists;
  final int cleanSheets;
  final int yellowCards;
  final int redCards;
  final DateTime? updatedAt;

  PlayerRanking({
    required this.playerId,
    required this.playerName,
    this.playerPhoto = '',
    this.position = '',
    this.upazila = '',
    required this.points,
    required this.matchesPlayed,
    required this.goals,
    required this.assists,
    required this.cleanSheets,
    this.yellowCards = 0,
    this.redCards = 0,
    this.updatedAt,
  });

  factory PlayerRanking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlayerRanking(
      playerId: doc.id,
      playerName: data['playerName'] ?? '',
      playerPhoto: data['playerPhoto'] ?? '',
      position: data['position'] ?? '',
      upazila: data['upazila'] ?? '',
      points: data['points'] ?? 0,
      matchesPlayed: data['matchesPlayed'] ?? 0,
      goals: data['goals'] ?? 0,
      assists: data['assists'] ?? 0,
      cleanSheets: data['cleanSheets'] ?? 0,
      yellowCards: data['yellowCards'] ?? 0,
      redCards: data['redCards'] ?? 0,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}