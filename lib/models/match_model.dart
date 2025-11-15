//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MatchModel {
//   final String id;
//   final String teamA;
//   final String teamB;
//   final int scoreA;
//   final int scoreB;
//   final DateTime date;
//   final DateTime time;
//   final String status; // live, upcoming, finished
//   final String? tournament;
//   final String? tournamentId;
//   final String? venue;
//   final List<MatchEvent> timeline;
//   final MatchStats? stats;
//   final LineUp? lineUpA;
//   final LineUp? lineUpB;
//   final HeadToHead? h2h;
//
//   MatchModel({
//     required this.id,
//     required this.teamA,
//     required this.teamB,
//     required this.scoreA,
//     required this.scoreB,
//     required this.date,
//     required this.time,
//     required this.status,
//     this.tournament,
//     this.tournamentId,
//     this.venue,
//     this.timeline = const [],
//     this.stats,
//     this.lineUpA,
//     this.lineUpB,
//     this.h2h,
//   });
//
//   factory MatchModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     return MatchModel(
//       id: doc.id,
//       teamA: data['teamA'] ?? '',
//       teamB: data['teamB'] ?? '',
//       scoreA: data['scoreA'] ?? 0,
//       scoreB: data['scoreB'] ?? 0,
//       date: (data['date'] as Timestamp).toDate(),
//       time: (data['time'] as Timestamp).toDate(),
//       status: data['status'] ?? 'upcoming',
//       tournament: data['tournament'],
//       tournamentId: data['tournamentId'],
//       venue: data['venue'],
//       timeline: (data['timeline'] as List<dynamic>?)
//           ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
//           .toList() ?? [],
//       stats: data['stats'] != null
//           ? MatchStats.fromMap(data['stats'] as Map<String, dynamic>)
//           : null,
//       lineUpA: data['lineUpA'] != null
//           ? LineUp.fromMap(data['lineUpA'] as Map<String, dynamic>)
//           : null,
//       lineUpB: data['lineUpB'] != null
//           ? LineUp.fromMap(data['lineUpB'] as Map<String, dynamic>)
//           : null,
//       h2h: data['h2h'] != null
//           ? HeadToHead.fromMap(data['h2h'] as Map<String, dynamic>)
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'teamA': teamA,
//       'teamB': teamB,
//       'scoreA': scoreA,
//       'scoreB': scoreB,
//       'date': Timestamp.fromDate(date),
//       'time': Timestamp.fromDate(time),
//       'status': status,
//       'tournament': tournament,
//       'tournamentId': tournamentId,
//       'venue': venue,
//       'timeline': timeline.map((e) => e.toMap()).toList(),
//       'stats': stats?.toMap(),
//       'lineUpA': lineUpA?.toMap(),
//       'lineUpB': lineUpB?.toMap(),
//       'h2h': h2h?.toMap(),
//     };
//   }
// }
//
// // Timeline Event Model
// class MatchEvent {
//   final String type; // goal, card, substitution
//   final String team; // teamA or teamB
//   final String playerName;
//   final int minute;
//   final String? details; // yellow_card, red_card, player_out, player_in
//
//   MatchEvent({
//     required this.type,
//     required this.team,
//     required this.playerName,
//     required this.minute,
//     this.details,
//   });
//
//   factory MatchEvent.fromMap(Map<String, dynamic> map) {
//     return MatchEvent(
//       type: map['type'] ?? '',
//       team: map['team'] ?? '',
//       playerName: map['playerName'] ?? '',
//       minute: map['minute'] ?? 0,
//       details: map['details'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'type': type,
//       'team': team,
//       'playerName': playerName,
//       'minute': minute,
//       'details': details,
//     };
//   }
// }
//
// // Match Statistics Model
// class MatchStats {
//   final int possessionA;
//   final int possessionB;
//   final int shotsA;
//   final int shotsB;
//   final int shotsOnTargetA;
//   final int shotsOnTargetB;
//   final int cornersA;
//   final int cornersB;
//   final int foulsA;
//   final int foulsB;
//   final int yellowCardsA;
//   final int yellowCardsB;
//   final int redCardsA;
//   final int redCardsB;
//
//   MatchStats({
//     this.possessionA = 50,
//     this.possessionB = 50,
//     this.shotsA = 0,
//     this.shotsB = 0,
//     this.shotsOnTargetA = 0,
//     this.shotsOnTargetB = 0,
//     this.cornersA = 0,
//     this.cornersB = 0,
//     this.foulsA = 0,
//     this.foulsB = 0,
//     this.yellowCardsA = 0,
//     this.yellowCardsB = 0,
//     this.redCardsA = 0,
//     this.redCardsB = 0,
//   });
//
//   factory MatchStats.fromMap(Map<String, dynamic> map) {
//     return MatchStats(
//       possessionA: map['possessionA'] ?? 50,
//       possessionB: map['possessionB'] ?? 50,
//       shotsA: map['shotsA'] ?? 0,
//       shotsB: map['shotsB'] ?? 0,
//       shotsOnTargetA: map['shotsOnTargetA'] ?? 0,
//       shotsOnTargetB: map['shotsOnTargetB'] ?? 0,
//       cornersA: map['cornersA'] ?? 0,
//       cornersB: map['cornersB'] ?? 0,
//       foulsA: map['foulsA'] ?? 0,
//       foulsB: map['foulsB'] ?? 0,
//       yellowCardsA: map['yellowCardsA'] ?? 0,
//       yellowCardsB: map['yellowCardsB'] ?? 0,
//       redCardsA: map['redCardsA'] ?? 0,
//       redCardsB: map['redCardsB'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'possessionA': possessionA,
//       'possessionB': possessionB,
//       'shotsA': shotsA,
//       'shotsB': shotsB,
//       'shotsOnTargetA': shotsOnTargetA,
//       'shotsOnTargetB': shotsOnTargetB,
//       'cornersA': cornersA,
//       'cornersB': cornersB,
//       'foulsA': foulsA,
//       'foulsB': foulsB,
//       'yellowCardsA': yellowCardsA,
//       'yellowCardsB': yellowCardsB,
//       'redCardsA': redCardsA,
//       'redCardsB': redCardsB,
//     };
//   }
// }
//
// // LineUp Model
// class LineUp {
//   final String formation; // e.g., "4-4-2"
//   final List<PlayerLineUp> players;
//
//   LineUp({
//     required this.formation,
//     required this.players,
//   });
//
//   factory LineUp.fromMap(Map<String, dynamic> map) {
//     return LineUp(
//       formation: map['formation'] ?? '4-4-2',
//       players: (map['players'] as List<dynamic>?)
//           ?.map((e) => PlayerLineUp.fromMap(e as Map<String, dynamic>))
//           .toList() ?? [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'formation': formation,
//       'players': players.map((e) => e.toMap()).toList(),
//     };
//   }
// }
//
// // Player LineUp Model
// class PlayerLineUp {
//   final String playerName;
//   final String playerId;
//   final int jerseyNumber;
//   final String position; // GK, DEF, MID, FWD
//   final bool isCaptain;
//   final bool isSubstitute;
//
//   PlayerLineUp({
//     required this.playerName,
//     required this.playerId,
//     required this.jerseyNumber,
//     required this.position,
//     this.isCaptain = false,
//     this.isSubstitute = false,
//   });
//
//   factory PlayerLineUp.fromMap(Map<String, dynamic> map) {
//     return PlayerLineUp(
//       playerName: map['playerName'] ?? '',
//       playerId: map['playerId'] ?? '',
//       jerseyNumber: map['jerseyNumber'] ?? 0,
//       position: map['position'] ?? 'MID',
//       isCaptain: map['isCaptain'] ?? false,
//       isSubstitute: map['isSubstitute'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'playerName': playerName,
//       'playerId': playerId,
//       'jerseyNumber': jerseyNumber,
//       'position': position,
//       'isCaptain': isCaptain,
//       'isSubstitute': isSubstitute,
//     };
//   }
// }
//
// // Head to Head Model
// class HeadToHead {
//   final int totalMatches;
//   final int teamAWins;
//   final int teamBWins;
//   final int draws;
//   final int teamAGoals;
//   final int teamBGoals;
//
//   HeadToHead({
//     this.totalMatches = 0,
//     this.teamAWins = 0,
//     this.teamBWins = 0,
//     this.draws = 0,
//     this.teamAGoals = 0,
//     this.teamBGoals = 0,
//   });
//
//   factory HeadToHead.fromMap(Map<String, dynamic> map) {
//     return HeadToHead(
//       totalMatches: map['totalMatches'] ?? 0,
//       teamAWins: map['teamAWins'] ?? 0,
//       teamBWins: map['teamBWins'] ?? 0,
//       draws: map['draws'] ?? 0,
//       teamAGoals: map['teamAGoals'] ?? 0,
//       teamBGoals: map['teamBGoals'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalMatches': totalMatches,
//       'teamAWins': teamAWins,
//       'teamBWins': teamBWins,
//       'draws': draws,
//       'teamAGoals': teamAGoals,
//       'teamBGoals': teamBGoals,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final DateTime date;
  final DateTime time;
  final String status; // live, upcoming, finished
  final String? tournament;
  final String? tournamentId;
  final String? venue;
  final List<MatchEvent> timeline;
  final MatchStats? stats;
  final LineUp? lineUpA;
  final LineUp? lineUpB;
  final HeadToHead? h2h;

  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.date,
    required this.time,
    required this.status,
    this.tournament,
    this.tournamentId,
    this.venue,
    this.timeline = const [],
    this.stats,
    this.lineUpA,
    this.lineUpB,
    this.h2h,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return MatchModel(
      id: doc.id,
      teamA: data['teamA'] ?? '',
      teamB: data['teamB'] ?? '',
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      time: (data['time'] as Timestamp).toDate(),
      status: data['status'] ?? 'upcoming',
      tournament: data['tournament'],
      tournamentId: data['tournamentId'],
      venue: data['venue'],
      timeline: (data['timeline'] as List<dynamic>?)
          ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      stats: data['stats'] != null
          ? MatchStats.fromMap(data['stats'] as Map<String, dynamic>)
          : null,
      lineUpA: data['lineUpA'] != null
          ? LineUp.fromMap(data['lineUpA'] as Map<String, dynamic>)
          : null,
      lineUpB: data['lineUpB'] != null
          ? LineUp.fromMap(data['lineUpB'] as Map<String, dynamic>)
          : null,
      h2h: data['h2h'] != null
          ? HeadToHead.fromMap(data['h2h'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
      'status': status,
      'tournament': tournament,
      'tournamentId': tournamentId,
      'venue': venue,
      'timeline': timeline.map((e) => e.toMap()).toList(),
      'stats': stats?.toMap(),
      'lineUpA': lineUpA?.toMap(),
      'lineUpB': lineUpB?.toMap(),
      'h2h': h2h?.toMap(),
    };
  }
}

