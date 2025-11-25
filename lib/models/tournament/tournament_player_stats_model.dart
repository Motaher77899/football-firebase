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
    };
  }
}