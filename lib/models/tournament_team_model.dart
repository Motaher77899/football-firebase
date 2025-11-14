class TournamentTeam {
  final String id;
  final String tournamentId;
  final String teamId;
  final String teamName;
  final String teamLogo;
  final String group; // 'Group A', 'Group B', etc. (optional)
  final int seedNumber; // Seeding number (optional)

  TournamentTeam({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.teamName,
    this.teamLogo = '',
    this.group = '',
    this.seedNumber = 0,
  });

  factory TournamentTeam.fromMap(Map<String, dynamic> map, String id) {
    return TournamentTeam(
      id: id,
      tournamentId: _parseString(map['tournamentId']),
      teamId: _parseString(map['teamId']),
      teamName: _parseString(map['teamName']),
      teamLogo: _parseString(map['teamLogo']),
      group: _parseString(map['group']),
      seedNumber: _parseInt(map['seedNumber']),
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
      'group': group,
      'seedNumber': seedNumber,
    };
  }
}