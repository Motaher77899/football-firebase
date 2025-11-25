
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentMatch {
  final String id;
  final String tournamentId;
  final String homeTeamId;      // ✅ Team ID (supports both homeTeamId and teamAId)
  final String awayTeamId;      // ✅ Team ID (supports both awayTeamId and teamBId)
  final int homeScore;
  final int awayScore;
  final String status;          // 'upcoming', 'live', 'completed'
  final DateTime matchDate;
  final String matchTime;
  final String venue;
  final String round;           // 'Group A - Match Day 1', 'Semi Final', etc.

  TournamentMatch({
    required this.id,
    required this.tournamentId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.matchDate,
    required this.matchTime,
    required this.venue,
    required this.round,
  });

  // ✅ Updated factory to support BOTH field naming conventions
  factory TournamentMatch.fromMap(Map<String, dynamic> map, String id) {
    return TournamentMatch(
      id: id,
      tournamentId: map['tournamentId'] ?? '',
      // ✅ Support both homeTeamId and teamAId
      homeTeamId: map['homeTeamId'] ?? map['teamAId'] ?? '',
      // ✅ Support both awayTeamId and teamBId
      awayTeamId: map['awayTeamId'] ?? map['teamBId'] ?? '',
      // ✅ Support both homeScore and scoreA
      homeScore: map['homeScore'] ?? map['scoreA'] ?? 0,
      // ✅ Support both awayScore and scoreB
      awayScore: map['awayScore'] ?? map['scoreB'] ?? 0,
      status: map['status'] ?? 'upcoming',
      matchDate: _parseDateTime(map['matchDate']),
      matchTime: map['matchTime'] ?? '',
      venue: map['venue'] ?? '',
      round: map['round'] ?? '',
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'status': status,
      'matchDate': Timestamp.fromDate(matchDate),
      'matchTime': matchTime,
      'venue': venue,
      'round': round,
    };
  }

  String get statusInBengali {
    switch (status) {
      case 'live':
        return 'লাইভ';
      case 'upcoming':
        return 'আসন্ন';
      case 'completed':
      case 'finished':
        return 'সমাপ্ত';
      default:
        return status;
    }
  }

  TournamentMatch copyWith({
    String? id,
    String? tournamentId,
    String? homeTeamId,
    String? awayTeamId,
    int? homeScore,
    int? awayScore,
    String? status,
    DateTime? matchDate,
    String? matchTime,
    String? venue,
    String? round,
  }) {
    return TournamentMatch(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      matchDate: matchDate ?? this.matchDate,
      matchTime: matchTime ?? this.matchTime,
      venue: venue ?? this.venue,
      round: round ?? this.round,
    );
  }
}