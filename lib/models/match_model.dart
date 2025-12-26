
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  // এগুলি মূলত ডিসপ্লে নাম হিসেবে ব্যবহৃত হবে
  final String teamA;
  final String teamB;
  // এগুলি রেফারেন্স আইডি (যেমন: dhamrai) হিসেবে ব্যবহৃত হবে
  final String teamAId;
  final String teamBId;
  final String? teamALogo;
  final String? teamBLogo;
  final int scoreA;
  final int scoreB;
  final DateTime date;
  final DateTime time;
  final String status;
  final String? venue;
  final String adminFullName;
  final DateTime createdAt;
  final List<MatchEvent> timeline;
  final MatchStats? stats;
  final LineUp? lineUpA;
  final LineUp? lineUpB;
  final String? tournament;
  final String? tournamentId;
  final HeadToHead? h2h;

  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.teamAId,
    required this.teamBId,
    this.teamALogo,
    this.teamBLogo,
    required this.scoreA,
    required this.scoreB,
    required this.date,
    required this.time,
    required this.status,
    this.venue,
    required this.adminFullName,
    required this.createdAt,
    this.timeline = const [],
    this.stats,
    this.lineUpA,
    this.lineUpB,
    this.tournament,
    this.tournamentId,
    this.h2h,
  });

  // ✅ copyWith মেথড যোগ করা হয়েছে যা প্রোভাইডারের এররগুলো ফিক্স করবে
  MatchModel copyWith({
    String? status,
    int? scoreA,
    int? scoreB,
    MatchStats? stats,
    String? venue,
    List<MatchEvent>? timeline,
    LineUp? lineUpA,
    LineUp? lineUpB,
    HeadToHead? h2h,
  }) {
    return MatchModel(
      id: id,
      teamA: teamA,
      teamB: teamB,
      teamAId: teamAId,
      teamBId: teamBId,
      teamALogo: teamALogo,
      teamBLogo: teamBLogo,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      date: date,
      time: time,
      status: status ?? this.status,
      venue: venue ?? this.venue,
      adminFullName: adminFullName,
      createdAt: createdAt,
      timeline: timeline ?? this.timeline,
      stats: stats ?? this.stats,
      lineUpA: lineUpA ?? this.lineUpA,
      lineUpB: lineUpB ?? this.lineUpB,
      tournament: tournament,
      tournamentId: tournamentId,
      h2h: h2h ?? this.h2h,
    );
  }

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // টিম আইডি এবং নাম চেনার জন্য শক্তিশালী লজিক
    // teamAId না থাকলে পুরাতন teamA ফিল্ড থেকে আইডি নেওয়ার চেষ্টা করবে
    String tAId = data['teamAId'] ?? data['teamA'] ?? '';
    String tBId = data['teamBId'] ?? data['teamB'] ?? '';

    // teamAName না থাকলে teamA ফিল্ড থেকে নাম নেওয়ার চেষ্টা করবে
    String tAName = data['teamAName'] ?? data['teamA'] ?? 'Team A';
    String tBName = data['teamBName'] ?? data['teamB'] ?? 'Team B';

    return MatchModel(
      id: doc.id,
      teamAId: tAId,
      teamBId: tBId,
      teamA: tAName,
      teamB: tBName,
      teamALogo: data['teamALogo'],
      teamBLogo: data['teamBLogo'],
      scoreA: (data['scoreA'] ?? 0).toInt(),
      scoreB: (data['scoreB'] ?? 0).toInt(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'upcoming',
      venue: data['venue'],
      adminFullName: data['adminFullName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      timeline: (data['timeline'] as List? ?? [])
          .map((e) => MatchEvent.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      stats: data['stats'] != null ? MatchStats.fromMap(Map<String, dynamic>.from(data['stats'])) : null,
      lineUpA: data['lineUpA'] != null
          ? LineUp.fromMap(Map<String, dynamic>.from(data['lineUpA']))
          : null,
      lineUpB: data['lineUpB'] != null
          ? LineUp.fromMap(Map<String, dynamic>.from(data['lineUpB']))
          : null,
      tournament: data['tournament'],
      tournamentId: data['tournamentId'],
      h2h: data['h2h'] != null ? HeadToHead.fromMap(Map<String, dynamic>.from(data['h2h'])) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamA': teamA, // Display Name
      'teamB': teamB, // Display Name
      'teamAId': teamAId, // Reference ID (dhamrai)
      'teamBId': teamBId, // Reference ID
      'teamAName': teamA, // Compatibility for older versions
      'teamBName': teamB,
      'teamALogo': teamALogo,
      'teamBLogo': teamBLogo,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
      'status': status,
      'venue': venue,
      'adminFullName': adminFullName,
      'createdAt': Timestamp.fromDate(createdAt),
      'timeline': timeline.map((e) => e.toMap()).toList(),
      'stats': stats?.toMap(),
      'lineUpA': lineUpA?.toMap(),
      'lineUpB': lineUpB?.toMap(),
      'tournament': tournament,
      'tournamentId': tournamentId,
      'h2h': h2h?.toMap(),
    };
  }

}

class MatchStats {
  final int shotsA,
      shotsB,
      shotsOnTargetA,
      shotsOnTargetB,
      cornersA,
      cornersB,
      foulsA,
      foulsB,
      yellowCardsA,
      yellowCardsB,
      redCardsA,
      redCardsB,
      possessionA,
      possessionB; // ✅ possession যোগ করুন

  MatchStats({
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
    this.possessionA = 50, // ✅ ডিফল্ট ভ্যালু দিন
    this.possessionB = 50, // ✅ ডিফল্ট ভ্যালু দিন
  });

  factory MatchStats.fromMap(Map<String, dynamic> map) => MatchStats(
    shotsA: map['shotsA'] ?? 0, shotsB: map['shotsB'] ?? 0,
    shotsOnTargetA: map['shotsOnTargetA'] ?? 0,
    shotsOnTargetB: map['shotsOnTargetB'] ?? 0,
    cornersA: map['cornersA'] ?? 0, cornersB: map['cornersB'] ?? 0,
    foulsA: map['foulsA'] ?? 0, foulsB: map['foulsB'] ?? 0,
    yellowCardsA: map['yellowCardsA'] ?? 0,
    yellowCardsB: map['yellowCardsB'] ?? 0,
    redCardsA: map['redCardsA'] ?? 0, redCardsB: map['redCardsB'] ?? 0,
    possessionA: map['possessionA'] ?? 50, // ✅ ম্যাপ থেকে লোড করুন
    possessionB: map['possessionB'] ?? 50,
  );

  Map<String, dynamic> toMap() => {
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
    'possessionA': possessionA,
    'possessionB': possessionB,
  };

  MatchStats copyWith({
    int? shotsA,
    int? shotsB,
    int? shotsOnTargetA,
    int? shotsOnTargetB,
    int? cornersA,
    int? cornersB,
    int? foulsA,
    int? foulsB,
    int? yellowCardsA,
    int? yellowCardsB,
    int? redCardsA,
    int? redCardsB,
    int? possessionA,
    int? possessionB, // ✅ copyWith এ যোগ করুন
  }) {
    return MatchStats(
      shotsA: shotsA ?? this.shotsA, shotsB: shotsB ?? this.shotsB,
      shotsOnTargetA: shotsOnTargetA ?? this.shotsOnTargetA,
      shotsOnTargetB: shotsOnTargetB ?? this.shotsOnTargetB,
      cornersA: cornersA ?? this.cornersA, cornersB: cornersB ?? this.cornersB,
      foulsA: foulsA ?? this.foulsA, foulsB: foulsB ?? this.foulsB,
      yellowCardsA: yellowCardsA ?? this.yellowCardsA,
      yellowCardsB: yellowCardsB ?? this.yellowCardsB,
      redCardsA: redCardsA ?? this.redCardsA,
      redCardsB: redCardsB ?? this.redCardsB,
      possessionA: possessionA ?? this.possessionA, // ✅ আপডেট করুন
      possessionB: possessionB ?? this.possessionB,
    );
  }
}

// LineUp, PlayerLineUp, এবং MatchEvent ক্লাসগুলো আপনার আগের কোড অনুযায়ী ঠিক আছে...
class LineUp {
  final String formation;
  final List<PlayerLineUp> players;

  LineUp({required this.formation, required this.players});

  factory LineUp.fromMap(Map<String, dynamic> map) {
    var rawPlayers = map['players'];
    List<PlayerLineUp> playerList = [];

    if (rawPlayers != null) {
      if (rawPlayers is List) {
        playerList = rawPlayers
            .map((e) => PlayerLineUp.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      } else if (rawPlayers is Map) {
        // ...
      }
    }

    return LineUp(
      formation: map['formation'] ?? '4-3-3',
      players: playerList,
    );
  }

  Map<String, dynamic> toMap() => {
    'formation': formation,
    'players': players.map((e) => e.toMap()).toList(),
  };
}

class PlayerLineUp {
  final String playerId;
  final String playerName;
  final String position;
  final int jerseyNumber;
  final bool isSubstitute;
  final bool isCaptain;
  final String? profilePhotoUrl;

  PlayerLineUp({
    required this.playerId,
    required this.playerName,
    required this.position,
    required this.jerseyNumber,
    this.isSubstitute = false,
    this.isCaptain = false,
    this.profilePhotoUrl,
  });

  // ✅ এই মেথডটি অবশ্যই যোগ করতে হবে
  PlayerLineUp copyWith({
    String? playerId,
    String? playerName,
    String? position,
    int? jerseyNumber,
    bool? isSubstitute,
    bool? isCaptain,
    String? profilePhotoUrl
  }) {
    return PlayerLineUp(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      position: position ?? this.position,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      isSubstitute: isSubstitute ?? this.isSubstitute,
      isCaptain: isCaptain ?? this.isCaptain,
        profilePhotoUrl:profilePhotoUrl??this.profilePhotoUrl
    );
  }

  factory PlayerLineUp.fromMap(Map<String, dynamic> map) => PlayerLineUp(
    playerName: map['playerName'] ?? '',
    playerId: map['playerId'] ?? '',
    jerseyNumber: map['jerseyNumber'] ?? 0,
    position: map['position'] ?? '',
    isCaptain: map['isCaptain'] ?? false,
    isSubstitute: map['isSubstitute'] ?? false,
    profilePhotoUrl: map['profilePhotoUrl'],
  );
  Map<String, dynamic> toMap() => {
    'playerName': playerName,
    'playerId': playerId,
    'jerseyNumber': jerseyNumber,
    'position': position,
    'isCaptain': isCaptain,
    'isSubstitute': isSubstitute,
    'profilePhotoUrl': profilePhotoUrl,
  };
}

class MatchEvent {
  final String type, team, playerName, playerId;
  final int minute;
  final String? details;
  final String? assistPlayerName;
  final String? assistPlayerId; // ✅ এটি যোগ করুন
  final String? assistType; // ✅ এটি যোগ করুন

  MatchEvent({
    required this.type,
    required this.team,
    required this.playerName,
    required this.playerId,
    required this.minute,
    this.details,
    this.assistPlayerName,
    this.assistPlayerId, // ✅ কনস্ট্রাক্টরে যোগ করুন
    this.assistType, // ✅ কনস্ট্রাক্টরে যোগ করুন
  });

  factory MatchEvent.fromMap(Map<String, dynamic> map) => MatchEvent(
    type: map['type'] ?? '',
    team: map['team'] ?? '',
    playerName: map['playerName'] ?? '',
    playerId: map['playerId'] ?? '',
    minute: map['minute'] ?? 0,
    details: map['details'],
    assistPlayerName: map['assistPlayerName'],
    assistPlayerId: map['assistPlayerId'], // ✅ ম্যাপ থেকে লোড করুন
    assistType: map['assistType'], // ✅ ম্যাপ থেকে লোড করুন
  );

  Map<String, dynamic> toMap() => {
    'type': type,
    'team': team,
    'playerName': playerName,
    'playerId': playerId,
    'minute': minute,
    'details': details,
    'assistPlayerName': assistPlayerName,
    'assistPlayerId': assistPlayerId, // ✅ ম্যাপে সেভ করুন
    'assistType': assistType, // ✅ ম্যাপে সেভ করুন
  };
}
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