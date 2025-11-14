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

  int get goalDifference => goalsFor - goalsAgainst;
}