import 'package:flutter/material.dart';

// MyProfileCard উইজেট যা শুধুমাত্র ব্যবহারকারীর নাম এবং অ্যাভাটার প্রদর্শন করবে।
class MyProfileCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String? profilePhotoUrl; // ভবিষ্যতে ছবির জন্য রাখা হয়েছে

  const MyProfileCard({
    Key? key,
    required this.fullName,
    this.profilePhotoUrl,
    required this.email,
  }) : super(key: key);

  // অ্যাভাটারের জন্য প্রথম অক্ষর বের করার ফাংশন
  String _getInitial(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // গ্রেডিয়েন্ট ব্যাকগ্রাউন্ড, যা আগে FlexibleSpaceBar-এ ছিল
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F3460),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          // Profile Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F3460),
                  Color(0xFF1A5490),
                ],
              ),
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              // ছবির ইউআরএল থাকলে ছবি দেখাবে, অন্যথায় প্রথম অক্ষর
              child: profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  profilePhotoUrl!,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              )
                  : Text(
                _getInitial(fullName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
           email,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}