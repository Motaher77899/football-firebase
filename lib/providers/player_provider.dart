
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';
import '../models/user_model.dart';
import 'dart:math';

class PlayerProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PlayerModel? _myPlayer;
  List<String> _favoritePlayerIds = [];
  List<String> _favoriteTeamIds = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  PlayerModel? get myPlayer => _myPlayer;
  List<String> get favoritePlayerIds => _favoritePlayerIds;
  List<String> get favoriteTeamIds => _favoriteTeamIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPlayer => _myPlayer != null;

  // Check if player is favorite
  bool isFavoritePlayer(String playerId) {
    return _favoritePlayerIds.contains(playerId);
  }

  // Check if team is favorite
  bool isFavoriteTeam(String teamId) {
    return _favoriteTeamIds.contains(teamId);
  }

  // Generate unique Player ID
  String _generatePlayerId(String upazila) {
    final random = Random();
    final number = random.nextInt(99999).toString().padLeft(5, '0');
    return '${upazila.replaceAll(' ', '')}-$number';
  }

  // প্রিয় খেলোয়াড় এবং টিম লোড করুন
  Future<void> loadFavorites(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('list')
          .get();

      if (doc.exists) {
        final data = doc.data();
        _favoritePlayerIds = List<String>.from(data?['playerIds'] ?? []);
        _favoriteTeamIds = List<String>.from(data?['teamIds'] ?? []);
        debugPrint('✅ Loaded ${_favoritePlayerIds.length} favorite players');
        debugPrint('✅ Loaded ${_favoriteTeamIds.length} favorite teams');
        notifyListeners();
      } else {
        debugPrint('ℹ️ No favorites document found');
      }
    } catch (e) {
      debugPrint('❌ Error loading favorites: $e');
      _errorMessage = 'প্রিয় তালিকা লোড করতে ব্যর্থ: $e';
    }
  }

  // খেলোয়াড় প্রিয় তে যোগ করুন
  Future<bool> addPlayerToFavorites(String userId, String playerId) async {
    try {
      // Check if already favorite
      if (_favoritePlayerIds.contains(playerId)) {
        debugPrint('ℹ️ Player already in favorites');
        return false;
      }

      // Add to Firestore using arrayUnion
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('list')
          .set(
        {
          'playerIds': FieldValue.arrayUnion([playerId]),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Add to local list
      _favoritePlayerIds.add(playerId);
      debugPrint('✅ Player $playerId added to favorites');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'প্রিয়তে যোগ করতে ব্যর্থ: $e';
      debugPrint('❌ Error adding player to favorites: $e');
      notifyListeners();
      return false;
    }
  }

  // খেলোয়াড় প্রিয় থেকে সরান
  Future<bool> removePlayerFromFavorites(String userId, String playerId) async {
    try {
      // Remove from Firestore using arrayRemove
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('list')
          .update({
        'playerIds': FieldValue.arrayRemove([playerId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Remove from local list
      _favoritePlayerIds.remove(playerId);
      debugPrint('✅ Player $playerId removed from favorites');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'প্রিয় থেকে সরাতে ব্যর্থ: $e';
      debugPrint('❌ Error removing player from favorites: $e');
      notifyListeners();
      return false;
    }
  }

  // টিম প্রিয় তে যোগ করুন
  Future<bool> addTeamToFavorites(String userId, String teamId) async {
    try {
      // Check if already favorite
      if (_favoriteTeamIds.contains(teamId)) {
        debugPrint('ℹ️ Team already in favorites');
        return false;
      }

      // Add to Firestore using arrayUnion
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('list')
          .set(
        {
          'teamIds': FieldValue.arrayUnion([teamId]),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Add to local list
      _favoriteTeamIds.add(teamId);
      debugPrint('✅ Team $teamId added to favorites');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'টিম প্রিয়তে যোগ করতে ব্যর্থ: $e';
      debugPrint('❌ Error adding team to favorites: $e');
      notifyListeners();
      return false;
    }
  }

  // টিম প্রিয় থেকে সরান
  Future<bool> removeTeamFromFavorites(String userId, String teamId) async {
    try {
      // Remove from Firestore using arrayRemove
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc('list')
          .update({
        'teamIds': FieldValue.arrayRemove([teamId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Remove from local list
      _favoriteTeamIds.remove(teamId);
      debugPrint('✅ Team $teamId removed from favorites');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'টিম প্রিয় থেকে সরাতে ব্যর্থ: $e';
      debugPrint('❌ Error removing team from favorites: $e');
      notifyListeners();
      return false;
    }
  }

  // প্রিয় খেলোয়াড়ের তথ্য স্ট্রিম
  Stream<List<PlayerModel>> getFavoritePlayersStream() {
    // If no favorites, return empty list
    if (_favoritePlayerIds.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('players')
        .where(FieldPath.documentId, whereIn: _favoritePlayerIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
        try {
          return PlayerModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('❌ Error parsing player: $e');
          return null;
        }
      })
          .whereType<PlayerModel>()
          .toList();
    });
  }

  // প্রিয় টিমের তথ্য স্ট্রিম
  Stream<List<Map<String, dynamic>>> getFavoriteTeamsStream() {
    // If no favorites, return empty list
    if (_favoriteTeamIds.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('teams')
        .where(FieldPath.documentId, whereIn: _favoriteTeamIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Check if user already has a player profile
  // ✅ রিয়েল-টাইম প্লেয়ার প্রোফাইল চেক (snapshots ব্যবহার করে)
  void listenToPlayerProfile(String userId) {
    _firestore
        .collection('players')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots() // get() এর বদলে snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _myPlayer = PlayerModel.fromFirestore(snapshot.docs.first);
        debugPrint('✅ Player profile updated real-time: ${_myPlayer?.name}');
      } else {
        _myPlayer = null;
      }
      notifyListeners();
    });

    // আলাদাভাবে ফেভারিট লোড করুন
    loadFavorites(userId);
  }

  // ✅ Create player profile from user data (আপডেটেড - profilePhotoUrl support যোগ করা হয়েছে)
  // ✅ Create player profile from user data (আপডেটেড - document ID এবং playerId একই হবে)
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
          .get();

      if (existingPlayer.docs.isNotEmpty) {
        _errorMessage = 'আপনার ইতিমধ্যে একটি প্লেয়ার প্রোফাইল আছে';
        _isLoading = false;
        notifyListeners();
        debugPrint('⚠️ Player profile already exists');
        return false;
      }

      // ✅ Generate unique player ID
      String playerId = _generatePlayerId(user.upazila);

      // ✅ Check if playerId already exists (very unlikely but checking anyway)
      QuerySnapshot playerIdCheck = await _firestore
          .collection('players')
          .where('playerId', isEqualTo: playerId)
          .get();

      // If exists, regenerate
      while (playerIdCheck.docs.isNotEmpty) {
        playerId = _generatePlayerId(user.upazila);
        playerIdCheck = await _firestore
            .collection('players')
            .where('playerId', isEqualTo: playerId)
            .get();
      }

      // ✅ Create player document with custom ID (document ID এবং playerId একই)
      await _firestore.collection('players').doc(playerId).set({
        'userId': user.uid,
        'name': user.fullName,
        'position': position,
        'imageUrl': '', // পুরাতন field (backward compatibility)
        'profilePhotoUrl': user.profilePhotoUrl, // ✅ User এর ছবি
        'upazila': user.upazila,
        'district': user.district,
        'division': user.division,
        'dateOfBirth': Timestamp.fromDate(user.dateOfBirth),
        'playerId': playerId, // ✅ document ID এবং playerId একই
        'teamName': null,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      // ✅ Fetch the created player
      DocumentSnapshot doc = await _firestore
          .collection('players')
          .doc(playerId)
          .get();

      _myPlayer = PlayerModel.fromFirestore(doc);

      debugPrint('✅ Player profile created: ${_myPlayer?.name}');
      debugPrint('✅ Document ID: $playerId');
      debugPrint('✅ Player ID: ${_myPlayer?.playerId}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'প্লেয়ার প্রোফাইল তৈরি করতে ব্যর্থ: $e';
      debugPrint('❌ Error creating player profile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  // ✅ Update player position using copyWith
  Future<bool> updatePlayerPosition(String position) async {
    if (_myPlayer == null) {
      _errorMessage = 'প্লেয়ার প্রোফাইল নেই';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ১. ফায়ারবেসে আপডেট করুন
      await _firestore.collection('players').doc(_myPlayer!.id).update({
        'position': position,
      });

      // ২. copyWith ব্যবহার করে লোকাল স্টেট আপডেট করুন
      // এটি অনেক বেশি নিরাপদ কারণ এতে অন্য কোনো ডেটা হারানোর ভয় থাকে না
      _myPlayer = _myPlayer!.copyWith(position: position);

      debugPrint('✅ Player position updated to: $position');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'আপডেট ব্যর্থ: $e';
      debugPrint('❌ Error updating player position: $e');

      // এরর হলেও অবশ্যই লোডিং ফলস করতে হবে যেন UI-তে চাকা ঘোরা বন্ধ হয়
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get player's matches
  Stream<List<Map<String, dynamic>>> getPlayerMatches() {
    if (_myPlayer == null) {
      debugPrint('⚠️ No player profile found');
      return Stream.value([]);
    }

    return _firestore
        .collection('matches')
        .where('status', isEqualTo: 'finished')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> playerMatches = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final teamA = (data['teamA'] as String?)?.toLowerCase() ?? '';
        final teamB = (data['teamB'] as String?)?.toLowerCase() ?? '';
        final playerUpazila = _myPlayer!.upazila.toLowerCase();

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

  // উপজেলা অনুযায়ী সব খেলোয়াড় ফেচ করুন (Real-time)
  Stream<List<PlayerModel>> getPlayersByUpazila(String upazila) {
    return _firestore
        .collection('players')
        .where('upazila', isEqualTo: upazila)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
        try {
          return PlayerModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('❌ Error parsing player: $e');
          return null;
        }
      })
          .whereType<PlayerModel>()
          .toList();
    });
  }

  // সকল খেলোয়াড় ফেচ করুন (সার্চিং এর জন্য)
  Stream<List<PlayerModel>> getAllPlayers() {
    return _firestore
        .collection('players')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
        try {
          return PlayerModel.fromFirestore(doc);
        } catch (e) {
          debugPrint('❌ Error parsing player: $e');
          return null;
        }
      })
          .whereType<PlayerModel>()
          .toList();
    });
  }

  // প্রিয় খেলোয়াড়ের সম্পূর্ণ তথ্য স্ট্রিম
  Stream<List<PlayerModel>> getFavoritePlayers(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('list')
        .snapshots()
        .asyncMap((snapshot) async {
      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.data();
      final playerIds = List<String>.from(data?['playerIds'] ?? []);

      // Update local cache
      _favoritePlayerIds = playerIds;
      notifyListeners();

      if (playerIds.isEmpty) {
        return [];
      }

      // Fetch player details
      final players = <PlayerModel>[];
      for (String playerId in playerIds) {
        try {
          final playerDoc =
          await _firestore.collection('players').doc(playerId).get();

          if (playerDoc.exists) {
            players.add(PlayerModel.fromFirestore(playerDoc));
          }
        } catch (e) {
          debugPrint('❌ Error fetching player $playerId: $e');
        }
      }

      return players;
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearPlayer() {
    _myPlayer = null;
    _favoritePlayerIds.clear();
    _favoriteTeamIds.clear();
    notifyListeners();
  }
  // ✅ রিয়েল-টাইম প্লেয়ার প্রোফাইল চেক
  Future<void> checkPlayerProfile(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

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

      await loadFavorites(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'প্লেয়ার প্রোফাইল লোড করতে ব্যর্থ';
      notifyListeners();
    }
  }
}