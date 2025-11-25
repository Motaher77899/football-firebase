
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tournament/tournament_model.dart';

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