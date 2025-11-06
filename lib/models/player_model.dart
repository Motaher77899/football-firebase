// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PlayerModel {
//   final String id;
//   final String userId; // Link to user account
//   final String name;
//   final String position;
//   final String imageUrl;
//   final String upazila;
//   final String district;
//   final String division;
//   final DateTime dateOfBirth;
//   final String playerId; // Auto-generated ID like "Dhaka-12345"
//   final String? teamName; // Optional team name
//   final DateTime createdAt;
//
//   PlayerModel({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.position,
//     required this.imageUrl,
//     required this.upazila,
//     required this.district,
//     required this.division,
//     required this.dateOfBirth,
//     required this.playerId,
//     this.teamName,
//     required this.createdAt,
//   });
//
//   factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return PlayerModel(
//       id: doc.id,
//       userId: data['userId'] ?? '',
//       name: data['name'] ?? '',
//       position: data['position'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//       upazila: data['upazila'] ?? '',
//       district: data['district'] ?? '',
//       division: data['division'] ?? '',
//       dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
//       playerId: data['playerId'] ?? '',
//       teamName: data['teamName'],
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'userId': userId,
//       'name': name,
//       'position': position,
//       'imageUrl': imageUrl,
//       'upazila': upazila,
//       'district': district,
//       'division': division,
//       'dateOfBirth': Timestamp.fromDate(dateOfBirth),
//       'playerId': playerId,
//       'teamName': teamName,
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }
//
//   // Copy with method for updates
//   PlayerModel copyWith({
//     String? id,
//     String? userId,
//     String? name,
//     String? position,
//     String? imageUrl,
//     String? upazila,
//     String? district,
//     String? division,
//     DateTime? dateOfBirth,
//     String? playerId,
//     String? teamName,
//     DateTime? createdAt,
//   }) {
//     return PlayerModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       name: name ?? this.name,
//       position: position ?? this.position,
//       imageUrl: imageUrl ?? this.imageUrl,
//       upazila: upazila ?? this.upazila,
//       district: district ?? this.district,
//       division: division ?? this.division,
//       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
//       playerId: playerId ?? this.playerId,
//       teamName: teamName ?? this.teamName,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String id;
  final String userId; // Link to user account
  final String name;
  final String position;
  final String imageUrl;
  final String upazila;
  final String district;
  final String division;
  final DateTime dateOfBirth;
  final String playerId; // Auto-generated ID like "Dhaka-12345"
  final String? teamName; // Optional team name
  final DateTime createdAt;

  PlayerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.upazila,
    required this.district,
    required this.division,
    required this.dateOfBirth,
    required this.playerId,
    this.teamName,
    required this.createdAt,
  });

  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Fallback date to ensure no null value is assigned to non-nullable DateTime fields
    final DateTime defaultDate = DateTime.now();

    return PlayerModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      // Null-safe casting: If the value is null, use defaultDate
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate() ?? defaultDate,
      playerId: data['playerId'] ?? '',
      teamName: data['teamName'] as String?, // teamName is nullable
      // Null-safe casting: If the value is null, use defaultDate
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? defaultDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'position': position,
      'imageUrl': imageUrl,
      'upazila': upazila,
      'district': district,
      'division': division,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'playerId': playerId,
      'teamName': teamName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for updates
  PlayerModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? position,
    String? imageUrl,
    String? upazila,
    String? district,
    String? division,
    DateTime? dateOfBirth,
    String? playerId,
    String? teamName,
    DateTime? createdAt,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      upazila: upazila ?? this.upazila,
      district: district ?? this.district,
      division: division ?? this.division,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      playerId: playerId ?? this.playerId,
      teamName: teamName ?? this.teamName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}