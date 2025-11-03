import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerModel {
  final String id;
  final String name;
  final String teamName;
  final String position;
  final String imageUrl;

  PlayerModel({
    required this.id,
    required this.name,
    required this.teamName,
    required this.position,
    required this.imageUrl,
  });

  // factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return PlayerModel(
  //     id: doc.id,
  //     name: data['name'] ?? '',
  //     teamName: data['teamName'] ?? '',
  //     position: data['position'] ?? '',
  //     imageUrl: data['imageUrl'] ?? '',
  //   );
  // }
  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    // doc.data() null হলে একটি ফাঁকা Map ব্যবহার করুন
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // এখন data কখনোই null হবে না, তাই এটিকে safe ভাবে ব্যবহার করা যাবে
    return PlayerModel(
      id: doc.id,
      name: data['name'] ?? '',
      teamName: data['teamName'] ?? '',
      position: data['position'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'teamName': teamName,
      'position': position,
      'imageUrl': imageUrl,
    };
  }
}