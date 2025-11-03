import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';
import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PlayerModel> _players = [];

  List<PlayerModel> get players => _players;

  Future<void> fetchPlayersByTeam(String teamName) async {
    try {
      final snapshot = await _firestore
          .collection('players')
          .where('teamName', isEqualTo: teamName)
          .get();

      _players = snapshot.docs
          .map((doc) => PlayerModel.fromFirestore(doc))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching players: $e');
    }
  }
}
