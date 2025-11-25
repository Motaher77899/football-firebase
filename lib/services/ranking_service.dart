import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_ranking.dart';
import '../models/team_ranking.dart';


class RankingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Team Rankings - শুধু points দিয়ে sort (temporarily)
  Stream<List<TeamRanking>> getTeamRankings() {
    return _firestore
        .collection('team_rankings')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TeamRanking.fromFirestore(doc))
        .toList());
  }

  // Get Player Rankings - শুধু points দিয়ে sort (temporarily)
  Stream<List<PlayerRanking>> getPlayerRankings() {
    return _firestore
        .collection('player_rankings')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PlayerRanking.fromFirestore(doc))
        .toList());
  }

  // Get Top Scorers
  Stream<List<PlayerRanking>> getTopScorers({int limit = 10}) {
    return _firestore
        .collection('player_rankings')
        .orderBy('goals', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PlayerRanking.fromFirestore(doc))
        .toList());
  }

  // Get Top Assisters
  Stream<List<PlayerRanking>> getTopAssisters({int limit = 10}) {
    return _firestore
        .collection('player_rankings')
        .orderBy('assists', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PlayerRanking.fromFirestore(doc))
        .toList());
  }
}