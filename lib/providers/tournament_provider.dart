// // import 'package:flutter/foundation.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../models/tournament_model.dart';
// //
// //
// // class TournamentProvider extends ChangeNotifier {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   TournamentModel? _selectedTournament;
// //   List<TournamentModel> _tournaments = [];
// //   List<Map<String, dynamic>> _tournamentMatches = [];
// //   List<Map<String, dynamic>> _tournamentTeams = [];
// //
// //   bool _isLoading = false;
// //   String? _error;
// //
// //   // Getters
// //   TournamentModel? get selectedTournament => _selectedTournament;
// //   List<TournamentModel> get tournaments => _tournaments;
// //   List<Map<String, dynamic>> get tournamentMatches => _tournamentMatches;
// //   List<Map<String, dynamic>> get tournamentTeams => _tournamentTeams;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;
// //
// //   // Fetch all tournaments
// //   Future<void> fetchTournaments() async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final snapshot = await _firestore
// //           .collection('tournaments')
// //           .orderBy('startDate', descending: true)
// //           .get();
// //
// //       _tournaments = snapshot.docs
// //           .map((doc) => TournamentModel.fromFirestore(doc))
// //           .toList();
// //
// //       print('✅ Fetched ${_tournaments.length} tournaments');
// //     } catch (e) {
// //       _error = 'টুর্নামেন্ট লোড করতে সমস্যা: $e';
// //       print('❌ Error fetching tournaments: $e');
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Fetch tournament by ID
// //   Future<void> fetchTournamentById(String tournamentId) async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final doc = await _firestore
// //           .collection('tournaments')
// //           .doc(tournamentId)
// //           .get();
// //
// //       if (doc.exists) {
// //         _selectedTournament = TournamentModel.fromFirestore(doc);
// //
// //         // Fetch related data
// //         await _fetchTournamentMatches(tournamentId);
// //         await _fetchTournamentTeams(); // teams array থেকে load করবে
// //
// //         print('✅ Fetched tournament: ${_selectedTournament!.name}');
// //         print('✅ Tournament has ${_selectedTournament!.teams.length} teams');
// //       } else {
// //         _error = 'টুর্নামেন্ট পাওয়া যায়নি';
// //       }
// //     } catch (e) {
// //       _error = 'টুর্নামেন্ট লোড করতে সমস্যা: $e';
// //       print('❌ Error fetching tournament: $e');
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Fetch matches for a tournament
// //   Future<void> _fetchTournamentMatches(String tournamentId) async {
// //     try {
// //       final snapshot = await _firestore
// //           .collection('matches')
// //           .where('tournamentId', isEqualTo: tournamentId)
// //           .orderBy('matchTime', descending: false)
// //           .get();
// //
// //       _tournamentMatches = snapshot.docs.map((doc) {
// //         final data = doc.data();
// //         return {
// //           'id': doc.id,
// //           ...data,
// //         };
// //       }).toList();
// //
// //       print('✅ Fetched ${_tournamentMatches.length} matches for tournament');
// //     } catch (e) {
// //       print('❌ Error fetching tournament matches: $e');
// //       _tournamentMatches = [];
// //     }
// //   }
// //
// //   // Fetch teams from tournament's teams array
// //   Future<void> _fetchTournamentTeams() async {
// //     if (_selectedTournament == null || _selectedTournament!.teams.isEmpty) {
// //       _tournamentTeams = [];
// //       print('⚠️ No teams in tournament');
// //       return;
// //     }
// //
// //     try {
// //       // Tournament এর teams array থেকে team IDs নিয়ে fetch করুন
// //       List<Map<String, dynamic>> teams = [];
// //
// //       for (String teamId in _selectedTournament!.teams) {
// //         try {
// //           final teamDoc = await _firestore
// //               .collection('teams')
// //               .doc(teamId)
// //               .get();
// //
// //           if (teamDoc.exists) {
// //             teams.add({
// //               'id': teamDoc.id,
// //               ...teamDoc.data() as Map<String, dynamic>,
// //             });
// //           }
// //         } catch (e) {
// //           print('⚠️ Could not fetch team $teamId: $e');
// //         }
// //       }
// //
// //       _tournamentTeams = teams;
// //       print('✅ Fetched ${_tournamentTeams.length} teams for tournament');
// //     } catch (e) {
// //       print('❌ Error fetching tournament teams: $e');
// //       _tournamentTeams = [];
// //     }
// //   }
// //
// //   // Stream for real-time tournament updates
// //   Stream<TournamentModel> streamTournament(String tournamentId) {
// //     return _firestore
// //         .collection('tournaments')
// //         .doc(tournamentId)
// //         .snapshots()
// //         .map((doc) => TournamentModel.fromFirestore(doc));
// //   }
// //
// //   // Stream for tournament matches
// //   Stream<List<Map<String, dynamic>>> streamTournamentMatches(String tournamentId) {
// //     return _firestore
// //         .collection('matches')
// //         .where('tournamentId', isEqualTo: tournamentId)
// //         .orderBy('matchTime', descending: false)
// //         .snapshots()
// //         .map((snapshot) => snapshot.docs.map((doc) {
// //       final data = doc.data();
// //       return {
// //         'id': doc.id,
// //         ...data,
// //       };
// //     }).toList());
// //   }
// //
// //   // Get matches by status
// //   List<Map<String, dynamic>> getMatchesByStatus(String status) {
// //     return _tournamentMatches
// //         .where((match) => match['status'] == status)
// //         .toList();
// //   }
// //
// //   // Get live matches count
// //   int get liveMatchesCount {
// //     return _tournamentMatches
// //         .where((match) => match['status'] == 'live')
// //         .length;
// //   }
// //
// //   // Get completed matches count
// //   int get completedMatchesCount {
// //     return _tournamentMatches
// //         .where((match) => match['status'] == 'finished')
// //         .length;
// //   }
// //
// //   // Get upcoming matches count
// //   int get upcomingMatchesCount {
// //     return _tournamentMatches
// //         .where((match) => match['status'] == 'upcoming')
// //         .length;
// //   }
// //
// //   // Clear selected tournament
// //   void clearSelectedTournament() {
// //     _selectedTournament = null;
// //     _tournamentMatches = [];
// //     _tournamentTeams = [];
// //     notifyListeners();
// //   }
// //
// //   // Refresh tournament data
// //   Future<void> refreshTournament(String tournamentId) async {
// //     await fetchTournamentById(tournamentId);
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/tournament.dart';
// import '../models/tournament_model.dart';
//
// class TournamentProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<Tournament> _tournaments = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<Tournament> get tournaments => _tournaments;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   // Filter করা tournaments
//   List<Tournament> get upcomingTournaments =>
//       _tournaments.where((t) => t.status == 'upcoming').toList();
//
//   List<Tournament> get ongoingTournaments =>
//       _tournaments.where((t) => t.status == 'ongoing').toList();
//
//   List<Tournament> get completedTournaments =>
//       _tournaments.where((t) => t.status == 'completed').toList();
//
//   // সব tournaments fetch করা
//   Future<void> fetchTournaments() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final QuerySnapshot snapshot = await _firestore
//           .collection('tournaments')
//           .orderBy('startDate', descending: true)
//           .get();
//
//       _tournaments = snapshot.docs
//           .map((doc) => Tournament.fromMap(
//         doc.data() as Map<String, dynamic>,
//         doc.id,
//       ))
//           .toList();
//
//       _error = null;
//     } catch (e) {
//       _error = 'টুর্নামেন্ট লোড করতে সমস্যা হয়েছে: $e';
//       print('Error fetching tournaments: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // একটা specific tournament fetch করা
//   Future<Tournament?> getTournamentById(String id) async {
//     try {
//       final DocumentSnapshot doc =
//       await _firestore.collection('tournaments').doc(id).get();
//
//       if (doc.exists) {
//         return Tournament.fromMap(
//           doc.data() as Map<String, dynamic>,
//           doc.id,
//         );
//       }
//       return null;
//     } catch (e) {
//       print('Error fetching tournament: $e');
//       return null;
//     }
//   }
//
//   // Status অনুযায়ী tournaments filter করা
//   List<Tournament> getTournamentsByStatus(String status) {
//     return _tournaments.where((t) => t.status == status).toList();
//   }
//
//   // Search functionality
//   List<Tournament> searchTournaments(String query) {
//     if (query.isEmpty) return _tournaments;
//
//     final lowerQuery = query.toLowerCase();
//     return _tournaments.where((tournament) {
//       return tournament.name.toLowerCase().contains(lowerQuery) ||
//           tournament.location.toLowerCase().contains(lowerQuery) ||
//           tournament.organizerName.toLowerCase().contains(lowerQuery);
//     }).toList();
//   }
//
//   // Clear data
//   void clearTournaments() {
//     _tournaments = [];
//     _error = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament.dart';
import '../models/tournament_model.dart';

class TournamentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Tournament> _tournaments = [];
  bool _isLoading = false;
  String? _error;

  List<Tournament> get tournaments => _tournaments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter করা tournaments
  List<Tournament> get upcomingTournaments =>
      _tournaments.where((t) => t.status == 'upcoming').toList();

  List<Tournament> get ongoingTournaments =>
      _tournaments.where((t) => t.status == 'ongoing').toList();

  List<Tournament> get completedTournaments =>
      _tournaments.where((t) => t.status == 'completed').toList();

  // সব tournaments fetch করা
  Future<void> fetchTournaments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('tournaments')
          .orderBy('startDate', descending: true)
          .get();

      _tournaments = snapshot.docs
          .map((doc) => Tournament.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      ))
          .toList();

      _error = null;
    } catch (e) {
      _error = 'টুর্নামেন্ট লোড করতে সমস্যা হয়েছে: $e';
      print('Error fetching tournaments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // একটা specific tournament fetch করা
  Future<Tournament?> getTournamentById(String id) async {
    try {
      final DocumentSnapshot doc =
      await _firestore.collection('tournaments').doc(id).get();

      if (doc.exists) {
        return Tournament.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching tournament: $e');
      return null;
    }
  }

  // Status অনুযায়ী tournaments filter করা
  List<Tournament> getTournamentsByStatus(String status) {
    return _tournaments.where((t) => t.status == status).toList();
  }

  // Search functionality
  List<Tournament> searchTournaments(String query) {
    if (query.isEmpty) return _tournaments;

    final lowerQuery = query.toLowerCase();
    return _tournaments.where((tournament) {
      return tournament.name.toLowerCase().contains(lowerQuery) ||
          tournament.location.toLowerCase().contains(lowerQuery) ||
          tournament.organizerName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Clear data
  void clearTournaments() {
    _tournaments = [];
    _error = null;
    notifyListeners();
  }
}