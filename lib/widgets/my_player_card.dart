import 'package:flutter/material.dart';

// MyPlayerCard উইজেট যা শুধুমাত্র প্লেয়ারের নাম এবং আইকন/ব্যাজ প্রদর্শন করবে।
class MyPlayerCard extends StatelessWidget {
  final String playerName;
  final String? position; // পজিশন কার্ডের নিচে দেখানো যেতে পারে বা বাদ দেওয়া যেতে পারে।

  const MyPlayerCard({
    Key? key,
    required this.playerName,
    this.position,
  }) : super(key: key);

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
          const SizedBox(height: 5),
          // Player Badge (প্লেয়ার ব্যাজ)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF28A745),
                  Color(0xFF20C997),
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
            child: const Center(
              child: Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Player Name (প্লেয়ারের নাম)
          Text(
            playerName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          // Position (ঐচ্ছিকভাবে দেখানো যেতে পারে)
          if (position != null)
            Text(
              position!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                letterSpacing: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}