//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/player_model.dart';
// import '../providers/player_provider.dart';
//
// class PlayerScreen extends StatefulWidget {
//   final PlayerModel player;
//
//   const PlayerScreen({Key? key, required this.player}) : super(key: key);
//
//   @override
//   State<PlayerScreen> createState() => _PlayerScreenState();
// }
//
// class _PlayerScreenState extends State<PlayerScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final player = widget.player;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E293B),
//         title: Text(
//           player.name,
//           style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.yellow,
//           labelColor: Colors.yellow,
//           unselectedLabelColor: Colors.white60,
//           tabs: const [
//             Tab(icon: Icon(Icons.info_outline), text: "তথ্য"),
//             Tab(icon: Icon(Icons.bar_chart_outlined), text: "স্ট্যাটস"),
//             Tab(icon: Icon(Icons.sports_soccer_outlined), text: "ম্যাচ"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildInfoTab(player),
//           _buildStatsTab(player),
//           _buildMatchesTab(context, player.teamName),
//         ],
//       ),
//     );
//   }
//
//   // 🧾 Info Tab
//   Widget _buildInfoTab(PlayerModel player) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundImage: NetworkImage(player.imageUrl),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             player.name,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             player.position,
//             style: const TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "দল: ${player.teamName}",
//             style: const TextStyle(color: Colors.white54),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 📊 Stats Tab
//   Widget _buildStatsTab(PlayerModel player) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           _buildStatRow("গোল", "12"),
//           _buildStatRow("অ্যাসিস্ট", "7"),
//           _buildStatRow("ম্যাচ", "24"),
//           _buildStatRow("ম্যান অফ দ্য ম্যাচ", "5"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatRow(String title, String value) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: const TextStyle(color: Colors.white70, fontSize: 16)),
//           Text(value,
//               style: const TextStyle(
//                   color: Colors.yellow, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   // ⚽ Matches Tab (team-based recent matches)
//   Widget _buildMatchesTab(BuildContext context, String teamName) {
//     final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
//
//     return FutureBuilder(
//       future: playerProvider.fetchPlayersByTeam(teamName),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator(color: Colors.yellow));
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: 3, // Dummy count for demo
//           itemBuilder: (context, index) {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E293B),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text("Raipur vs Ramgonj",
//                       style: TextStyle(color: Colors.white)),
//                   Text("3 - 1", style: TextStyle(color: Colors.yellow)),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
//



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_model.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatefulWidget {
  final PlayerModel player;

  const PlayerScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          player.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.yellow,
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: "তথ্য"),
            Tab(icon: Icon(Icons.bar_chart_outlined), text: "স্ট্যাটস"),
            Tab(icon: Icon(Icons.sports_soccer_outlined), text: "ম্যাচ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(player),
          _buildStatsTab(player),
          _buildMatchesTab(), // 💡 পরিবর্তন: আর্গুমেন্ট ছাড়া কল করা হয়েছে
        ],
      ),
    );
  }

  // ---

  // 🧾 Info Tab
  Widget _buildInfoTab(PlayerModel player) {
    final teamText = player.teamName == null || player.teamName!.isEmpty
        ? "দল: নেই"
        : "দল: ${player.teamName}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(player.imageUrl),
            backgroundColor: Colors.white10,
            child: player.imageUrl.isEmpty ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
          ),
          const SizedBox(height: 16),
          Text(
            player.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            player.position,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            teamText,
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  // ---

  // 📊 Stats Tab (Dummy Data)
  Widget _buildStatsTab(PlayerModel player) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatRow("প্লেয়ার আইডি", player.playerId), // Added dynamic player ID
          _buildStatRow("জন্ম তারিখ", "${player.dateOfBirth.day}/${player.dateOfBirth.month}/${player.dateOfBirth.year}"),
          const Divider(color: Colors.white12, height: 20),
          _buildStatRow("গোল", "12"),
          _buildStatRow("অ্যাসিস্ট", "7"),
          _buildStatRow("ম্যাচ", "24"),
          _buildStatRow("ম্যান অফ দ্য ম্যাচ", "5"),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: Colors.yellow, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---

  // ⚽ Matches Tab (Using StreamBuilder and getPlayerMatches)
  Widget _buildMatchesTab() {
    // Provider.of ফাংশনের শুরুতে কল করা হয়েছে
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: playerProvider.getPlayerMatches(), // 💡 সঠিক ফাংশন ব্যবহার
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.yellow));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("ম্যাচ লোড করতে ব্যর্থ: ${snapshot.error}",
                style: const TextStyle(color: Colors.red)),
          );
        }

        final matches = snapshot.data ?? [];

        if (matches.isEmpty) {
          return const Center(
            child: Text("আপনার এলাকার কোনো ম্যাচ পাওয়া যায়নি।",
                style: TextStyle(color: Colors.white70)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];

            // Null-safe ডেটা এক্সট্রাকশন
            final teamA = match['teamA'] as String? ?? 'দল A';
            final teamB = match['teamB'] as String? ?? 'দল B';
            final scoreA = match['scoreA']?.toString() ?? '?';
            final scoreB = match['scoreB']?.toString() ?? '?';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$teamA বনাম $teamB",
                      style: const TextStyle(color: Colors.white)),
                  Text("$scoreA - $scoreB",
                      style: const TextStyle(
                          color: Colors.yellow, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}