// Timeline Event Model
class MatchEvent {
  final String type; // goal, card, substitution
  final String team; // teamA or teamB
  final String playerName;
  final int minute;
  final String? details; // yellow_card, red_card, player_out, player_in

  MatchEvent({
    required this.type,
    required this.team,
    required this.playerName,
    required this.minute,
    this.details,
  });

  factory MatchEvent.fromMap(Map<String, dynamic> map) {
    return MatchEvent(
      type: map['type'] ?? '',
      team: map['team'] ?? '',
      playerName: map['playerName'] ?? '',
      minute: map['minute'] ?? 0,
      details: map['details'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'team': team,
      'playerName': playerName,
      'minute': minute,
      'details': details,
    };
  }
}

// Match Statistics Model
class MatchStats {
  final int possessionA;
  final int possessionB;
  final int shotsA;
  final int shotsB;
  final int shotsOnTargetA;
  final int shotsOnTargetB;
  final int cornersA;
  final int cornersB;
  final int foulsA;
  final int foulsB;
  final int yellowCardsA;
  final int yellowCardsB;
  final int redCardsA;
  final int redCardsB;

  MatchStats({
    this.possessionA = 50,
    this.possessionB = 50,
    this.shotsA = 0,
    this.shotsB = 0,
    this.shotsOnTargetA = 0,
    this.shotsOnTargetB = 0,
    this.cornersA = 0,
    this.cornersB = 0,
    this.foulsA = 0,
    this.foulsB = 0,
    this.yellowCardsA = 0,
    this.yellowCardsB = 0,
    this.redCardsA = 0,
    this.redCardsB = 0,
  });

