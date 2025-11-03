import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/team_model.dart';

class TeamProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TeamModel> _teams = [];
  bool _isLoading = false;

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;

  // Fetch all teams
  Future<void> fetchTeams() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('teams')
          .orderBy('name')
          .get();

      _teams = snapshot.docs
          .map((doc) => TeamModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error fetching teams: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Stream teams
  Stream<List<TeamModel>> streamTeams() {
    return _firestore
        .collection('teams')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TeamModel.fromFirestore(doc))
        .toList());
  }

  // Get team by ID
  TeamModel? getTeamById(String teamId) {
    try {
      return _teams.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }

  // Get team by name
  TeamModel? getTeamByName(String teamName) {
    try {
      return _teams.firstWhere((team) => team.name == teamName);
    } catch (e) {
      return null;
    }
  }

  // Add new team
  Future<void> addTeam(TeamModel team) async {
    try {
      await _firestore.collection('teams').add(team.toFirestore());
      await fetchTeams();
    } catch (e) {
      debugPrint('Error adding team: $e');
    }
  }
}