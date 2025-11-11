import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  final String id;
  final String name;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'upcoming', 'ongoing', 'completed'
  final String imageUrl;
  final int totalTeams;
  final String prizePool;
  final String organizerName;
  final String organizerContact;
  final DateTime createdAt;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.imageUrl = '',
    required this.totalTeams,
    this.prizePool = '',
    required this.organizerName,
    this.organizerContact = '',
    required this.createdAt,
  });

  // Firebase থেকে data নেওয়ার জন্য
  factory Tournament.fromMap(Map<String, dynamic> map, String id) {
    return Tournament(
      id: id,
      name: _parseString(map['name']),
      description: _parseString(map['description']),
      location: _parseString(map['location']),
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      status: _parseString(map['status'], defaultValue: 'upcoming'),
      imageUrl: _parseString(map['imageUrl']),
      totalTeams: _parseInt(map['totalTeams']),
      prizePool: _parseString(map['prizePool']),
      organizerName: _parseString(map['organizerName']),
      organizerContact: _parseString(map['organizerContact']),
      createdAt: _parseDate(map['createdAt']),
    );
  }

  // Helper method to safely parse String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  // Helper method to safely parse int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper method to parse dates from both Timestamp and String
  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();

    // যদি Timestamp object হয়
    if (date is Timestamp) {
      return date.toDate();
    }

    // যদি String হয়
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }

    // Default
    return DateTime.now();
  }

  // Firebase এ data পাঠানোর জন্য
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
      'totalTeams': totalTeams,
      'prizePool': prizePool,
      'organizerName': organizerName,
      'organizerContact': organizerContact,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Status এর বাংলা text
  String get statusInBengali {
    switch (status) {
      case 'upcoming':
        return 'আসন্ন';
      case 'ongoing':
        return 'চলমান';
      case 'completed':
        return 'সমাপ্ত';
      default:
        return 'অজানা';
    }
  }

  // Status এর color
  String get statusColor {
    switch (status) {
      case 'upcoming':
        return '0xFF2196F3'; // Blue
      case 'ongoing':
        return '0xFF4CAF50'; // Green
      case 'completed':
        return '0xFF9E9E9E'; // Grey
      default:
        return '0xFF9E9E9E';
    }
  }
}