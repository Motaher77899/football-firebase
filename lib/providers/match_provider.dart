// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../models/match_model.dart';
//
// class MatchProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<MatchModel> _matches = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<MatchModel> get matches => _matches;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   List<MatchModel> get liveMatches =>
//       _matches.where((m) => m.status == 'live').toList();
//
//   List<MatchModel> get upcomingMatches =>
//       _matches.where((m) => m.status == 'upcoming').toList();
//
//   List<MatchModel> get finishedMatches =>
//       _matches.where((m) => m.status == 'finished').toList();
//
//   // Fetch all matches
//   Future<void> fetchMatches() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('matches')
//           .orderBy('date', descending: false)
//           .get();
//
//       _matches = snapshot.docs
//           .map((doc) {
//         try {
//           return MatchModel.fromFirestore(doc);
//         } catch (e) {
//           debugPrint('Error parsing match ${doc.id}: $e');
//           return null;
//         }
//       })
//           .whereType<MatchModel>()
//           .toList();
//
//       debugPrint('✅ Fetched ${_matches.length} matches');
//     } catch (e) {
//       _error = 'Error fetching matches: $e';
//       debugPrint('❌ $_error');
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   // Stream matches (real-time updates)
//   Stream<List<MatchModel>> streamMatches() {
//     return _firestore
//         .collection('matches')
//         .orderBy('date', descending: false)
//         .snapshots()
//         .map((snapshot) {
//       debugPrint('📡 Stream updated: ${snapshot.docs.length} documents');
//       return snapshot.docs
//           .map((doc) {
//         try {
//           return MatchModel.fromFirestore(doc);
//         } catch (e) {
//           debugPrint('Error parsing match ${doc.id}: $e');
//           return null;
//         }
//       })
//           .whereType<MatchModel>()
//           .toList();
//     });
//   }
//
//   // Add new match
//   Future<void> addMatch(MatchModel match) async {
//     try {
//       await _firestore.collection('matches').add(match.toFirestore());
//       await fetchMatches();
//       debugPrint('✅ Match added successfully');
//     } catch (e) {
//       debugPrint('❌ Error adding match: $e');
//       _error = 'Error adding match: $e';
//       notifyListeners();
//     }
//   }
//
//   // Update match score
//   Future<void> updateMatchScore(
//       String matchId, int scoreA, int scoreB) async {
//     try {
//       await _firestore.collection('matches').doc(matchId).update({
//         'scoreA': scoreA,
//         'scoreB': scoreB,
//       });
//       debugPrint('✅ Match score updated');
//     } catch (e) {
//       debugPrint('❌ Error updating match score: $e');
//     }
//   }
//
//   // Update match status
//   Future<void> updateMatchStatus(String matchId, String status) async {
//     try {
//       await _firestore.collection('matches').doc(matchId).update({
//         'status': status,
//       });
//       debugPrint('✅ Match status updated to $status');
//     } catch (e) {
//       debugPrint('❌ Error updating match status: $e');
//     }
//   }
//   // Match শেষ করার method
//   Future<void> finishMatch(String matchId) async {
//     try {
//       await _firestore.collection('matches').doc(matchId).update({
//         'status': 'finished',
//       });
//       debugPrint('✅ Match finished - Rankings will be auto-updated');
//       await fetchMatches();
//     } catch (e) {
//       debugPrint('❌ Error finishing match: $e');
//       _error = 'Error finishing match: $e';
//       notifyListeners();
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MatchModel> _matches = [];
  bool _isLoading = false;
  String? _error;

  List<MatchModel> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<MatchModel> get liveMatches =>
      _matches.where((m) => m.status == 'live').toList();

  List<MatchModel> get upcomingMatches =>
      _matches.where((m) => m.status == 'upcoming').toList();

  List<MatchModel> get finishedMatches =>
      _matches.where((m) => m.status == 'finished').toList();

  // ✅ Fetch all matches
  Future<void> fetchMatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('matches')
          .orderBy('date', descending: false)
          .get();

      _matches = snapshot.docs
          .map((doc) {
        try {
          return MatchModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('Error parsing match ${doc.id}: $e');
          return null;
        }
      })
          .whereType<MatchModel>()
          .toList();

      debugPrint('✅ Fetched ${_matches.length} matches');
    } catch (e) {
      _error = 'Error fetching matches: $e';
      debugPrint('❌ $_error');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Stream matches (real-time updates)
  Stream<List<MatchModel>> streamMatches() {
    return _firestore
        .collection('matches')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      debugPrint('📡 Stream updated: ${snapshot.docs.length} documents');
      return snapshot.docs
          .map((doc) {
        try {
          return MatchModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('Error parsing match ${doc.id}: $e');
          return null;
        }
      })
          .whereType<MatchModel>()
          .toList();
    });
  }

  // ✅ Fetch single match WITH player photos
  Future<MatchModel?> fetchMatchWithPlayerPhotos(String matchId) async {
    try {
      DocumentSnapshot matchDoc = await _firestore
          .collection('matches')
          .doc(matchId)
          .get();

      if (!matchDoc.exists) {
        debugPrint('❌ Match not found: $matchId');
        return null;
      }

      MatchModel match = MatchModel.fromFirestore(matchDoc);

      // ✅ Enrich lineup A with player photos
      if (match.lineUpA != null) {
        LineUp enrichedLineupA = await _enrichLineupWithPhotos(match.lineUpA!);
        match = match.copyWith(lineUpA: enrichedLineupA);
      }

      // ✅ Enrich lineup B with player photos
      if (match.lineUpB != null) {
        LineUp enrichedLineupB = await _enrichLineupWithPhotos(match.lineUpB!);
        match = match.copyWith(lineUpB: enrichedLineupB);
      }

      debugPrint('✅ Match fetched with player photos');
      return match;
    } catch (e) {
      debugPrint('❌ Error fetching match with photos: $e');
      return null;
    }
  }

  // ✅ Helper: Enrich lineup with player photos
  Future<LineUp> _enrichLineupWithPhotos(LineUp lineup) async {
    List<PlayerLineUp> enrichedPlayers = [];

    for (var player in lineup.players) {
      String? photoUrl;

      try {
        // Fetch player from Firebase using playerId (document ID)
        DocumentSnapshot playerDoc = await _firestore
            .collection('players')
            .doc(player.playerId)
            .get();

        if (playerDoc.exists) {
          Map<String, dynamic> data = playerDoc.data() as Map<String, dynamic>;
          // Priority: profilePhotoUrl > imageUrl
          photoUrl = data['profilePhotoUrl'] ?? data['imageUrl'];
        }
      } catch (e) {
        debugPrint('❌ Error fetching photo for ${player.playerId}: $e');
      }

      // Add player with photo URL
      enrichedPlayers.add(
        player.copyWith(profilePhotoUrl: photoUrl),
      );
    }

    return LineUp(
      formation: lineup.formation,
      players: enrichedPlayers,
    );
  }

  // ✅ Add new match
  Future<void> addMatch(MatchModel match) async {
    try {
      await _firestore.collection('matches').add(match.toFirestore());
      await fetchMatches();
      debugPrint('✅ Match added successfully');
    } catch (e) {
      debugPrint('❌ Error adding match: $e');
      _error = 'Error adding match: $e';
      notifyListeners();
    }
  }

  // ✅ Update match score
  Future<void> updateMatchScore(
      String matchId, int scoreA, int scoreB) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'scoreA': scoreA,
        'scoreB': scoreB,
      });
      debugPrint('✅ Match score updated');
    } catch (e) {
      debugPrint('❌ Error updating match score: $e');
    }
  }

  // ✅ Update match status
  Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'status': status,
      });
      debugPrint('✅ Match status updated to $status');
    } catch (e) {
      debugPrint('❌ Error updating match status: $e');
    }
  }

  // ✅ Finish match
  Future<void> finishMatch(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'status': 'finished',
      });
      debugPrint('✅ Match finished - Rankings will be auto-updated');
      await fetchMatches();
    } catch (e) {
      debugPrint('❌ Error finishing match: $e');
      _error = 'Error finishing match: $e';
      notifyListeners();
    }
  }

  // ✅ Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}