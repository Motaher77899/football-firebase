import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String upazila;
  final String logoUrl;
  final int playersCount;

  TeamModel({
    required this.id,
    required this.name,
    required this.upazila,
    required this.logoUrl,
    required this.playersCount,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name'] ?? '',
      upazila: data['upazila'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      playersCount: data['playersCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'upazila': upazila,
      'logoUrl': logoUrl,
      'playersCount': playersCount,
    };
  }
}