// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/player_model.dart';
// import '../models/user_model.dart';
// import 'dart:math';
//
// class PlayerProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   PlayerModel? _myPlayer;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   PlayerModel? get myPlayer => _myPlayer;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   bool get hasPlayer => _myPlayer != null;
//
//   // Generate unique Player ID
//   String _generatePlayerId(String upazila) {
//     final random = Random();
//     final number = random.nextInt(99999).toString().padLeft(5, '0');
//     return '${upazila.replaceAll(' ', '')}-$number';
//   }
//
//   // Check if user already has a player profile
//   Future<void> checkPlayerProfile(String userId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('players')
//           .where('userId', isEqualTo: userId)
//           .limit(1)
//           .get();
//
//       if (snapshot.docs.isNotEmpty) {
//         _myPlayer = PlayerModel.fromFirestore(snapshot.docs.first);
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error checking player profile: $e');
//     }
//   }
//
//   // Create player profile from user data
//   Future<bool> createPlayerProfile({
//     required UserModel user,
//     required String position,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       // Check if player already exists
//       QuerySnapshot existingPlayer = await _firestore
//           .collection('players')
//           .where('userId', isEqualTo: user.uid)
//           .get();
//
//       if (existingPlayer.docs.isNotEmpty) {
//         _errorMessage = 'আপনার ইতিমধ্যে একটি প্লেয়ার প্রোফাইল আছে';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       // Generate unique player ID
//       String playerId = _generatePlayerId(user.upazila);
//
//       // Check if playerId already exists (very unlikely)
//       QuerySnapshot playerIdCheck = await _firestore
//           .collection('players')
//           .where('playerId', isEqualTo: playerId)
//           .get();
//
//       // If exists, regenerate
//       while (playerIdCheck.docs.isNotEmpty) {
//         playerId = _generatePlayerId(user.upazila);
//         playerIdCheck = await _firestore
//             .collection('players')
//             .where('playerId', isEqualTo: playerId)
//             .get();
//       }
//
//       // Create player document
//       DocumentReference docRef = await _firestore.collection('players').add({
//         'userId': user.uid,
//         'name': user.fullName,
//         'position': position,
//         'imageUrl': '', // No photo
//         'upazila': user.upazila,
//         'district': user.district,
//         'division': user.division,
//         'dateOfBirth': Timestamp.fromDate(user.dateOfBirth),
//         'playerId': playerId,
//         'teamName': null, // Initially no team
//         'createdAt': Timestamp.fromDate(DateTime.now()),
//       });
//
//       // Fetch the created player
//       DocumentSnapshot doc = await docRef.get();
//       _myPlayer = PlayerModel.fromFirestore(doc);
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = 'প্লেয়ার প্রোফাইল তৈরি করতে ব্যর্থ: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Update player position
//   Future<bool> updatePlayerPosition(String position) async {
//     if (_myPlayer == null) return false;
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       await _firestore.collection('players').doc(_myPlayer!.id).update({
//         'position': position,
//       });
//
//       // Update local data
//       _myPlayer = PlayerModel(
//         id: _myPlayer!.id,
//         userId: _myPlayer!.userId,
//         name: _myPlayer!.name,
//         position: position,
//         imageUrl: _myPlayer!.imageUrl,
//         upazila: _myPlayer!.upazila,
//         district: _myPlayer!.district,
//         division: _myPlayer!.division,
//         dateOfBirth: _myPlayer!.dateOfBirth,
//         playerId: _myPlayer!.playerId,
//         createdAt: _myPlayer!.createdAt,
//       );
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = 'আপডেট ব্যর্থ: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Get player's matches
//   Stream<List<Map<String, dynamic>>> getPlayerMatches() {
//     if (_myPlayer == null) {
//       return Stream.value([]);
//     }
//
//     return _firestore
//         .collection('matches')
//         .where('status', isEqualTo: 'finished')
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       List<Map<String, dynamic>> playerMatches = [];
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final teamA = (data['teamA'] as String).toLowerCase();
//         final teamB = (data['teamB'] as String).toLowerCase();
//         final playerUpazila = _myPlayer!.upazila.toLowerCase();
//
//         // Check if match is from player's upazila
//         if (teamA.contains(playerUpazila) || teamB.contains(playerUpazila)) {
//           playerMatches.add({
//             'id': doc.id,
//             ...data,
//           });
//         }
//       }
//
//       return playerMatches;
//     });
//   }
//
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
//
//   void clearPlayer() {
//     _myPlayer = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';
import '../models/user_model.dart';
import 'dart:math';

class PlayerProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PlayerModel? _myPlayer;
  bool _isLoading = false;
  String? _errorMessage;

  PlayerModel? get myPlayer => _myPlayer;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPlayer => _myPlayer != null;

  // Generate unique Player ID
  String _generatePlayerId(String upazila) {
    final random = Random();
    // Use an absolute value for the hash to avoid issues, though Random().nextInt is usually positive.
    final hash = upazila.replaceAll(' ', '').toUpperCase().hashCode.abs() % 1000;
    final number = random.nextInt(9999).toString().padLeft(4, '0');
    return '${hash.toString().padLeft(3, '0')}-$number'; // Example: 345-0123
  }

  // Check if user already has a player profile
  Future<void> checkPlayerProfile(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('players')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _myPlayer = PlayerModel.fromFirestore(snapshot.docs.first);
      } else {
        _myPlayer = null;
      }
    } catch (e) {
      debugPrint('Error checking player profile: $e');
      _errorMessage = 'প্লেয়ার প্রোফাইল চেক করতে ব্যর্থ: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create player profile from user data
  Future<bool> createPlayerProfile({
    required UserModel user,
    required String position,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if player already exists
      QuerySnapshot existingPlayer = await _firestore
          .collection('players')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (existingPlayer.docs.isNotEmpty) {
        _errorMessage = 'আপনার ইতিমধ্যে একটি প্লেয়ার প্রোফাইল আছে';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Generate unique player ID
      String playerId = _generatePlayerId(user.upazila);

      // Check if playerId already exists (very unlikely but safer to check)
      QuerySnapshot playerIdCheck;
      do {
        playerIdCheck = await _firestore
            .collection('players')
            .where('playerId', isEqualTo: playerId)
            .limit(1)
            .get();
        if (playerIdCheck.docs.isNotEmpty) {
          playerId = _generatePlayerId(user.upazila); // Regenerate if found
        }
      } while (playerIdCheck.docs.isNotEmpty);


      // Create player document
      DocumentReference docRef = await _firestore.collection('players').add({
        'userId': user.uid,
        'name': user.fullName,
        'position': position,
        // Using user's photo URL or empty string
        'upazila': user.upazila,
        'district': user.district,
        'division': user.division,
        // Make sure user.dateOfBirth is a non-null DateTime
        'dateOfBirth': Timestamp.fromDate(user.dateOfBirth),
        'playerId': playerId,
        'teamName': null, // Initially no team
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      // Fetch the created player
      DocumentSnapshot doc = await docRef.get();
      _myPlayer = PlayerModel.fromFirestore(doc);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'প্লেয়ার প্রোফাইল তৈরি করতে ব্যর্থ: $e';
      debugPrint('Error creating player profile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update player position
  Future<bool> updatePlayerPosition(String position) async {
    if (_myPlayer == null) {
      _errorMessage = 'প্রোফাইল লোড হয়নি।';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('players').doc(_myPlayer!.id).update({
        'position': position,
      });

      // 💡 সংশোধন: `copyWith` ব্যবহার করে সব প্রপার্টি স্বয়ংক্রিয়ভাবে রাখা হয়েছে
      _myPlayer = _myPlayer!.copyWith(
        position: position,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'আপডেট ব্যর্থ: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get player's matches based on their upazila
  Stream<List<Map<String, dynamic>>> getPlayerMatches() {
    if (_myPlayer == null) {
      return Stream.value([]);
    }

    final playerUpazila = _myPlayer!.upazila.toLowerCase();

    return _firestore
        .collection('matches')
        .where('status', isEqualTo: 'finished')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> playerMatches = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // 💡 পরিবর্তন: Null-safe কাস্টিং ব্যবহার করা হয়েছে
        final teamA = (data['teamA'] as String? ?? '').toLowerCase();
        final teamB = (data['teamB'] as String? ?? '').toLowerCase();

        // Check if match is from player's upazila (assuming team names contain upazila names)
        if (teamA.contains(playerUpazila) || teamB.contains(playerUpazila)) {
          playerMatches.add({
            'id': doc.id,
            ...data,
          });
        }
      }

      return playerMatches;
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearPlayer() {
    _myPlayer = null;
    notifyListeners();
  }
}