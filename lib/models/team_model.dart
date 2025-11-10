import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String upazila;
  final String district;
  final String division;
  final String logoUrl;
  final String managerId;        // ✅ এটা যোগ করুন
  final List<String> playerIds;
  final DateTime createdAt;      // ✅ এটা যোগ করুন

  TeamModel({
    required this.id,
    required this.name,
    required this.upazila,
    required this.district,
    required this.division,
    this.logoUrl = '',
    required this.managerId,     // ✅
    this.playerIds = const [],
    required this.createdAt,     // ✅
  });

  // ✅ Getter - automatically calculate from playerIds
  int get playersCount => playerIds.length;

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name'] ?? '',
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      managerId: data['managerId'] ?? '',                                    // ✅
      playerIds: List<String>.from(data['playerIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), // ✅ এইটা হল main fix
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'upazila': upazila,
      'district': district,
      'division': division,
      'logoUrl': logoUrl,
      'managerId': managerId,              // ✅
      'playerIds': playerIds,
      'createdAt': Timestamp.fromDate(createdAt), // ✅
    };
  }
}
