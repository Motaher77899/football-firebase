import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add sample teams
  Future<void> addSampleTeams() async {
    try {
      // Team 1
      await _firestore.collection('teams').add({
        'name': 'ঢাকা ফুটবল ক্লাব',
        'upazila': 'ঢাকা',
        'logoUrl': 'https://example.com/team1.png',
        'playersCount': 15,
      });

      // Team 2
      await _firestore.collection('teams').add({
        'name': 'চট্টগ্রাম স্পোর্টস ক্লাব',
        'upazila': 'চট্টগ্রাম',
        'logoUrl': 'https://example.com/team2.png',
        'playersCount': 16,
      });

      // Team 3
      await _firestore.collection('teams').add({
        'name': 'সিলেট ইউনাইটেড',
        'upazila': 'সিলেট',
        'logoUrl': 'https://example.com/team3.png',
        'playersCount': 14,
      });

      // Team 4
      await _firestore.collection('teams').add({
        'name': 'রাজশাহী রয়্যালস',
        'upazila': 'রাজশাহী',
        'logoUrl': 'https://example.com/team4.png',
        'playersCount': 15,
      });

      print('Sample teams added successfully!');
    } catch (e) {
      print('Error adding sample teams: $e');
    }
  }

  // Add sample matches
  Future<void> addSampleMatches() async {
    try {
      // Live Match
      await _firestore.collection('matches').add({
        'teamA': 'ঢাকা ফুটবল ক্লাব',
        'teamB': 'চট্টগ্রাম স্পোর্টস ক্লাব',
        'scoreA': 2,
        'scoreB': 1,
        'matchTime': Timestamp.fromDate(DateTime.now()),
        'status': 'live',
      });

      // Upcoming Match
      await _firestore.collection('matches').add({
        'teamA': 'সিলেট ইউনাইটেড',
        'teamB': 'রাজশাহী রয়্যালস',
        'scoreA': 0,
        'scoreB': 0,
        'matchTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1)),
        ),
        'status': 'upcoming',
      });

      // Finished Match
      await _firestore.collection('matches').add({
        'teamA': 'ঢাকা ফুটবল ক্লাব',
        'teamB': 'রাজশাহী রয়্যালস',
        'scoreA': 3,
        'scoreB': 2,
        'matchTime': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'status': 'finished',
      });

      // Another Upcoming Match
      await _firestore.collection('matches').add({
        'teamA': 'চট্টগ্রাম স্পোর্টস ক্লাব',
        'teamB': 'সিলেট ইউনাইটেড',
        'scoreA': 0,
        'scoreB': 0,
        'matchTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 2)),
        ),
        'status': 'upcoming',
      });

      print('Sample matches added successfully!');
    } catch (e) {
      print('Error adding sample matches: $e');
    }
  }

  // Add sample players
  Future<void> addSamplePlayers() async {
    try {
      // Player 1
      await _firestore.collection('players').add({
        'name': 'মোহাম্মদ রহিম',
        'position': 'ফরওয়ার্ড',
        'imageUrl': 'https://example.com/player1.png',
      });

      // Player 2
      await _firestore.collection('players').add({
        'name': 'আহমেদ করিম',
        'position': 'মিডফিল্ডার',
        'imageUrl': 'https://example.com/player2.png',
      });

      // Player 3
      await _firestore.collection('players').add({
        'name': 'সাকিব হাসান',
        'position': 'ডিফেন্ডার',
        'imageUrl': 'https://example.com/player3.png',
      });

      // Player 4
      await _firestore.collection('players').add({
        'name': 'রফিক উদ্দিন',
        'position': 'গোলকিপার',
        'imageUrl': 'https://example.com/player4.png',
      });

      print('Sample players added successfully!');
    } catch (e) {
      print('Error adding sample players: $e');
    }
  }

  // Add sample tournament
  Future<void> addSampleTournament() async {
    try {
      await _firestore.collection('tournaments').add({
        'name': 'বাংলাদেশ জাতীয় ফুটবল লিগ ২০২৫',
        'startDate': Timestamp.fromDate(DateTime(2025, 1, 1)),
        'logoUrl': 'https://example.com/tournament.png',
      });

      print('Sample tournament added successfully!');
    } catch (e) {
      print('Error adding sample tournament: $e');
    }
  }

  // Initialize all sample data
  Future<void> initializeSampleData() async {
    await addSampleTeams();
    await addSamplePlayers();
    await addSampleTournament();
    await addSampleMatches();
    print('All sample data initialized successfully!');
  }

  // Clear all data (use with caution!)
  Future<void> clearAllData() async {
    try {
      // Clear matches
      var matchesSnapshot = await _firestore.collection('matches').get();
      for (var doc in matchesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear teams
      var teamsSnapshot = await _firestore.collection('teams').get();
      for (var doc in teamsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear players
      var playersSnapshot = await _firestore.collection('players').get();
      for (var doc in playersSnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear tournaments
      var tournamentsSnapshot =
      await _firestore.collection('tournaments').get();
      for (var doc in tournamentsSnapshot.docs) {
        await doc.reference.delete();
      }

      print('All data cleared successfully!');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}