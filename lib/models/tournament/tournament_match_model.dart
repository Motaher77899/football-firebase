import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ============================================================================
// TOURNAMENT MATCH MODEL (With Enhanced Timeline Parsing)
// ============================================================================
class TournamentMatch {
  final String id;
  final String tournamentId;
  final String teamAId;
  final String teamBId;
  final int scoreA;
  final int scoreB;
  final String status;
  final String round;
  final String venue;
  final DateTime rankingUpdatedAt;
  final List<TimelineEvent> timeline;

  TournamentMatch({
    required this.id,
    required this.tournamentId,
    required this.teamAId,
    required this.teamBId,
    required this.scoreA,
    required this.scoreB,
    required this.status,
    this.round = '',
    this.venue = '',
    required this.rankingUpdatedAt,
    this.timeline = const [],
  });

  factory TournamentMatch.fromMap(Map<String, dynamic> map, String id) {
    // ✅ Enhanced Timeline Parsing with Debug Prints
    List<TimelineEvent> timelineEvents = [];

    print('🔍 [TournamentMatch] Parsing match: $id');
    print('🔍 [TournamentMatch] Raw data keys: ${map.keys.toList()}');
    print('🔍 [TournamentMatch] Full map: $map');
    print('🔍 [TournamentMatch] Timeline field exists: ${map.containsKey('timeline')}');
    print('🔍 [TournamentMatch] Timeline value: ${map['timeline']}');
    print('🔍 [TournamentMatch] Timeline type: ${map['timeline']?.runtimeType}');

    // Check if timeline exists in the map
    dynamic timelineData = map['timeline'];

    // If timeline is null, check if it's in a nested structure
    if (timelineData == null) {
      print('⚠️ [TournamentMatch] Timeline is null at root level, checking nested...');
      // Sometimes Firebase returns data in weird structures
      if (map['data'] != null && map['data'] is Map) {
        timelineData = (map['data'] as Map)['timeline'];
        print('🔍 [TournamentMatch] Found timeline in data: $timelineData');
      }
    }

    if (timelineData != null) {
      if (map['timeline'] is List) {
        final timelineList = map['timeline'] as List;
        print('✅ [TournamentMatch] Timeline is List with ${timelineList.length} items');

        timelineEvents = timelineList.map((e) {
          print('📝 [TournamentMatch] Parsing event: $e');
          try {
            if (e is Map<String, dynamic>) {
              final event = TimelineEvent.fromMap(e);
              print('✅ [TournamentMatch] Event parsed: ${event.playerName} - ${event.type} - Team: ${event.team}');
              return event;
            } else {
              print('⚠️ [TournamentMatch] Event is not Map<String, dynamic>: ${e.runtimeType}');
              // Convert to Map if it's a different Map type
              final eventMap = Map<String, dynamic>.from(e as Map);
              return TimelineEvent.fromMap(eventMap);
            }
          } catch (e) {
            print('❌ [TournamentMatch] Error parsing event: $e');
            rethrow;
          }
        }).toList();

        print('✅ [TournamentMatch] Total events parsed: ${timelineEvents.length}');
      } else {
        print('⚠️ [TournamentMatch] Timeline is not a List, it is: ${map['timeline'].runtimeType}');
      }
    } else {
      print('⚠️ [TournamentMatch] Timeline field is null');
    }

    return TournamentMatch(
      id: id,
      tournamentId: _parseString(map['tournamentId']),
      teamAId: _parseString(map['teamAId']),
      teamBId: _parseString(map['teamBId']),
      scoreA: _parseInt(map['scoreA']),
      scoreB: _parseInt(map['scoreB']),
      status: _parseString(map['status'], defaultValue: 'upcoming'),
      round: _parseString(map['round']),
      venue: _parseString(map['venue']),
      rankingUpdatedAt: _parseDateTime(map['rankingUpdatedAt']),
      timeline: timelineEvents,
    );
  }

  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
      'teamAId': teamAId,
      'teamBId': teamBId,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status,
      'round': round,
      'venue': venue,
      'rankingUpdatedAt': Timestamp.fromDate(rankingUpdatedAt),
      'timeline': timeline.map((e) => e.toMap()).toList(),
    };
  }

  String get statusInBengali {
    switch (status.toLowerCase()) {
      case 'live':
        return 'লাইভ';
      case 'upcoming':
        return 'আসন্ন';
      case 'finished':
      case 'completed':
        return 'সমাপ্ত';
      default:
        return status;
    }
  }

  // Helper getters
  String get homeTeamId => teamAId;
  String get awayTeamId => teamBId;
  int get homeScore => scoreA;
  int get awayScore => scoreB;
  DateTime get matchDate => rankingUpdatedAt;
  DateTime get matchTime => rankingUpdatedAt;

  TournamentMatch copyWith({
    String? id,
    String? tournamentId,
    String? teamAId,
    String? teamBId,
    int? scoreA,
    int? scoreB,
    String? status,
    String? round,
    String? venue,
    DateTime? rankingUpdatedAt,
    List<TimelineEvent>? timeline,
  }) {
    return TournamentMatch(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      status: status ?? this.status,
      round: round ?? this.round,
      venue: venue ?? this.venue,
      rankingUpdatedAt: rankingUpdatedAt ?? this.rankingUpdatedAt,
      timeline: timeline ?? this.timeline,
    );
  }
}

