import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String division;
  final String district;
  final String upazila;
  final String gender;
  final DateTime dateOfBirth;
  final String? profilePhotoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.division,
    required this.district,
    required this.upazila,
    required this.gender,
    required this.dateOfBirth,
    this.profilePhotoUrl,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'division': division,
      'district': district,
      'upazila': upazila,
      'gender': gender,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      division: map['division'] ?? '',
      district: map['district'] ?? '',
      upazila: map['upazila'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      profilePhotoUrl: map['profilePhotoUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? division,
    String? district,
    String? upazila,
    String? gender,
    DateTime? dateOfBirth,
    String? profilePhotoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      division: division ?? this.division,
      district: district ?? this.district,
      upazila: upazila ?? this.upazila,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}