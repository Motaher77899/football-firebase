import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================================
// TOURNAMENT MODEL
// ============================================================================
class Tournament {
  final String id;
  final String name;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'upcoming', 'ongoing', 'completed'
  final String imageUrl;
  final int totalTeams;
  final String prizePool;
  final String organizerName;
  final String organizerContact;
  final DateTime createdAt;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.imageUrl = '',
    required this.totalTeams,
    this.prizePool = '',
    required this.organizerName,
    this.organizerContact = '',
    required this.createdAt,
  });

  factory Tournament.fromMap(Map<String, dynamic> map, String id) {
    return Tournament(
      id: id,
      name: _parseString(map['name']),
      description: _parseString(map['description']),
      location: _parseString(map['location']),
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      status: _parseString(map['status'], defaultValue: 'upcoming'),
      imageUrl: _parseString(map['imageUrl']),
      totalTeams: _parseInt(map['totalTeams']),
      prizePool: _parseString(map['prizePool']),
      organizerName: _parseString(map['organizerName']),
      organizerContact: _parseString(map['organizerContact']),
      createdAt: _parseDate(map['createdAt']),
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

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is Timestamp) return date.toDate();
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
      'totalTeams': totalTeams,
      'prizePool': prizePool,
      'organizerName': organizerName,
      'organizerContact': organizerContact,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get statusInBengali {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'ongoing':
        return 'চলমান';
      case 'completed':
        return 'সমাপ্ত';
      default:
        return 'অজানা';
    }
  }
}

// ============================================================================
// TOURNAMENT MATCH MODEL
// ============================================================================
class TournamentMatch {
  final String id;
  final String tournamentId;
  final String homeTeamId;
  final String awayTeamId;
  final int homeScore;
  final int awayScore;
  final String status; // 'upcoming', 'live', 'completed', 'finished'
  final DateTime matchDate;
  final String matchTime;
  final String venue;
  final String round; // 'Group A - Match Day 1', 'Semi Final', etc.

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

  factory TournamentMatch.fromMap(Map<String, dynamic> map, String id) {
    return TournamentMatch(
      id: id,
      tournamentId: map['tournamentId'] ?? '',
      // Support both naming conventions
      homeTeamId: map['homeTeamId'] ?? map['teamAId'] ?? '',
      awayTeamId: map['awayTeamId'] ?? map['teamBId'] ?? '',
      homeScore: map['homeScore'] ?? map['scoreA'] ?? 0,
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

// ============================================================================
// TOURNAMENT PLAYER STATS MODEL
// ============================================================================
class TournamentPlayerStats {
  final String id;
  final String tournamentId;
  final String playerId;
  final String playerName;
  final String playerPhoto;
  final String teamId;
  final String teamName;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final int matchesPlayed;
  final int cleanSheets;
  final String position;

  TournamentPlayerStats({
    required this.id,
    required this.tournamentId,
    required this.playerId,
    required this.playerName,
    this.playerPhoto = '',
    required this.teamId,
    required this.teamName,
    this.goals = 0,
    this.assists = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.matchesPlayed = 0,
    this.cleanSheets = 0,
    this.position = '',
  });

  factory TournamentPlayerStats.fromMap(Map<String, dynamic> map, String id) {
    return TournamentPlayerStats(
      id: id,
      tournamentId: _parseString(map['tournamentId']),
      playerId: _parseString(map['playerId']),
      playerName: _parseString(map['playerName']),
      playerPhoto: _parseString(map['playerPhoto']),
      teamId: _parseString(map['teamId']),
      teamName: _parseString(map['teamName']),
      goals: _parseInt(map['goals']),
      assists: _parseInt(map['assists']),
      yellowCards: _parseInt(map['yellowCards']),
      redCards: _parseInt(map['redCards']),
      matchesPlayed: _parseInt(map['matchesPlayed']),
      cleanSheets: _parseInt(map['cleanSheets']),
      position: _parseString(map['position']),
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

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'playerId': playerId,
      'playerName': playerName,
      'playerPhoto': playerPhoto,
      'teamId': teamId,
      'teamName': teamName,
      'goals': goals,
      'assists': assists,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'matchesPlayed': matchesPlayed,
      'cleanSheets': cleanSheets,
      'position': position,
    };
  }

  // Performance score calculation
  double get performanceScore {
    return (goals * 3.0) +
        (assists * 2.0) -
        (yellowCards * 0.5) -
        (redCards * 2.0);
  }
}

// ============================================================================
// TOURNAMENT TEAM STATS MODEL
// ============================================================================
class TournamentTeamStats {
  final String id;
  final String tournamentId;
  final String teamId;
  final String teamName;
  final String teamLogo;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final String group; // 'Group A', 'Group B', etc.

  TournamentTeamStats({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.teamName,
    this.teamLogo = '',
    this.matchesPlayed = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
    this.group = '',
  });

  factory TournamentTeamStats.fromMap(Map<String, dynamic> map, String id) {
    return TournamentTeamStats(
      id: id,
      tournamentId: _parseString(map['tournamentId']),
      teamId: _parseString(map['teamId']),
      teamName: _parseString(map['teamName']),
      teamLogo: _parseString(map['teamLogo']),
      matchesPlayed: _parseInt(map['matchesPlayed']),
      wins: _parseInt(map['wins']),
      draws: _parseInt(map['draws']),
      losses: _parseInt(map['losses']),
      goalsFor: _parseInt(map['goalsFor']),
      goalsAgainst: _parseInt(map['goalsAgainst']),
      points: _parseInt(map['points']),
      group: _parseString(map['group']),
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

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'teamId': teamId,
      'teamName': teamName,
      'teamLogo': teamLogo,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
      'group': group,
    };
  }

  // Calculated properties
  int get goalDifference => goalsFor - goalsAgainst;

  double get winPercentage {
    if (matchesPlayed == 0) return 0.0;
    return (wins / matchesPlayed) * 100;
  }

  double get goalsForAverage {
    if (matchesPlayed == 0) return 0.0;
    return goalsFor / matchesPlayed;
  }

  double get goalsAgainstAverage {
    if (matchesPlayed == 0) return 0.0;
    return goalsAgainst / matchesPlayed;
  }
}