// ============================================================================
// TIMELINE EVENT MODEL (Enhanced with Debug Prints)
// ============================================================================
class TimelineEvent {
  final int minute;
  final String playerId;
  final String playerName;
  final String team;
  final String type;
  final String details;

  // Goal specific
  final String? assistPlayerId;
  final String? assistPlayerName;
  final String? goalType;

  // Substitution specific
  final String? playerOutId;
  final String? playerOutName;
  final String? playerInId;
  final String? playerInName;

  TimelineEvent({
    required this.minute,
    required this.playerId,
    required this.playerName,
    required this.team,
    required this.type,
    this.details = '',
    this.assistPlayerId,
    this.assistPlayerName,
    this.goalType,
    this.playerOutId,
    this.playerOutName,
    this.playerInId,
    this.playerInName,
  });

  factory TimelineEvent.fromMap(Map<String, dynamic> map) {
    print('🔍 [TimelineEvent] Parsing event map: $map');

    final minute = map['minute'] ?? 0;
    final playerId = map['playerId'] ?? '';
    final playerName = map['playerName'] ?? '';
    final team = map['team'] ?? '';
    final type = map['type'] ?? '';

    print('📊 [TimelineEvent] Parsed values:');
    print('   - minute: $minute');
    print('   - playerId: $playerId');
    print('   - playerName: $playerName');
    print('   - team: $team');
    print('   - type: $type');

    if (team.isEmpty) {
      print('⚠️ [TimelineEvent] WARNING: team field is EMPTY!');
    }
    if (type.isEmpty) {
      print('⚠️ [TimelineEvent] WARNING: type field is EMPTY!');
    }

    return TimelineEvent(
      minute: minute is int ? minute : int.tryParse(minute.toString()) ?? 0,
      playerId: playerId.toString(),
      playerName: playerName.toString(),
      team: team.toString(),
      type: type.toString(),
      details: map['details']?.toString() ?? '',
      assistPlayerId: map['assistPlayerId']?.toString(),
      assistPlayerName: map['assistPlayerName']?.toString(),
      goalType: map['goalType']?.toString(),
      playerOutId: map['playerOutId']?.toString(),
      playerOutName: map['playerOutName']?.toString(),
      playerInId: map['playerInId']?.toString(),
      playerInName: map['playerInName']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'minute': minute,
      'playerId': playerId,
      'playerName': playerName,
      'team': team,
      'type': type,
      'details': details,
    };

    if (assistPlayerId != null) map['assistPlayerId'] = assistPlayerId;
    if (assistPlayerName != null) map['assistPlayerName'] = assistPlayerName;
    if (goalType != null) map['goalType'] = goalType;
    if (playerOutId != null) map['playerOutId'] = playerOutId;
    if (playerOutName != null) map['playerOutName'] = playerOutName;
    if (playerInId != null) map['playerInId'] = playerInId;
    if (playerInName != null) map['playerInName'] = playerInName;

    return map;
  }

  String get typeInBengali {
    switch (type.toLowerCase()) {
      case 'goal':
        return 'গোল';
      case 'yellow_card':
        return 'হলুদ কার্ড';
      case 'red_card':
        return 'লাল কার্ড';
      case 'substitution':
        return 'প্রতিস্থাপন';
      default:
        return type;
    }
  }

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'goal':
        return Icons.sports_soccer;
      case 'yellow_card':
      case 'red_card':
        return Icons.credit_card;
      case 'substitution':
        return Icons.swap_horiz;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (type.toLowerCase()) {
      case 'goal':
        return const Color(0xFF4CAF50);
      case 'yellow_card':
        return const Color(0xFFFFC107);
      case 'red_card':
        return const Color(0xFFF44336);
      case 'substitution':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  String get displayMinute => "$minute'";
}