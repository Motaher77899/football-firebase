// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TeamModel {
//   final String id;
//   final String name;
//   final String upazila;
//   final String district;
//   final String division;
//   final String logoUrl;
//   final String managerId;        // ✅ এটা যোগ করুন
//   final List<String> playerIds;
//   final DateTime createdAt;      // ✅ এটা যোগ করুন
//
//   TeamModel({
//     required this.id,
//     required this.name,
//     required this.upazila,
//     required this.district,
//     required this.division,
//     this.logoUrl = '',
//     required this.managerId,     // ✅
//     this.playerIds = const [],
//     required this.createdAt,     // ✅
//   });
//
//   // ✅ Getter - automatically calculate from playerIds
//   int get playersCount => playerIds.length;
//
//   factory TeamModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return TeamModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       upazila: data['upazila'] ?? '',
//       district: data['district'] ?? '',
//       division: data['division'] ?? '',
//       logoUrl: data['logoUrl'] ?? '',
//       managerId: data['managerId'] ?? '',                                    // ✅
//       playerIds: List<String>.from(data['playerIds'] ?? []),
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), // ✅ এইটা হল main fix
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'upazila': upazila,
//       'district': district,
//       'division': division,
//       'logoUrl': logoUrl,
//       'managerId': managerId,              // ✅
//       'playerIds': playerIds,
//       'createdAt': Timestamp.fromDate(createdAt), // ✅
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String upazila;
  final String district;
  final String division;
  final String logoUrl;
  final String managerId;
  final List<String> playerIds;
  final DateTime createdAt;

  TeamModel({
    required this.id,
    required this.name,
    required this.upazila,
    required this.district,
    required this.division,
    this.logoUrl = '',
    required this.managerId,
    this.playerIds = const [],
    required this.createdAt,
  });

  // ✅ Getter - automatically calculate from playerIds
  int get playersCount => playerIds.length;

  // ✅ Method 1: fromFirestore (for DocumentSnapshot)
  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamModel.fromMap(data, doc.id);
  }

  // ✅ Method 2: fromMap (MUST HAVE!)
  factory TeamModel.fromMap(Map<String, dynamic> data, String id) {
    return TeamModel(
      id: id,
      name: data['name'] ?? '',
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      managerId: data['managerId'] ?? '',
      playerIds: List<String>.from(data['playerIds'] ?? []),
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  // ✅ Helper method to parse timestamp
  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // ✅ toFirestore method
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'upazila': upazila,
      'district': district,
      'division': division,
      'logoUrl': logoUrl,
      'managerId': managerId,
      'playerIds': playerIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ✅ toMap method (for general use)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'upazila': upazila,
      'district': district,
      'division': division,
      'logoUrl': logoUrl,
      'managerId': managerId,
      'playerIds': playerIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ✅ copyWith method (for updates)
  TeamModel copyWith({
    String? id,
    String? name,
    String? upazila,
    String? district,
    String? division,
    String? logoUrl,
    String? managerId,
    List<String>? playerIds,
    DateTime? createdAt,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      upazila: upazila ?? this.upazila,
      district: district ?? this.district,
      division: division ?? this.division,
      logoUrl: logoUrl ?? this.logoUrl,
      managerId: managerId ?? this.managerId,
      playerIds: playerIds ?? this.playerIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'TeamModel(id: $id, name: $name, players: ${playerIds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}