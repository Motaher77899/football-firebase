

import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String id;
  final String userId;
  final String name;
  final String position;
  final String imageUrl;
  final String? profilePhotoUrl;
  final String upazila;
  final String district;
  final String division;
  final DateTime dateOfBirth;
  final String playerId;
  final String? teamName;
  final String? teamId; // ✅ Added for team reference
  final int? jerseyNumber; // ✅ Added jersey number
  final DateTime createdAt;

  PlayerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.position,
    required this.imageUrl,
    this.profilePhotoUrl,
    required this.upazila,
    required this.district,
    required this.division,
    required this.dateOfBirth,
    required this.playerId,
    this.teamName,
    this.teamId, // ✅ Added
    this.jerseyNumber, // ✅ Added
    required this.createdAt,
  });

  // ✅ Getter for backward compatibility with photoUrl
  String? get photoUrl => profilePhotoUrl ?? imageUrl;

  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PlayerModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'],
      upazila: data['upazila'] ?? '',
      district: data['district'] ?? '',
      division: data['division'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      playerId: data['playerId'] ?? '',
      teamName: data['teamName'],
      teamId: data['teamId'], // ✅ Added
      jerseyNumber: data['jerseyNumber'], // ✅ Added
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'position': position,
      'imageUrl': imageUrl,
      'profilePhotoUrl': profilePhotoUrl,
      'upazila': upazila,
      'district': district,
      'division': division,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'playerId': playerId,
      'teamName': teamName,
      'teamId': teamId, // ✅ Added
      'jerseyNumber': jerseyNumber, // ✅ Added
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  PlayerModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? position,
    String? imageUrl,
    String? profilePhotoUrl,
    String? upazila,
    String? district,
    String? division,
    DateTime? dateOfBirth,
    String? playerId,
    String? teamName,
    String? teamId, // ✅ Added
    int? jerseyNumber, // ✅ Added
    DateTime? createdAt,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      upazila: upazila ?? this.upazila,
      district: district ?? this.district,
      division: division ?? this.division,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      playerId: playerId ?? this.playerId,
      teamName: teamName ?? this.teamName,
      teamId: teamId ?? this.teamId, // ✅ Added
      jerseyNumber: jerseyNumber ?? this.jerseyNumber, // ✅ Added
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ✅ Helper method to get display photo
  String getDisplayPhoto() {
    return profilePhotoUrl ?? imageUrl;
  }

  // ✅ Helper method to check if player has photo
  bool hasPhoto() {
    return (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty) ||
        imageUrl.isNotEmpty;
  }

  // ✅ Helper method to get position in Bengali
  String getPositionInBengali() {
    switch (position.toUpperCase()) {
      case 'GK':
      case 'GOALKEEPER':
        return 'গোলরক্ষক';
      case 'DEF':
      case 'DEFENDER':
        return 'ডিফেন্ডার';
      case 'MID':
      case 'MIDFIELDER':
        return 'মিডফিল্ডার';
      case 'FWD':
      case 'FORWARD':
      case 'STRIKER':
        return 'ফরোয়ার্ড';
      default:
        return position;
    }
  }

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, position: $position, jerseyNumber: $jerseyNumber, teamName: $teamName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerModel &&
        other.id == id &&
        other.playerId == playerId;
  }

  @override
  int get hashCode => id.hashCode ^ playerId.hashCode;
}