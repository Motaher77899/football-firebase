import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final DateTime time; // 'time' field থেকে
  final DateTime date; // 'date' field থেকে
  final String status;
  final String? tournament;
  final String? venue;


  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.time,
    required this.date,
    required this.status,
    this.tournament,
    this.venue,

  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      id: doc.id,
      teamA: data['teamA'] ?? '',
      teamB: data['teamB'] ?? '',
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      time: (data['time'] as Timestamp).toDate(),
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'upcoming',
      tournament: data['tournament'],
      venue: data['venue'],

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'time': Timestamp.fromDate(time),
      'date': Timestamp.fromDate(date),
      'status': status,
      'tournament': tournament,
      'venue': venue,

    };
  }

  // Match time এর জন্য helper
  DateTime get matchTime => date;
}