  factory MatchStats.fromMap(Map<String, dynamic> map) {
    return MatchStats(
      possessionA: (map['possessionA'] ?? 50).toInt(),
      possessionB: (map['possessionB'] ?? 50).toInt(),
      shotsA: (map['shotsA'] ?? 0).toInt(),
      shotsB: (map['shotsB'] ?? 0).toInt(),
      shotsOnTargetA: (map['shotsOnTargetA'] ?? 0).toInt(),
      shotsOnTargetB: (map['shotsOnTargetB'] ?? 0).toInt(),
      cornersA: (map['cornersA'] ?? 0).toInt(),
      cornersB: (map['cornersB'] ?? 0).toInt(),
      foulsA: (map['foulsA'] ?? 0).toInt(),
      foulsB: (map['foulsB'] ?? 0).toInt(),
      yellowCardsA: (map['yellowCardsA'] ?? 0).toInt(),
      yellowCardsB: (map['yellowCardsB'] ?? 0).toInt(),
      redCardsA: (map['redCardsA'] ?? 0).toInt(),
      redCardsB: (map['redCardsB'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'possessionA': possessionA,
      'possessionB': possessionB,
      'shotsA': shotsA,
      'shotsB': shotsB,
      'shotsOnTargetA': shotsOnTargetA,
      'shotsOnTargetB': shotsOnTargetB,
      'cornersA': cornersA,
      'cornersB': cornersB,
      'foulsA': foulsA,
      'foulsB': foulsB,
      'yellowCardsA': yellowCardsA,
      'yellowCardsB': yellowCardsB,
      'redCardsA': redCardsA,
      'redCardsB': redCardsB,
    };
  }
}

// LineUp Model
class LineUp {
  final String formation; // e.g., "4-4-2"
  final List<PlayerLineUp> players;

  LineUp({
    required this.formation,
    required this.players,
  });

  factory LineUp.fromMap(Map<String, dynamic> map) {
    return LineUp(
      formation: map['formation'] ?? '4-4-2',
      players: (map['players'] as List<dynamic>?)
          ?.map((e) => PlayerLineUp.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formation': formation,
      'players': players.map((e) => e.toMap()).toList(),
    };
  }
}

// Player LineUp Model
class PlayerLineUp {
  final String playerName;
  final String playerId;
  final int jerseyNumber;
  final String position; // GK, DEF, MID, FWD
  final bool isCaptain;
  final bool isSubstitute;

  PlayerLineUp({
    required this.playerName,
    required this.playerId,
    required this.jerseyNumber,
    required this.position,
    this.isCaptain = false,
    this.isSubstitute = false,
  });

  factory PlayerLineUp.fromMap(Map<String, dynamic> map) {
    return PlayerLineUp(
      playerName: map['playerName'] ?? '',
      playerId: map['playerId'] ?? '',
      jerseyNumber: map['jerseyNumber'] ?? 0,
      position: map['position'] ?? 'MID',
      isCaptain: map['isCaptain'] ?? false,
      isSubstitute: map['isSubstitute'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'playerId': playerId,
      'jerseyNumber': jerseyNumber,
      'position': position,
      'isCaptain': isCaptain,
      'isSubstitute': isSubstitute,
    };
  }
}

// Head to Head Model
class HeadToHead {
  final int totalMatches;
  final int teamAWins;
  final int teamBWins;
  final int draws;
  final int teamAGoals;
  final int teamBGoals;

  HeadToHead({
    this.totalMatches = 0,
    this.teamAWins = 0,
    this.teamBWins = 0,
    this.draws = 0,
    this.teamAGoals = 0,
    this.teamBGoals = 0,
  });

  factory HeadToHead.fromMap(Map<String, dynamic> map) {
    return HeadToHead(
      totalMatches: map['totalMatches'] ?? 0,
      teamAWins: map['teamAWins'] ?? 0,
      teamBWins: map['teamBWins'] ?? 0,
      draws: map['draws'] ?? 0,
      teamAGoals: map['teamAGoals'] ?? 0,
      teamBGoals: map['teamBGoals'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMatches': totalMatches,
      'teamAWins': teamAWins,
      'teamBWins': teamBWins,
      'draws': draws,
      'teamAGoals': teamAGoals,
      'teamBGoals': teamBGoals,
    };
  }
}