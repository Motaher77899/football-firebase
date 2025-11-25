// import 'package:flutter/material.dart';
//
// // MyPlayerCard উইজেট যা শুধুমাত্র প্লেয়ারের নাম এবং আইকন/ব্যাজ প্রদর্শন করবে।
// class MyPlayerCard extends StatelessWidget {
//   final String playerName;
//   final String? position; // পজিশন কার্ডের নিচে দেখানো যেতে পারে বা বাদ দেওয়া যেতে পারে।
//
//   const MyPlayerCard({
//     Key? key,
//     required this.playerName,
//     this.position,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // গ্রেডিয়েন্ট ব্যাকগ্রাউন্ড, যা আগে FlexibleSpaceBar-এ ছিল
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color(0xFF0F3460),
//             Color(0xFF16213E),
//           ],
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 5),
//           // Player Badge (প্লেয়ার ব্যাজ)
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [
//                   Color(0xFF28A745),
//                   Color(0xFF20C997),
//                 ],
//               ),
//               border: Border.all(
//                 color: Colors.white,
//                 width: 4,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 3,
//                 ),
//               ],
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.sports_soccer,
//                 color: Colors.white,
//                 size: 60,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Player Name (প্লেয়ারের নাম)
//           Text(
//             playerName.toUpperCase(),
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.5,
//             ),
//           ),
//           // Position (ঐচ্ছিকভাবে দেখানো যেতে পারে)
//           if (position != null)
//             Text(
//               position!,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//                 letterSpacing: 1.0,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// MyPlayerCard উইজেট যা শুধুমাত্র প্লেয়ারের নাম এবং ছবি প্রদর্শন করবে।
class MyPlayerCard extends StatelessWidget {
  final String playerName;
  final String? profilePhotoUrl; // <--- নতুন: প্রোফাইল ছবির URL
  final String? email; // ইমেইল বা অন্যান্য তথ্য দরকার হলে
  final String? position;

  const MyPlayerCard({
    Key? key,
    required this.playerName,
    this.profilePhotoUrl, // <--- নতুন প্যারামিটার
    this.email,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF0F3460);

    // Player Badge/Photo লজিক
    Widget playerAvatar;

    if (profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty) {
      // যদি URL থাকে, তবে নেটওয়ার্ক ইমেজ দেখান
      playerAvatar = Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
        child: ClipOval(
          child: Image.network(
            profilePhotoUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 110,
              ); // যদি ছবি লোড না হয়
            },
          ),
        ),
      );
    } else {
      // যদি URL না থাকে, তবে ডিফল্ট আইকন দেখান
      playerAvatar = Container(
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
      );
    }

    return Container(
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

          playerAvatar, // <--- অ্যাভাটার উইজেট

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
          // Email বা অন্যান্য তথ্য
          if (email != null)
            Text(
              email!,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
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