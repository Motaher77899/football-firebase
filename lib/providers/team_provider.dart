// //
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../models/team_model.dart';
// //
// // class TeamProvider extends ChangeNotifier {
// //   List<TeamModel> _teams = [];
// //   bool _isLoading = false;
// //   String? _error;
// //
// //   List<TeamModel> get teams => _teams;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;
// //
// //   // ✅ Team ID দিয়ে team খুঁজে বের করুন
// //   TeamModel? getTeamById(String teamId) {
// //     if (teamId.isEmpty) return null;
// //
// //     try {
// //       return _teams.firstWhere(
// //             (team) => team.id == teamId,
// //         orElse: () => throw Exception('Team not found'),
// //       );
// //     } catch (e) {
// //       debugPrint('❌ Team not found with ID: $teamId');
// //       return null;
// //     }
// //   }
// //
// //   // ✅ Team Name দিয়ে team খুঁজে বের করুন (for MatchCard compatibility)
// //   TeamModel? getTeamByName(String teamName) {
// //     if (teamName.isEmpty) return null;
// //
// //     try {
// //       return _teams.firstWhere(
// //             (team) => team.name.toLowerCase() == teamName.toLowerCase(),
// //         orElse: () => throw Exception('Team not found'),
// //       );
// //     } catch (e) {
// //       debugPrint('❌ Team not found with name: $teamName');
// //       return null;
// //     }
// //   }
// //
// //   // ✅ Multiple team IDs দিয়ে teams খুঁজুন
// //   List<TeamModel> getTeamsByIds(List<String> teamIds) {
// //     return _teams.where((team) => teamIds.contains(team.id)).toList();
// //   }
// //
// //   // Fetch all teams from Firebase
// //   Future<void> fetchTeams() async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       debugPrint('🔄 Fetching teams from Firebase...');
// //
// //       final snapshot = await FirebaseFirestore.instance
// //           .collection('teams')
// //           .get();
// //
// //       _teams = snapshot.docs
// //           .map((doc) => TeamModel.fromFirestore(doc))
// //           .toList();
// //
// //       debugPrint('✅ Fetched ${_teams.length} teams');
// //
// //       _isLoading = false;
// //       notifyListeners();
// //     } catch (e) {
// //       _error = e.toString();
// //       _isLoading = false;
// //       debugPrint('❌ Error fetching teams: $e');
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Stream teams (real-time updates)
// //   Stream<List<TeamModel>> streamTeams() {
// //     return FirebaseFirestore.instance
// //         .collection('teams')
// //         .snapshots()
// //         .map((snapshot) {
// //       final teams = snapshot.docs
// //           .map((doc) => TeamModel.fromFirestore(doc))
// //           .toList();
// //
// //       // Update local cache
// //       _teams = teams;
// //
// //       return teams;
// //     });
// //   }
// //
// //   // Add new team
// //   Future<void> addTeam(TeamModel team) async {
// //     try {
// //       debugPrint('➕ Adding new team: ${team.name}');
// //
// //       final docRef = await FirebaseFirestore.instance
// //           .collection('teams')
// //           .add(team.toFirestore());  // ✅ Using toFirestore()
// //
// //       debugPrint('✅ Team added with ID: ${docRef.id}');
// //
// //       // Refresh teams
// //       await fetchTeams();
// //     } catch (e) {
// //       debugPrint('❌ Error adding team: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Update team
// //   Future<void> updateTeam(String teamId, TeamModel team) async {
// //     try {
// //       debugPrint('📝 Updating team: $teamId');
// //
// //       await FirebaseFirestore.instance
// //           .collection('teams')
// //           .doc(teamId)
// //           .update(team.toFirestore());  // ✅ Using toFirestore()
// //
// //       debugPrint('✅ Team updated');
// //
// //       // Refresh teams
// //       await fetchTeams();
// //     } catch (e) {
// //       debugPrint('❌ Error updating team: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Delete team
// //   Future<void> deleteTeam(String teamId) async {
// //     try {
// //       debugPrint('🗑️ Deleting team: $teamId');
// //
// //       await FirebaseFirestore.instance
// //           .collection('teams')
// //           .doc(teamId)
// //           .delete();
// //
// //       debugPrint('✅ Team deleted');
// //
// //       // Refresh teams
// //       await fetchTeams();
// //     } catch (e) {
// //       debugPrint('❌ Error deleting team: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Search teams by name
// //   List<TeamModel> searchTeams(String query) {
// //     if (query.isEmpty) return _teams;
// //
// //     final lowerQuery = query.toLowerCase();
// //     return _teams.where((team) {
// //       return team.name.toLowerCase().contains(lowerQuery);
// //     }).toList();
// //   }
// //
// //   // Clear cache
// //   void clearCache() {
// //     _teams.clear();
// //     _error = null;
// //     _isLoading = false;
// //     notifyListeners();
// //   }
// // }
//
//
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
//           .add(team.toFirestore());
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
//           .update(team.toFirestore());
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
//   // ✅ Add player to team
//   Future<bool> addPlayerToTeam({
//     required String playerId,
//     required String teamId,
//   }) async {
//     try {
//       debugPrint('➕ Adding player $playerId to team $teamId');
//
//       // Get team info
//       final teamDoc = await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .get();
//
//       if (!teamDoc.exists) {
//         debugPrint('❌ Team not found');
//         _error = 'টিম পাওয়া যায়নি';
//         notifyListeners();
//         return false;
//       }
//
//       final teamName = teamDoc.data()?['name'] ?? '';
//
//       // Update player's teamId and teamName
//       await FirebaseFirestore.instance
//           .collection('players')
//           .doc(playerId)
//           .update({
//         'teamId': teamId,
//         'teamName': teamName,
//       });
//
//       // Add player to team's playerIds array
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .update({
//         'playerIds': FieldValue.arrayUnion([playerId]),
//       });
//
//       debugPrint('✅ Player added to team successfully');
//
//       // Refresh teams
//       await fetchTeams();
//
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error adding player to team: $e');
//       _error = 'প্লেয়ার যোগ করতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Remove player from team
//   Future<bool> removePlayerFromTeam({
//     required String playerId,
//     required String teamId,
//   }) async {
//     try {
//       debugPrint('➖ Removing player $playerId from team $teamId');
//
//       // Remove player's teamId and teamName
//       await FirebaseFirestore.instance
//           .collection('players')
//           .doc(playerId)
//           .update({
//         'teamId': null,
//         'teamName': null,
//       });
//
//       // Remove player from team's playerIds array
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .update({
//         'playerIds': FieldValue.arrayRemove([playerId]),
//       });
//
//       debugPrint('✅ Player removed from team successfully');
//
//       // Refresh teams
//       await fetchTeams();
//
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error removing player from team: $e');
//       _error = 'প্লেয়ার সরাতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Change player's team
//   Future<bool> changePlayerTeam({
//     required String playerId,
//     required String oldTeamId,
//     required String newTeamId,
//   }) async {
//     try {
//       debugPrint('🔄 Changing player $playerId from team $oldTeamId to $newTeamId');
//
//       // Remove from old team
//       await removePlayerFromTeam(
//         playerId: playerId,
//         teamId: oldTeamId,
//       );
//
//       // Add to new team
//       await addPlayerToTeam(
//         playerId: playerId,
//         teamId: newTeamId,
//       );
//
//       debugPrint('✅ Player team changed successfully');
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error changing player team: $e');
//       _error = 'টিম পরিবর্তন করতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Get players of a team
//   Stream<List<Map<String, dynamic>>> getTeamPlayers(String teamId) {
//     return FirebaseFirestore.instance
//         .collection('players')
//         .where('teamId', isEqualTo: teamId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           'id': doc.id,
//           ...doc.data(),
//         };
//       }).toList();
//     });
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
//
//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
// }
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
//           .add(team.toFirestore());
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
//           .update(team.toFirestore());
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
//   // ✅ Add player to team (using playerId field)
//   Future<bool> addPlayerToTeam({
//     required String playerId, // This is the playerId field value (e.g., "Ramgati-88090")
//     required String teamId,
//   }) async {
//     try {
//       debugPrint('➕ Adding player $playerId to team $teamId');
//
//       // Get team info
//       final teamDoc = await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .get();
//
//       if (!teamDoc.exists) {
//         debugPrint('❌ Team not found');
//         _error = 'টিম পাওয়া যায়নি';
//         notifyListeners();
//         return false;
//       }
//
//       final teamName = teamDoc.data()?['name'] ?? '';
//
//       // Find player document by playerId field
//       final playerQuery = await FirebaseFirestore.instance
//           .collection('players')
//           .where('playerId', isEqualTo: playerId)
//           .limit(1)
//           .get();
//
//       if (playerQuery.docs.isEmpty) {
//         debugPrint('❌ Player not found with playerId: $playerId');
//         _error = 'প্লেয়ার পাওয়া যায়নি';
//         notifyListeners();
//         return false;
//       }
//
//       final playerDocId = playerQuery.docs.first.id;
//
//       // Update player's teamId and teamName
//       await FirebaseFirestore.instance
//           .collection('players')
//           .doc(playerDocId)
//           .update({
//         'teamId': teamId,
//         'teamName': teamName,
//       });
//
//       // Add playerId (not document ID) to team's playerIds array
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .update({
//         'playerIds': FieldValue.arrayUnion([playerId]),
//       });
//
//       debugPrint('✅ Player added to team successfully');
//
//       // Refresh teams
//       await fetchTeams();
//
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error adding player to team: $e');
//       _error = 'প্লেয়ার যোগ করতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Remove player from team (using playerId field)
//   Future<bool> removePlayerFromTeam({
//     required String playerId, // This is the playerId field value
//     required String teamId,
//   }) async {
//     try {
//       debugPrint('➖ Removing player $playerId from team $teamId');
//
//       // Find player document by playerId field
//       final playerQuery = await FirebaseFirestore.instance
//           .collection('players')
//           .where('playerId', isEqualTo: playerId)
//           .limit(1)
//           .get();
//
//       if (playerQuery.docs.isEmpty) {
//         debugPrint('❌ Player not found with playerId: $playerId');
//         _error = 'প্লেয়ার পাওয়া যায়নি';
//         notifyListeners();
//         return false;
//       }
//
//       final playerDocId = playerQuery.docs.first.id;
//
//       // Remove player's teamId and teamName
//       await FirebaseFirestore.instance
//           .collection('players')
//           .doc(playerDocId)
//           .update({
//         'teamId': null,
//         'teamName': null,
//       });
//
//       // Remove playerId (not document ID) from team's playerIds array
//       await FirebaseFirestore.instance
//           .collection('teams')
//           .doc(teamId)
//           .update({
//         'playerIds': FieldValue.arrayRemove([playerId]),
//       });
//
//       debugPrint('✅ Player removed from team successfully');
//
//       // Refresh teams
//       await fetchTeams();
//
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error removing player from team: $e');
//       _error = 'প্লেয়ার সরাতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Change player's team
//   Future<bool> changePlayerTeam({
//     required String playerId,
//     required String oldTeamId,
//     required String newTeamId,
//   }) async {
//     try {
//       debugPrint('🔄 Changing player $playerId from team $oldTeamId to $newTeamId');
//
//       // Remove from old team
//       await removePlayerFromTeam(
//         playerId: playerId,
//         teamId: oldTeamId,
//       );
//
//       // Add to new team
//       await addPlayerToTeam(
//         playerId: playerId,
//         teamId: newTeamId,
//       );
//
//       debugPrint('✅ Player team changed successfully');
//       return true;
//     } catch (e) {
//       debugPrint('❌ Error changing player team: $e');
//       _error = 'টিম পরিবর্তন করতে ব্যর্থ: $e';
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // ✅ Get players of a team (using playerId field)
//   Stream<List<Map<String, dynamic>>> getTeamPlayers(String teamId) {
//     return FirebaseFirestore.instance
//         .collection('teams')
//         .doc(teamId)
//         .snapshots()
//         .asyncMap((teamDoc) async {
//       if (!teamDoc.exists) return [];
//
//       final playerIds = List<String>.from(teamDoc.data()?['playerIds'] ?? []);
//       if (playerIds.isEmpty) return [];
//
//       final players = <Map<String, dynamic>>[];
//
//       for (String playerId in playerIds) {
//         try {
//           final playerQuery = await FirebaseFirestore.instance
//               .collection('players')
//               .where('playerId', isEqualTo: playerId)
//               .limit(1)
//               .get();
//
//           if (playerQuery.docs.isNotEmpty) {
//             players.add({
//               'id': playerQuery.docs.first.id,
//               ...playerQuery.docs.first.data(),
//             });
//           }
//         } catch (e) {
//           debugPrint('❌ Error fetching player $playerId: $e');
//         }
//       }
//
//       return players;
//     });
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
//
//   // Clear error
//   void clearError() {
//     _error = null;
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
    if (teamId.isEmpty) {
      debugPrint('⚠️ Empty team ID provided');
      return null;
    }

    try {
      final team = _teams.firstWhere(
            (team) => team.id == teamId,
        orElse: () => throw Exception('Team not found'),
      );
      return team;
    } catch (e) {
      debugPrint('❌ Team not found with ID: $teamId');
      debugPrint('   Available IDs: ${_teams.map((t) => t.id).join(", ")}');
      return null;
    }
  }

  // ✅ Team Name দিয়ে team খুঁজে বের করুন
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

  // ✅ FIXED: Fetch all teams from Firebase
  Future<void> fetchTeams() async {
    debugPrint('═══════════════════════════════════');
    debugPrint('🔄 Starting to fetch teams...');
    debugPrint('═══════════════════════════════════');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('📡 Querying Firestore collection: teams');

      final snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .get();

      debugPrint('📦 Received ${snapshot.docs.length} documents from Firebase');

      if (snapshot.docs.isEmpty) {
        debugPrint('⚠️  WARNING: No teams found in Firebase!');
        debugPrint('   Please check:');
        debugPrint('   1. Collection name is "teams" (lowercase)');
        debugPrint('   2. Documents exist in Firebase Console');
        debugPrint('   3. Firestore rules allow read access');
        _teams = [];
      } else {
        debugPrint('✨ Processing documents...');
        _teams = [];

        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            debugPrint('   📄 Document: ${doc.id}');
            debugPrint('      Data keys: ${data.keys.join(", ")}');

            // ✅ Try fromFirestore first
            TeamModel team;
            try {
              team = TeamModel.fromFirestore(doc);
              debugPrint('      ✅ Parsed with fromFirestore');
            } catch (e1) {
              // ✅ Fallback to fromMap
              debugPrint('      ⚠️  fromFirestore failed, trying fromMap');
              team = TeamModel.fromMap(data, doc.id);
              debugPrint('      ✅ Parsed with fromMap');
            }

            _teams.add(team);
            debugPrint('      ✅ SUCCESS: ${team.id} - "${team.name}"');

          } catch (e) {
            debugPrint('      ❌ ERROR parsing ${doc.id}: $e');
            debugPrint('      Stack: ${StackTrace.current}');
          }
        }

        debugPrint('');
        debugPrint('═══════════════════════════════════');
        debugPrint('🎉 Team loading complete!');
        debugPrint('   Total teams loaded: ${_teams.length}');
        debugPrint('   Team IDs: ${_teams.map((t) => t.id).join(", ")}');
        debugPrint('   Team Names: ${_teams.map((t) => t.name).join(", ")}');
        debugPrint('═══════════════════════════════════');
      }

      _isLoading = false;
      notifyListeners();

    } catch (e, stackTrace) {
      _error = e.toString();
      _isLoading = false;

      debugPrint('');
      debugPrint('═══════════════════════════════════');
      debugPrint('❌ CRITICAL ERROR fetching teams!');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('   Stack trace:');
      debugPrint('$stackTrace');
      debugPrint('═══════════════════════════════════');

      notifyListeners();
    }
  }

  // Stream teams (real-time updates)
  Stream<List<TeamModel>> streamTeams() {
    return FirebaseFirestore.instance
        .collection('teams')
        .snapshots()
        .map((snapshot) {
      final teams = snapshot.docs.map((doc) {
        try {
          return TeamModel.fromFirestore(doc);
        } catch (e) {
          try {
            return TeamModel.fromMap(doc.data(), doc.id);
          } catch (e2) {
            debugPrint('❌ Error parsing team ${doc.id}: $e2');
            return null;
          }
        }
      }).whereType<TeamModel>().toList();

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
          .add(team.toFirestore());

      debugPrint('✅ Team added with ID: ${docRef.id}');
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
          .update(team.toFirestore());

      debugPrint('✅ Team updated');
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
      await fetchTeams();
    } catch (e) {
      debugPrint('❌ Error deleting team: $e');
      rethrow;
    }
  }

  // Add player to team
  Future<bool> addPlayerToTeam({
    required String playerId,
    required String teamId,
  }) async {
    try {
      debugPrint('➕ Adding player $playerId to team $teamId');

      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        debugPrint('❌ Team not found');
        _error = 'টিম পাওয়া যায়নি';
        notifyListeners();
        return false;
      }

      final teamName = teamDoc.data()?['name'] ?? '';

      final playerQuery = await FirebaseFirestore.instance
          .collection('players')
          .where('playerId', isEqualTo: playerId)
          .limit(1)
          .get();

      if (playerQuery.docs.isEmpty) {
        debugPrint('❌ Player not found with playerId: $playerId');
        _error = 'প্লেয়ার পাওয়া যায়নি';
        notifyListeners();
        return false;
      }

      final playerDocId = playerQuery.docs.first.id;

      await FirebaseFirestore.instance
          .collection('players')
          .doc(playerDocId)
          .update({
        'teamId': teamId,
        'teamName': teamName,
      });

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update({
        'playerIds': FieldValue.arrayUnion([playerId]),
      });

      debugPrint('✅ Player added to team successfully');
      await fetchTeams();
      return true;
    } catch (e) {
      debugPrint('❌ Error adding player to team: $e');
      _error = 'প্লেয়ার যোগ করতে ব্যর্থ: $e';
      notifyListeners();
      return false;
    }
  }

  // Remove player from team
  Future<bool> removePlayerFromTeam({
    required String playerId,
    required String teamId,
  }) async {
    try {
      debugPrint('➖ Removing player $playerId from team $teamId');

      final playerQuery = await FirebaseFirestore.instance
          .collection('players')
          .where('playerId', isEqualTo: playerId)
          .limit(1)
          .get();

      if (playerQuery.docs.isEmpty) {
        debugPrint('❌ Player not found with playerId: $playerId');
        _error = 'প্লেয়ার পাওয়া যায়নি';
        notifyListeners();
        return false;
      }

      final playerDocId = playerQuery.docs.first.id;

      await FirebaseFirestore.instance
          .collection('players')
          .doc(playerDocId)
          .update({
        'teamId': null,
        'teamName': null,
      });

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update({
        'playerIds': FieldValue.arrayRemove([playerId]),
      });

      debugPrint('✅ Player removed from team successfully');
      await fetchTeams();
      return true;
    } catch (e) {
      debugPrint('❌ Error removing player from team: $e');
      _error = 'প্লেয়ার সরাতে ব্যর্থ: $e';
      notifyListeners();
      return false;
    }
  }

  // Change player's team
  Future<bool> changePlayerTeam({
    required String playerId,
    required String oldTeamId,
    required String newTeamId,
  }) async {
    try {
      debugPrint('🔄 Changing player $playerId from team $oldTeamId to $newTeamId');

      await removePlayerFromTeam(playerId: playerId, teamId: oldTeamId);
      await addPlayerToTeam(playerId: playerId, teamId: newTeamId);

      debugPrint('✅ Player team changed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error changing player team: $e');
      _error = 'টিম পরিবর্তন করতে ব্যর্থ: $e';
      notifyListeners();
      return false;
    }
  }

  // Get players of a team
  Stream<List<Map<String, dynamic>>> getTeamPlayers(String teamId) {
    return FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .snapshots()
        .asyncMap((teamDoc) async {
      if (!teamDoc.exists) return [];

      final playerIds = List<String>.from(teamDoc.data()?['playerIds'] ?? []);
      if (playerIds.isEmpty) return [];

      final players = <Map<String, dynamic>>[];

      for (String playerId in playerIds) {
        try {
          final playerQuery = await FirebaseFirestore.instance
              .collection('players')
              .where('playerId', isEqualTo: playerId)
              .limit(1)
              .get();

          if (playerQuery.docs.isNotEmpty) {
            players.add({
              'id': playerQuery.docs.first.id,
              ...playerQuery.docs.first.data(),
            });
          }
        } catch (e) {
          debugPrint('❌ Error fetching player $playerId: $e');
        }
      }

      return players;
    });
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

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}