// lib/services/match_service.dart এ এই method add করো অথবা update করো

import 'package:cloud_firestore/cloud_firestore.dart';

import 'ranking_service.dart';

class MatchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RankingService _rankingService = RankingService();

  // Match complete করার method
  Future<void> completeMatch(String matchId) async {
    try {
      // Match data fetch করো
      final matchDoc = await _firestore.collection('matches').doc(matchId).get();
      if (!matchDoc.exists) {
        throw Exception('Match not found');
      }

      final matchData = matchDoc.data()!;
      final homeTeamId = matchData['homeTeamId'];
      final awayTeamId = matchData['awayTeamId'];
      final homeScore = matchData['homeScore'] ?? 0;
      final awayScore = matchData['awayScore'] ?? 0;

      // Match status update করো
      await _firestore.collection('matches').doc(matchId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Determine match result
      bool homeWon = homeScore > awayScore;
      bool awayWon = awayScore > homeScore;
      bool isDraw = homeScore == awayScore;

      // Get cards count for both teams
      final matchEvents = await _firestore
          .collection('matches')
          .doc(matchId)
          .collection('events')
          .get();

      int homeYellowCards = 0;
      int homeRedCards = 0;
      int awayYellowCards = 0;
      int awayRedCards = 0;

      for (var event in matchEvents.docs) {
        final eventData = event.data();
        final eventType = eventData['type'];
        final teamId = eventData['teamId'];

        if (eventType == 'yellow_card') {
          if (teamId == homeTeamId) {
            homeYellowCards++;
          } else {
            awayYellowCards++;
          }
        } else if (eventType == 'red_card') {
          if (teamId == homeTeamId) {
            homeRedCards++;
          } else {
            awayRedCards++;
          }
        }
      }

      // Update home team ranking
      await _rankingService.updateTeamRanking(
        teamId: homeTeamId,
        won: homeWon,
        draw: isDraw,
        goalsScored: homeScore,
        goalsConceded: awayScore,
        yellowCards: homeYellowCards,
        redCards: homeRedCards,
      );

      // Update away team ranking
      await _rankingService.updateTeamRanking(
        teamId: awayTeamId,
        won: awayWon,
        draw: isDraw,
        goalsScored: awayScore,
        goalsConceded: homeScore,
        yellowCards: awayYellowCards,
        redCards: awayRedCards,
      );

      // Update player rankings
      await _updatePlayerRankingsForMatch(matchId, homeTeamId, awayTeamId, homeScore, awayScore);

      print('Match completed and rankings updated successfully');
    } catch (e) {
      print('Error completing match: $e');
      rethrow;
    }
  }

  // Player rankings update করার helper method
  Future<void> _updatePlayerRankingsForMatch(
      String matchId,
      String homeTeamId,
      String awayTeamId,
      int homeScore,
      int awayScore,
      ) async {
    try {
      // Get all match events
      final events = await _firestore
          .collection('matches')
          .doc(matchId)
          .collection('events')
          .get();

      // Track player stats from this match
      Map<String, Map<String, int>> playerStats = {};

      for (var event in events.docs) {
        final eventData = event.data();
        final eventType = eventData['type'];
        final playerId = eventData['playerId'];

        if (playerId == null) continue;

        // Initialize player stats if not exists
        if (!playerStats.containsKey(playerId)) {
          playerStats[playerId] = {
            'goals': 0,
            'assists': 0,
            'yellowCards': 0,
            'redCards': 0,
          };
        }

        // Count events
        switch (eventType) {
          case 'goal':
            playerStats[playerId]!['goals'] =
                (playerStats[playerId]!['goals'] ?? 0) + 1;

            // Check for assist
            final assistPlayerId = eventData['assistPlayerId'];
            if (assistPlayerId != null) {
              if (!playerStats.containsKey(assistPlayerId)) {
                playerStats[assistPlayerId] = {
                  'goals': 0,
                  'assists': 0,
                  'yellowCards': 0,
                  'redCards': 0,
                };
              }
              playerStats[assistPlayerId]!['assists'] =
                  (playerStats[assistPlayerId]!['assists'] ?? 0) + 1;
            }
            break;

          case 'yellow_card':
            playerStats[playerId]!['yellowCards'] =
                (playerStats[playerId]!['yellowCards'] ?? 0) + 1;
            break;

          case 'red_card':
            playerStats[playerId]!['redCards'] =
                (playerStats[playerId]!['redCards'] ?? 0) + 1;
            break;
        }
      }

      // Get lineup to check for clean sheets (goalkeepers and defenders)
      final matchDoc = await _firestore.collection('matches').doc(matchId).get();
      final matchData = matchDoc.data();

      if (matchData != null) {
        final homeLineup = matchData['homeLineup'] as List<dynamic>? ?? [];
        final awayLineup = matchData['awayLineup'] as List<dynamic>? ?? [];

        // Check clean sheet for home team (if away team scored 0)
        if (awayScore == 0) {
          for (var playerData in homeLineup) {
            final playerId = playerData['playerId'];
            final position = playerData['position'] ?? '';

            // Clean sheet only for GK and defenders
            if (position == 'Goalkeeper' || position == 'Defender') {
              if (!playerStats.containsKey(playerId)) {
                playerStats[playerId] = {
                  'goals': 0,
                  'assists': 0,
                  'yellowCards': 0,
                  'redCards': 0,
                };
              }
              // We'll handle clean sheet in the update method
            }
          }
        }

        // Check clean sheet for away team (if home team scored 0)
        if (homeScore == 0) {
          for (var playerData in awayLineup) {
            final playerId = playerData['playerId'];
            final position = playerData['position'] ?? '';

            if (position == 'Goalkeeper' || position == 'Defender') {
              if (!playerStats.containsKey(playerId)) {
                playerStats[playerId] = {
                  'goals': 0,
                  'assists': 0,
                  'yellowCards': 0,
                  'redCards': 0,
                };
              }
            }
          }
        }
      }

      // Update rankings for all players who participated
      for (var entry in playerStats.entries) {
        final playerId = entry.key;
        final stats = entry.value;

        // Check if player is GK/Defender and if clean sheet
        final playerDoc = await _firestore.collection('players').doc(playerId).get();
        final playerPosition = playerDoc.data()?['position'] ?? '';
        final playerTeamId = playerDoc.data()?['teamId'] ?? '';

        bool cleanSheet = false;
        if (playerPosition == 'Goalkeeper' || playerPosition == 'Defender') {
          if (playerTeamId == homeTeamId && awayScore == 0) {
            cleanSheet = true;
          } else if (playerTeamId == awayTeamId && homeScore == 0) {
            cleanSheet = true;
          }
        }

        await _rankingService.updatePlayerRanking(
          playerId: playerId,
          goals: stats['goals'] ?? 0,
          assists: stats['assists'] ?? 0,
          cleanSheet: cleanSheet,
          yellowCards: stats['yellowCards'] ?? 0,
          redCards: stats['redCards'] ?? 0,
        );
      }

      // Also update players in lineup who didn't have events (for match played count)
      if (matchData != null) {
        final allLineupPlayers = [
          ...(matchData['homeLineup'] as List<dynamic>? ?? []),
          ...(matchData['awayLineup'] as List<dynamic>? ?? []),
        ];

        for (var playerData in allLineupPlayers) {
          final playerId = playerData['playerId'];

          // Skip if already updated
          if (playerStats.containsKey(playerId)) continue;

          // Check clean sheet for this player
          final playerPosition = playerData['position'] ?? '';
          final playerTeamId = playerData['teamId'] ?? '';

          bool cleanSheet = false;
          if (playerPosition == 'Goalkeeper' || playerPosition == 'Defender') {
            if (playerTeamId == homeTeamId && awayScore == 0) {
              cleanSheet = true;
            } else if (playerTeamId == awayTeamId && homeScore == 0) {
              cleanSheet = true;
            }
          }

          // Update with zero stats but increment match played
          await _rankingService.updatePlayerRanking(
            playerId: playerId,
            cleanSheet: cleanSheet,
          );
        }
      }

    } catch (e) {
      print('Error updating player rankings: $e');
      // Don't rethrow, let match completion succeed even if ranking update fails
    }
  }
}