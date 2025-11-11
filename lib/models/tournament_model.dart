import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final String logoUrl;
  final String description;
  final String location;
  final List<String> teams; // Team IDs এর array
  final int totalMatches;
  final String status; // 'upcoming', 'ongoing', 'completed'
  final String organizer;

  TournamentModel({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.logoUrl,
    this.description = '',
    this.location = '',
    this.teams = const [], // Default empty array
    this.totalMatches = 0,
    this.status = 'upcoming',
    this.organizer = '',
  });

  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // teams field থেকে array নিন
    List<String> teamsList = [];
    if (data['teams'] != null) {
      teamsList = List<String>.from(data['teams']);
    }

    return TournamentModel(
      id: doc.id,
      name: data['name'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
      logoUrl: data['logoUrl'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      teams: teamsList,
      totalMatches: data['totalMatches'] ?? 0,
      status: data['status'] ?? 'upcoming',
      organizer: data['organizer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'logoUrl': logoUrl,
      'description': description,
      'location': location,
      'teams': teams, // Array হিসেবে save হবে
      'totalMatches': totalMatches,
      'status': status,
      'organizer': organizer,
    };
  }

  // Helper methods
  bool get isOngoing => status == 'ongoing';
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';

  // Total teams count
  int get totalTeams => teams.length;

  String get statusBangla {
    switch (status) {
      case 'ongoing':
        return 'চলমান';
      case 'upcoming':
        return 'আসন্ন';
      case 'completed':
        return 'সমাপ্ত';
      default:
        return 'অজানা';
    }
  }

  String get durationText {
    if (endDate == null) {
      return 'শুরু: ${_formatDate(startDate)}';
    }
    return '${_formatDate(startDate)} - ${_formatDate(endDate!)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}