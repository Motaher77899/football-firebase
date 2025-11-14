//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/team_model.dart';
//
// class TeamProvider extends ChangeNotifier {
//   List<TeamModel> _teams = [];
//   bool _isLoading = false;
//   String? _error;
//
//   List<TeamModel> get teams => _teams;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   // ✅ Team ID দিয়ে team খুঁজে বের করুন
//   TeamModel? getTeamById(String teamId) {
//     if (teamId.isEmpty) return null;
//
//     try {
//       return _teams.firstWhere(
//             (team) => team.id == teamId,
//         orElse: () => throw Exception('Team not found'),
//       );
//     } catch (e) {
//       debugPrint('❌ Team not found with ID: $teamId');
//       return null;
//     }
//   }
//
//   // ✅ Team Name দিয়ে team খুঁজে বের করুন (for MatchCard compatibility)
//   TeamModel? getTeamByName(String teamName) {
//     if (teamName.isEmpty) return null;
//
//     try {
//       return _teams.firstWhere(
//             (team) => team.name.toLowerCase() == teamName.toLowerCase(),
//         orElse: () => throw Exception('Team not found'),
//       );
//     } catch (e) {
//       debugPrint('❌ Team not found with name: $teamName');
//       return null;
//     }
//   }
//
//   // ✅ Multiple team IDs দিয়ে teams খুঁজুন
//   List<TeamModel> getTeamsByIds(List<String> teamIds) {
//     return _teams.where((team) => teamIds.contains(team.id)).toList();
//   }
//
//   // Fetch all teams from Firebase
//   Future<void> fetchTeams() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       debugPrint('🔄 Fetching teams from Firebase...');
//
//       final snapshot = await FirebaseFirestore.instance
//           .collection('teams')
//           .get();
//
//       _teams = snapshot.docs
//           .map((doc) => TeamModel.fromFirestore(doc))
//           .toList();
//
//       debugPrint('✅ Fetched ${_teams.length} teams');
//
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       debugPrint('❌ Error fetching teams: $e');
//       notifyListeners();
//     }
//   }
//
//   // Stream teams (real-time updates)
//   Stream<List<TeamModel>> streamTeams() {
//     return FirebaseFirestore.instance
//         .collection('teams')
//         .snapshots()
//         .map((snapshot) {
//       final teams = snapshot.docs
//           .map((doc) => TeamModel.fromFirestore(doc))
//           .toList();
//
//       // Update local cache
//       _teams = teams;
//
//       return teams;
//     });
//   }
//
//   // Add new team
//   Future<void> addTeam(TeamModel team) async {
//     try {
//       debugPrint('➕ Adding new team: ${team.name}');
//
//       final docRef = await FirebaseFirestore.instance
//           .collection('teams')
//           .add(team.toFirestore());  // ✅ Using toFirestore()
//
//       debugPrint('✅ Team added with ID: ${docRef.id}');
//
//       // Refresh teams
//       await fetchTeams();
//     } catch (e) {
//       debugPrint('❌ Error adding team: $e');
//       rethrow;
//     }
//   }
//
//   // Update team
//   Future<void> updateTeam(String teamId, TeamModel team) async {
//     try {
//       debugPrint('📝 Updating team: $teamId');
//
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .update(team.toFirestore());  // ✅ Using toFirestore()
//
//       debugPrint('✅ Team updated');
//
//       // Refresh teams
//       await fetchTeams();
//     } catch (e) {
//       debugPrint('❌ Error updating team: $e');
//       rethrow;
//     }
//   }
//
//   // Delete team
//   Future<void> deleteTeam(String teamId) async {
//     try {
//       debugPrint('🗑️ Deleting team: $teamId');
//
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .delete();
//
//       debugPrint('✅ Team deleted');
//
//       // Refresh teams
//       await fetchTeams();
//     } catch (e) {
//       debugPrint('❌ Error deleting team: $e');
//       rethrow;
//     }
//   }
//
//   // Search teams by name
//   List<TeamModel> searchTeams(String query) {
//     if (query.isEmpty) return _teams;
//
//     final lowerQuery = query.toLowerCase();
//     return _teams.where((team) {
//       return team.name.toLowerCase().contains(lowerQuery);
//     }).toList();
//   }
//
//   // Clear cache
//   void clearCache() {
//     _teams.clear();
//     _error = null;
//     _isLoading = false;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamModel> _teams = [];
  bool _isLoading = false;
  String? _error;

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ✅ Team ID দিয়ে team খুঁজে বের করুন
  TeamModel? getTeamById(String teamId) {
    if (teamId.isEmpty) return null;

    try {
      return _teams.firstWhere(
            (team) => team.id == teamId,
        orElse: () => throw Exception('Team not found'),
      );
    } catch (e) {
      debugPrint('❌ Team not found with ID: $teamId');
      return null;
    }
  }

  // ✅ Team Name দিয়ে team খুঁজে বের করুন (for MatchCard compatibility)
  TeamModel? getTeamByName(String teamName) {
    if (teamName.isEmpty) return null;

    try {
      return _teams.firstWhere(
            (team) => team.name.toLowerCase() == teamName.toLowerCase(),
        orElse: () => throw Exception('Team not found'),
      );
    } catch (e) {
      debugPrint('❌ Team not found with name: $teamName');
      return null;
    }
  }

  // ✅ Multiple team IDs দিয়ে teams খুঁজুন
  List<TeamModel> getTeamsByIds(List<String> teamIds) {
    return _teams.where((team) => teamIds.contains(team.id)).toList();
  }

  // Fetch all teams from Firebase
  Future<void> fetchTeams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔄 Fetching teams from Firebase...');

      final snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .get();

      _teams = snapshot.docs
          .map((doc) => TeamModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Fetched ${_teams.length} teams');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('❌ Error fetching teams: $e');
      notifyListeners();
    }
  }

  // Stream teams (real-time updates)
  Stream<List<TeamModel>> streamTeams() {
    return FirebaseFirestore.instance
        .collection('teams')
        .snapshots()
        .map((snapshot) {
      final teams = snapshot.docs
          .map((doc) => TeamModel.fromFirestore(doc))
          .toList();

      // Update local cache
      _teams = teams;

      return teams;
    });
  }

  // Add new team
  Future<void> addTeam(TeamModel team) async {
    try {
      debugPrint('➕ Adding new team: ${team.name}');

      final docRef = await FirebaseFirestore.instance
          .collection('teams')
          .add(team.toFirestore());  // ✅ Using toFirestore()

      debugPrint('✅ Team added with ID: ${docRef.id}');

      // Refresh teams
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error adding team: $e');
      rethrow;
    }
  }

  // Update team
  Future<void> updateTeam(String teamId, TeamModel team) async {
    try {
      debugPrint('📝 Updating team: $teamId');

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update(team.toFirestore());  // ✅ Using toFirestore()

      debugPrint('✅ Team updated');

      // Refresh teams
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error updating team: $e');
      rethrow;
    }
  }

  // Delete team
  Future<void> deleteTeam(String teamId) async {
    try {
      debugPrint('🗑️ Deleting team: $teamId');

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .delete();

      debugPrint('✅ Team deleted');

      // Refresh teams
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error deleting team: $e');
      rethrow;
    }
  }

  // Search teams by name
  List<TeamModel> searchTeams(String query) {
    if (query.isEmpty) return _teams;

    final lowerQuery = query.toLowerCase();
    return _teams.where((team) {
      return team.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Clear cache
  void clearCache() {
    _teams.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}