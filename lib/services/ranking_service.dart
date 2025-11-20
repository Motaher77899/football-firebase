
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_ranking.dart';
import '../models/player_ranking.dart';

class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update team ranking after match
  Future<void> updateTeamRanking({
    required String teamId,
    required bool won,
    required bool draw,
    required int goalsScored,
    required int goalsConceded,
    required int yellowCards,
    required int redCards,
  }) async {
    try {
      final docRef = _firestore.collection('teamRankings').doc(teamId);
      final doc = await docRef.get();

      // Get team info
      final teamDoc = await _firestore.collection('teams').doc(teamId).get();
      final teamName = teamDoc.data()?['name'] ?? '';
      final teamLogo = teamDoc.data()?['logo'];

      if (doc.exists) {
        // Update existing ranking
        final data = doc.data()!;
        final currentWins = data['wins'] ?? 0;
        final currentDraws = data['draws'] ?? 0;
        final currentLosses = data['losses'] ?? 0;
        final currentGoalsFor = data['goalsFor'] ?? 0;
        final currentGoalsAgainst = data['goalsAgainst'] ?? 0;
        final currentYellowCards = data['yellowCards'] ?? 0;
        final currentRedCards = data['redCards'] ?? 0;
        final currentMatches = data['matchesPlayed'] ?? 0;

        final newWins = won ? currentWins + 1 : currentWins;
        final newDraws = draw ? currentDraws + 1 : currentDraws;
        final newLosses = (!won && !draw) ? currentLosses + 1 : currentLosses;
        final newGoalsFor = currentGoalsFor + goalsScored;
        final newGoalsAgainst = currentGoalsAgainst + goalsConceded;
        final newGoalDifference = newGoalsFor - newGoalsAgainst;
        final newPoints = (newWins * 3) + (newDraws * 1);

        await docRef.update({
          'teamName': teamName,
          'teamLogo': teamLogo,
          'matchesPlayed': currentMatches + 1,
          'wins': newWins,
          'draws': newDraws,
          'losses': newLosses,
          'goalsFor': newGoalsFor,
          'goalsAgainst': newGoalsAgainst,
          'goalDifference': newGoalDifference,
          'points': newPoints,
          'yellowCards': currentYellowCards + yellowCards,
          'redCards': currentRedCards + redCards,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new ranking
        final wins = won ? 1 : 0;
        final draws = draw ? 1 : 0;
        final losses = (!won && !draw) ? 1 : 0;
        final points = (wins * 3) + (draws * 1);
        final goalDifference = goalsScored - goalsConceded;

        await docRef.set({
          'teamName': teamName,
          'teamLogo': teamLogo,
          'matchesPlayed': 1,
          'wins': wins,
          'draws': draws,
          'losses': losses,
          'goalsFor': goalsScored,
          'goalsAgainst': goalsConceded,
          'goalDifference': goalDifference,
          'points': points,
          'yellowCards': yellowCards,
          'redCards': redCards,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating team ranking: $e');
      rethrow;
    }
  }

  // Update player ranking
  Future<void> updatePlayerRanking({
    required String playerId,
    int goals = 0,
    int assists = 0,
    bool cleanSheet = false,
    int yellowCards = 0,
    int redCards = 0,
  }) async {
    try {
      final docRef = _firestore.collection('playerRankings').doc(playerId);
      final doc = await docRef.get();

      // Get player info
      final playerDoc = await _firestore.collection('players').doc(playerId).get();
      final playerData = playerDoc.data() ?? {};
      final playerName = playerData['name'] ?? '';
      final playerPhoto = playerData['photo'];
      final teamId = playerData['teamId'] ?? '';
      final position = playerData['position'] ?? '';

      // Get team info
      final teamDoc = await _firestore.collection('teams').doc(teamId).get();
      final teamName = teamDoc.data()?['name'] ?? '';

      if (doc.exists) {
        // Update existing ranking
        final data = doc.data()!;
        final currentGoals = data['goals'] ?? 0;
        final currentAssists = data['assists'] ?? 0;
        final currentCleanSheets = data['cleanSheets'] ?? 0;
        final currentYellowCards = data['yellowCards'] ?? 0;
        final currentRedCards = data['redCards'] ?? 0;
        final currentMatches = data['matchesPlayed'] ?? 0;

        final newGoals = currentGoals + goals;
        final newAssists = currentAssists + assists;
        final newCleanSheets = currentCleanSheets + (cleanSheet ? 1 : 0);
        final newYellowCards = currentYellowCards + yellowCards;
        final newRedCards = currentRedCards + redCards;

        final totalPoints = PlayerRanking.calculatePoints(
          goals: newGoals,
          assists: newAssists,
          cleanSheets: newCleanSheets,
          yellowCards: newYellowCards,
          redCards: newRedCards,
        );

        await docRef.update({
          'playerName': playerName,
          'playerPhoto': playerPhoto,
          'teamId': teamId,
          'teamName': teamName,
          'position': position,
          'goals': newGoals,
          'assists': newAssists,
          'cleanSheets': newCleanSheets,
          'yellowCards': newYellowCards,
          'redCards': newRedCards,
          'totalPoints': totalPoints,
          'matchesPlayed': currentMatches + 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new ranking
        final totalPoints = PlayerRanking.calculatePoints(
          goals: goals,
          assists: assists,
          cleanSheets: cleanSheet ? 1 : 0,
          yellowCards: yellowCards,
          redCards: redCards,
        );

        await docRef.set({
          'playerName': playerName,
          'playerPhoto': playerPhoto,
          'teamId': teamId,
          'teamName': teamName,
          'position': position,
          'goals': goals,
          'assists': assists,
          'cleanSheets': cleanSheet ? 1 : 0,
          'yellowCards': yellowCards,
          'redCards': redCards,
          'totalPoints': totalPoints,
          'matchesPlayed': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating player ranking: $e');
      rethrow;
    }
  }

  // Get team rankings
  Stream<List<TeamRanking>> getTeamRankings({int limit = 50}) {
    return _firestore
        .collection('teamRankings')
        .orderBy('points', descending: true)
        .orderBy('goalDifference', descending: true)
        .orderBy('goalsFor', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TeamRanking.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get player rankings
  Stream<List<PlayerRanking>> getPlayerRankings({int limit = 50}) {
    return _firestore
        .collection('playerRankings')
        .orderBy('totalPoints', descending: true)
        .orderBy('goals', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PlayerRanking.fromMap(doc.data(), doc.id))
        .toList());
  }
}