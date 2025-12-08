// // // import 'package:flutter/material.dart';
// // // import 'package:cached_network_image/cached_network_image.dart';
// // // import '../models/player_ranking.dart';
// // // import '../models/team_ranking.dart';
// // // import '../services/ranking_service.dart';
// // //
// // //
// // // class RankingsScreen extends StatefulWidget {
// // //   const RankingsScreen({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   State<RankingsScreen> createState() => _RankingsScreenState();
// // // }
// // //
// // // class _RankingsScreenState extends State<RankingsScreen>
// // //     with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   final RankingService _rankingService = RankingService();
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 2, vsync: this);
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFF1A1A2E),
// // //       appBar: AppBar(
// // //         backgroundColor: const Color(0xFF16213E),
// // //         title: const Text(
// // //           'র‍্যাঙ্কিং',
// // //           style: TextStyle(
// // //             color: Colors.white,
// // //             fontSize: 20,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         bottom: TabBar(
// // //           controller: _tabController,
// // //           indicatorColor: const Color(0xFF28A745),
// // //           labelColor: const Color(0xFF28A745),
// // //           unselectedLabelColor: Colors.white70,
// // //           tabs: const [
// // //             Tab(text: 'টিম র‍্যাঙ্কিং'),
// // //             Tab(text: 'খেলোয়াড় র‍্যাঙ্কিং'),
// // //           ],
// // //         ),
// // //       ),
// // //       body: TabBarView(
// // //         controller: _tabController,
// // //         children: [
// // //           _buildTeamRankings(),
// // //           _buildPlayerRankings(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTeamRankings() {
// // //     return StreamBuilder<List<TeamRanking>>(
// // //       stream: _rankingService.getTeamRankings(),
// // //       builder: (context, snapshot) {
// // //         if (snapshot.connectionState == ConnectionState.waiting) {
// // //           return const Center(
// // //             child: CircularProgressIndicator(
// // //               color: Color(0xFF28A745),
// // //             ),
// // //           );
// // //         }
// // //
// // //         if (snapshot.hasError) {
// // //           return Center(
// // //             child: Text(
// // //               'Error: ${snapshot.error}',
// // //               style: const TextStyle(color: Colors.white),
// // //             ),
// // //           );
// // //         }
// // //
// // //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //           return const Center(
// // //             child: Text(
// // //               'কোনো টিম র‍্যাঙ্কিং নেই',
// // //               style: TextStyle(color: Colors.white70, fontSize: 16),
// // //             ),
// // //           );
// // //         }
// // //
// // //         final teams = snapshot.data!;
// // //
// // //         return ListView.builder(
// // //           padding: const EdgeInsets.all(16),
// // //           itemCount: teams.length,
// // //           itemBuilder: (context, index) {
// // //             final team = teams[index];
// // //             final rank = index + 1;
// // //             return _buildTeamRankingCard(team, rank);
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildTeamRankingCard(TeamRanking team, int rank) {
// // //     Color rankColor = Colors.white;
// // //     if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
// // //     if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
// // //     if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze
// // //
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           colors: [
// // //             const Color(0xFF16213E),
// // //             const Color(0xFF0F3460),
// // //           ],
// // //           begin: Alignment.topLeft,
// // //           end: Alignment.bottomRight,
// // //         ),
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.3),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 4),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Row(
// // //           children: [
// // //             // Rank
// // //             Container(
// // //               width: 40,
// // //               height: 40,
// // //               decoration: BoxDecoration(
// // //                 color: rankColor.withOpacity(0.2),
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(color: rankColor, width: 2),
// // //               ),
// // //               child: Center(
// // //                 child: Text(
// // //                   '$rank',
// // //                   style: TextStyle(
// // //                     color: rankColor,
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 16),
// // //
// // //             // Team Logo
// // //             if (team.teamLogo.isNotEmpty)
// // //               ClipRRect(
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 child: CachedNetworkImage(
// // //                   imageUrl: team.teamLogo,
// // //                   width: 50,
// // //                   height: 50,
// // //                   fit: BoxFit.cover,
// // //                   placeholder: (context, url) => Container(
// // //                     width: 50,
// // //                     height: 50,
// // //                     color: Colors.grey[800],
// // //                     child: const Center(
// // //                       child: CircularProgressIndicator(
// // //                         color: Color(0xFF28A745),
// // //                         strokeWidth: 2,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   errorWidget: (context, url, error) => Container(
// // //                     width: 50,
// // //                     height: 50,
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFF28A745).withOpacity(0.2),
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     child: Center(
// // //                       child: Text(
// // //                         team.teamName.isNotEmpty
// // //                             ? team.teamName[0].toUpperCase()
// // //                             : 'T',
// // //                         style: const TextStyle(
// // //                           color: Color(0xFF28A745),
// // //                           fontSize: 24,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               )
// // //             else
// // //               Container(
// // //                 width: 50,
// // //                 height: 50,
// // //                 decoration: BoxDecoration(
// // //                   color: const Color(0xFF28A745).withOpacity(0.2),
// // //                   borderRadius: BorderRadius.circular(8),
// // //                 ),
// // //                 child: Center(
// // //                   child: Text(
// // //                     team.teamName.isNotEmpty
// // //                         ? team.teamName[0].toUpperCase()
// // //                         : 'T',
// // //                     style: const TextStyle(
// // //                       color: Color(0xFF28A745),
// // //                       fontSize: 24,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             const SizedBox(width: 16),
// // //
// // //             // Team Info
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     team.teamName,
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 4),
// // //                   Text(
// // //                     team.upazila,
// // //                     style: const TextStyle(
// // //                       color: Colors.white70,
// // //                       fontSize: 12,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   Row(
// // //                     children: [
// // //                       _buildStatBadge('ম্যাচ', '${team.matchesPlayed}'),
// // //                       const SizedBox(width: 8),
// // //                       _buildStatBadge('জয়', '${team.wins}',
// // //                           color: Colors.green),
// // //                       const SizedBox(width: 8),
// // //                       _buildStatBadge('ড্র', '${team.draws}',
// // //                           color: Colors.orange),
// // //                       const SizedBox(width: 8),
// // //                       _buildStatBadge('হার', '${team.losses}',
// // //                           color: Colors.red),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             // Points
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFF28A745),
// // //                 borderRadius: BorderRadius.circular(8),
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   Text(
// // //                     '${team.points}',
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 24,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const Text(
// // //                     'পয়েন্ট',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 10,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildPlayerRankings() {
// // //     return StreamBuilder<List<PlayerRanking>>(
// // //       stream: _rankingService.getPlayerRankings(),
// // //       builder: (context, snapshot) {
// // //         if (snapshot.connectionState == ConnectionState.waiting) {
// // //           return const Center(
// // //             child: CircularProgressIndicator(
// // //               color: Color(0xFF28A745),
// // //             ),
// // //           );
// // //         }
// // //
// // //         if (snapshot.hasError) {
// // //           return Center(
// // //             child: Text(
// // //               'Error: ${snapshot.error}',
// // //               style: const TextStyle(color: Colors.white),
// // //             ),
// // //           );
// // //         }
// // //
// // //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //           return const Center(
// // //             child: Text(
// // //               'কোনো খেলোয়াড় র‍্যাঙ্কিং নেই',
// // //               style: TextStyle(color: Colors.white70, fontSize: 16),
// // //             ),
// // //           );
// // //         }
// // //
// // //         final players = snapshot.data!;
// // //
// // //         return ListView.builder(
// // //           padding: const EdgeInsets.all(16),
// // //           itemCount: players.length,
// // //           itemBuilder: (context, index) {
// // //             final player = players[index];
// // //             final rank = index + 1;
// // //             return _buildPlayerRankingCard(player, rank);
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildPlayerRankingCard(PlayerRanking player, int rank) {
// // //     Color rankColor = Colors.white;
// // //     if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
// // //     if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
// // //     if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze
// // //
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           colors: [
// // //             const Color(0xFF16213E),
// // //             const Color(0xFF0F3460),
// // //           ],
// // //           begin: Alignment.topLeft,
// // //           end: Alignment.bottomRight,
// // //         ),
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.3),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 4),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Row(
// // //           children: [
// // //             // Rank
// // //             Container(
// // //               width: 40,
// // //               height: 40,
// // //               decoration: BoxDecoration(
// // //                 color: rankColor.withOpacity(0.2),
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 border: Border.all(color: rankColor, width: 2),
// // //               ),
// // //               child: Center(
// // //                 child: Text(
// // //                   '$rank',
// // //                   style: TextStyle(
// // //                     color: rankColor,
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 16),
// // //
// // //             // Player Photo
// // //             if (player.playerPhoto.isNotEmpty)
// // //               ClipRRect(
// // //                 borderRadius: BorderRadius.circular(25),
// // //                 child: CachedNetworkImage(
// // //                   imageUrl: player.playerPhoto,
// // //                   width: 50,
// // //                   height: 50,
// // //                   fit: BoxFit.cover,
// // //                   placeholder: (context, url) => Container(
// // //                     width: 50,
// // //                     height: 50,
// // //                     color: Colors.grey[800],
// // //                     child: const Center(
// // //                       child: CircularProgressIndicator(
// // //                         color: Color(0xFF28A745),
// // //                         strokeWidth: 2,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   errorWidget: (context, url, error) => CircleAvatar(
// // //                     radius: 25,
// // //                     backgroundColor:
// // //                     const Color(0xFF28A745).withOpacity(0.2),
// // //                     child: Text(
// // //                       player.playerName.isNotEmpty
// // //                           ? player.playerName[0].toUpperCase()
// // //                           : 'P',
// // //                       style: const TextStyle(
// // //                         color: Color(0xFF28A745),
// // //                         fontSize: 24,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               )
// // //             else
// // //               CircleAvatar(
// // //                 radius: 25,
// // //                 backgroundColor: const Color(0xFF28A745).withOpacity(0.2),
// // //                 child: Text(
// // //                   player.playerName.isNotEmpty
// // //                       ? player.playerName[0].toUpperCase()
// // //                       : 'P',
// // //                   style: const TextStyle(
// // //                     color: Color(0xFF28A745),
// // //                     fontSize: 24,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ),
// // //             const SizedBox(width: 16),
// // //
// // //             // Player Info
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     player.playerName,
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 4),
// // //                   Row(
// // //                     children: [
// // //                       if (player.position.isNotEmpty)
// // //                         Container(
// // //                           padding: const EdgeInsets.symmetric(
// // //                             horizontal: 8,
// // //                             vertical: 2,
// // //                           ),
// // //                           decoration: BoxDecoration(
// // //                             color: const Color(0xFF28A745).withOpacity(0.2),
// // //                             borderRadius: BorderRadius.circular(4),
// // //                           ),
// // //                           child: Text(
// // //                             player.position,
// // //                             style: const TextStyle(
// // //                               color: Color(0xFF28A745),
// // //                               fontSize: 10,
// // //                               fontWeight: FontWeight.bold,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       const SizedBox(width: 8),
// // //                       Text(
// // //                         player.upazila,
// // //                         style: const TextStyle(
// // //                           color: Colors.white70,
// // //                           fontSize: 12,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   Row(
// // //                     children: [
// // //                       _buildStatBadge('গোল', '${player.goals}'),
// // //                       const SizedBox(width: 8),
// // //                       _buildStatBadge('এসিস্ট', '${player.assists}'),
// // //                       const SizedBox(width: 8),
// // //                       _buildStatBadge('ম্যাচ', '${player.matchesPlayed}'),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //
// // //             // Points
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFF28A745),
// // //                 borderRadius: BorderRadius.circular(8),
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   Text(
// // //                     '${player.points}',
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 24,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                   const Text(
// // //                     'পয়েন্ট',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 10,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildStatBadge(String label, String value, {Color? color}) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: (color ?? Colors.white).withOpacity(0.1),
// // //         borderRadius: BorderRadius.circular(4),
// // //         border: Border.all(
// // //           color: (color ?? Colors.white).withOpacity(0.3),
// // //           width: 1,
// // //         ),
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Text(
// // //             label,
// // //             style: TextStyle(
// // //               color: color ?? Colors.white70,
// // //               fontSize: 10,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 4),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               color: color ?? Colors.white,
// // //               fontSize: 10,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import '../models/player_ranking.dart';
// // import '../models/team_ranking.dart';
// // import '../services/ranking_service.dart';
// //
// //
// // class RankingsScreen extends StatefulWidget {
// //   const RankingsScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<RankingsScreen> createState() => _RankingsScreenState();
// // }
// //
// // class _RankingsScreenState extends State<RankingsScreen>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   final RankingService _rankingService = RankingService();
// //   final TextEditingController _searchController = TextEditingController();
// //
// //   String _searchQuery = '';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFF1A1A2E),
// //       appBar: AppBar(
// //         backgroundColor: Color(0xFF16213E),
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: Icon(
// //             Icons.arrow_back,
// //             color: Colors.white,
// //             size: 28,
// //           ),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: Text(
// //           'র‍্যাঙ্কিং',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontSize: 22,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true,
// //         bottom: PreferredSize(
// //           preferredSize: Size.fromHeight(110),
// //           child: Column(
// //             children: [
// //               // Search Bar
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF1A1A2E),
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(
// //                       color: Colors.white24,
// //                       width: 1,
// //                     ),
// //                   ),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     style: TextStyle(color: Colors.white),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _searchQuery = value.toLowerCase();
// //                       });
// //                     },
// //                     decoration: InputDecoration(
// //                       hintText: 'টিম বা খেলোয়াড় খুঁজুন...',
// //                       hintStyle: TextStyle(color: Colors.white54),
// //                       prefixIcon: Icon(
// //                         Icons.search,
// //                         color: Color(0xFF28A745),
// //                       ),
// //                       suffixIcon: _searchQuery.isNotEmpty
// //                           ? IconButton(
// //                         icon: Icon(Icons.clear, color: Colors.white54),
// //                         onPressed: () {
// //                           setState(() {
// //                             _searchController.clear();
// //                             _searchQuery = '';
// //                           });
// //                         },
// //                       )
// //                           : null,
// //                       border: InputBorder.none,
// //                       contentPadding: EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 12,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Tabs
// //               TabBar(
// //                 controller: _tabController,
// //                 indicatorColor: Color(0xFF28A745),
// //                 indicatorWeight: 3,
// //                 labelColor: Color(0xFF28A745),
// //                 unselectedLabelColor: Colors.white70,
// //                 labelStyle: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //                 tabs: [
// //                   Tab(text: 'টিম র‍্যাঙ্কিং'),
// //                   Tab(text: 'খেলোয়াড় র‍্যাঙ্কিং'),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: TabBarView(
// //         controller: _tabController,
// //         children: [
// //           _buildTeamRankings(),
// //           _buildPlayerRankings(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTeamRankings() {
// //     return StreamBuilder<List<TeamRanking>>(
// //       stream: _rankingService.getTeamRankings(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Center(
// //             child: CircularProgressIndicator(
// //               color: Color(0xFF28A745),
// //             ),
// //           );
// //         }
// //
// //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.emoji_events_outlined,
// //                   size: 80,
// //                   color: Colors.white30,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'এখনো কোন টিম র‍্যাঙ্কিং নেই',
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         // Filter teams based on search query
// //         final teams = snapshot.data!.where((team) {
// //           if (_searchQuery.isEmpty) return true;
// //           return team.teamName.toLowerCase().contains(_searchQuery) ||
// //               team.upazila.toLowerCase().contains(_searchQuery);
// //         }).toList();
// //
// //         if (teams.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.search_off,
// //                   size: 80,
// //                   color: Colors.white30,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'কোন টিম পাওয়া যায়নি',
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         return ListView.builder(
// //           padding: EdgeInsets.all(16),
// //           itemCount: teams.length,
// //           itemBuilder: (context, index) {
// //             return _buildTeamCard(teams[index], index + 1);
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildTeamCard(TeamRanking team, int rank) {
// //     Color rankColor = rank == 1
// //         ? Color(0xFFFFD700)
// //         : rank == 2
// //         ? Color(0xFFC0C0C0)
// //         : rank == 3
// //         ? Color(0xFFCD7F32)
// //         : Colors.white70;
// //
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Color(0xFF16213E), Color(0xFF0F3460)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black26,
// //             blurRadius: 8,
// //             offset: Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           Positioned(
// //             top: 8,
// //             left: 8,
// //             child: Container(
// //               width: 35,
// //               height: 35,
// //               decoration: BoxDecoration(
// //                 color: rankColor.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: rankColor, width: 2),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   '$rank',
// //                   style: TextStyle(
// //                     color: rankColor,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           Padding(
// //             padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 60,
// //                   height: 60,
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12),
// //                     child: team.teamLogo.isNotEmpty
// //                         ? CachedNetworkImage(
// //                       imageUrl: team.teamLogo,
// //                       fit: BoxFit.contain,
// //                       placeholder: (context, url) => Center(
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Color(0xFF28A745),
// //                         ),
// //                       ),
// //                       errorWidget: (context, url, error) => Icon(
// //                         Icons.shield,
// //                         color: Colors.white54,
// //                         size: 40,
// //                       ),
// //                     )
// //                         : Icon(
// //                       Icons.shield,
// //                       color: Colors.white54,
// //                       size: 40,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         team.teamName,
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       SizedBox(height: 4),
// //                       Text(
// //                         team.upazila,
// //                         style: TextStyle(
// //                           color: Color(0xFF28A745),
// //                           fontSize: 13,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       SizedBox(height: 8),
// //                       // ✅ Added Draws
// //                       Wrap(
// //                         spacing: 6,
// //                         runSpacing: 4,
// //                         children: [
// //                           _buildStatBadge('ম্যাচ ${team.matchesPlayed}'),
// //                           _buildStatBadge('জিত ${team.wins}'),
// //                           _buildStatBadge('ড্র ${team.draws}'),  // ✅ ADDED
// //                           _buildStatBadge('হার ${team.losses}'),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(width: 8),
// //
// //                 Container(
// //                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF28A745),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         '${team.points}',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 24,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       Text(
// //                         'পয়েন্ট',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 11,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPlayerRankings() {
// //     return StreamBuilder<List<PlayerRanking>>(
// //       stream: _rankingService.getPlayerRankings(),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Center(
// //             child: CircularProgressIndicator(
// //               color: Color(0xFF28A745),
// //             ),
// //           );
// //         }
// //
// //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.person_outline,
// //                   size: 80,
// //                   color: Colors.white30,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'এখনো কোন খেলোয়াড় র‍্যাঙ্কিং নেই',
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         // Filter players based on search query
// //         final players = snapshot.data!.where((player) {
// //           if (_searchQuery.isEmpty) return true;
// //           return player.playerName.toLowerCase().contains(_searchQuery) ||
// //               player.upazila.toLowerCase().contains(_searchQuery) ||
// //               player.position.toLowerCase().contains(_searchQuery);
// //         }).toList();
// //
// //         if (players.isEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.search_off,
// //                   size: 80,
// //                   color: Colors.white30,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'কোন খেলোয়াড় পাওয়া যায়নি',
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //
// //         return ListView.builder(
// //           padding: EdgeInsets.all(16),
// //           itemCount: players.length,
// //           itemBuilder: (context, index) {
// //             return _buildPlayerCard(players[index], index + 1);
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildPlayerCard(PlayerRanking player, int rank) {
// //     Color rankColor = rank == 1
// //         ? Color(0xFFFFD700)
// //         : rank == 2
// //         ? Color(0xFFC0C0C0)
// //         : rank == 3
// //         ? Color(0xFFCD7F32)
// //         : Colors.white70;
// //
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Color(0xFF16213E), Color(0xFF0F3460)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black26,
// //             blurRadius: 8,
// //             offset: Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           Positioned(
// //             top: 8,
// //             left: 8,
// //             child: Container(
// //               width: 35,
// //               height: 35,
// //               decoration: BoxDecoration(
// //                 color: rankColor.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: rankColor, width: 2),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   '$rank',
// //                   style: TextStyle(
// //                     color: rankColor,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           Padding(
// //             padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 60,
// //                   height: 60,
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF28A745),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: player.playerPhoto.isNotEmpty
// //                       ? ClipOval(
// //                     child: CachedNetworkImage(
// //                       imageUrl: player.playerPhoto,
// //                       fit: BoxFit.cover,
// //                       placeholder: (context, url) => Center(
// //                         child: Text(
// //                           player.playerName[0].toUpperCase(),
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 28,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                       errorWidget: (context, url, error) => Center(
// //                         child: Text(
// //                           player.playerName[0].toUpperCase(),
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 28,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                       : Center(
// //                     child: Text(
// //                       player.playerName[0].toUpperCase(),
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 28,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         player.playerName,
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       SizedBox(height: 4),
// //                       Row(
// //                         children: [
// //                           if (player.position.isNotEmpty) ...[
// //                             Container(
// //                               padding: EdgeInsets.symmetric(
// //                                 horizontal: 8,
// //                                 vertical: 2,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: Color(0xFF28A745).withOpacity(0.2),
// //                                 borderRadius: BorderRadius.circular(6),
// //                                 border: Border.all(
// //                                   color: Color(0xFF28A745),
// //                                   width: 1,
// //                                 ),
// //                               ),
// //                               child: Text(
// //                                 player.position,
// //                                 style: TextStyle(
// //                                   color: Color(0xFF28A745),
// //                                   fontSize: 11,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(width: 6),
// //                           ],
// //                           Flexible(
// //                             child: Text(
// //                               player.upazila,
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 13,
// //                               ),
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 8),
// //                       // ✅ Added Yellow & Red Cards
// //                       Wrap(
// //                         spacing: 6,
// //                         runSpacing: 4,
// //                         children: [
// //                           _buildStatBadge('গোল ${player.goals}'),
// //                           _buildStatBadge('এসিস্ট ${player.assists}'),
// //                           _buildStatBadge('ম্যাচ ${player.matchesPlayed}'),
// //                           // ✅ ADDED Yellow & Red Cards
// //                           if (player.yellowCards > 0)
// //                             _buildCardBadge('🟨 ${player.yellowCards}', Colors.yellow),
// //                           if (player.redCards > 0)
// //                             _buildCardBadge('🟥 ${player.redCards}', Colors.red),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(width: 8),
// //
// //                 Container(
// //                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFF28A745),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         '${player.points}',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 24,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       Text(
// //                         'পয়েন্ট',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 11,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatBadge(String text) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           color: Colors.white70,
// //           fontSize: 11,
// //         ),
// //       ),
// //     );
// //   }
// // }
// // Widget _buildCardBadge(String text, Color color) {
// //   return Container(
// //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //     decoration: BoxDecoration(
// //       color: color.withOpacity(0.2),
// //       borderRadius: BorderRadius.circular(6),
// //       border: Border.all(color: color, width: 1),
// //     ),
// //     child: Text(
// //       text,
// //       style: TextStyle(
// //         color: color,
// //         fontSize: 11,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //   );
// // }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/player_ranking.dart';
// import '../models/team_ranking.dart';
// import '../services/ranking_service.dart';
//
// class RankingsScreen extends StatefulWidget {
//   const RankingsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RankingsScreen> createState() => _RankingsScreenState();
// }
//
// class _RankingsScreenState extends State<RankingsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final RankingService _rankingService = RankingService();
//   final TextEditingController _searchController = TextEditingController();
//
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF16213E),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//             size: 28,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'র‍্যাঙ্কিং',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(110),
//           child: Column(
//             children: [
//               // Search Bar
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFF1A1A2E),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.white24,
//                       width: 1,
//                     ),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: TextStyle(color: Colors.white),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value.toLowerCase();
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'টিম বা খেলোয়াড় খুঁজুন...',
//                       hintStyle: TextStyle(color: Colors.white54),
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: Color(0xFF28A745),
//                       ),
//                       suffixIcon: _searchQuery.isNotEmpty
//                           ? IconButton(
//                         icon: Icon(Icons.clear, color: Colors.white54),
//                         onPressed: () {
//                           setState(() {
//                             _searchController.clear();
//                             _searchQuery = '';
//                           });
//                         },
//                       )
//                           : null,
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Tabs
//               TabBar(
//                 controller: _tabController,
//                 indicatorColor: Color(0xFF28A745),
//                 indicatorWeight: 3,
//                 labelColor: Color(0xFF28A745),
//                 unselectedLabelColor: Colors.white70,
//                 labelStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 tabs: [
//                   Tab(text: 'টিম র‍্যাঙ্কিং'),
//                   Tab(text: 'খেলোয়াড় র‍্যাঙ্কিং'),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildTeamRankings(),
//           _buildPlayerRankings(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamRankings() {
//     return StreamBuilder<List<TeamRanking>>(
//       stream: _rankingService.getTeamRankings(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Color(0xFF28A745),
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.emoji_events_outlined,
//                   size: 80,
//                   color: Colors.white30,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'এখনো কোন টিম র‍্যাঙ্কিং নেই',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final teams = snapshot.data!.where((team) {
//           if (_searchQuery.isEmpty) return true;
//           return team.teamName.toLowerCase().contains(_searchQuery) ||
//               team.upazila.toLowerCase().contains(_searchQuery);
//         }).toList();
//
//         if (teams.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.search_off,
//                   size: 80,
//                   color: Colors.white30,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'কোন টিম পাওয়া যায়নি',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: teams.length,
//           itemBuilder: (context, index) {
//             return _buildTeamCard(teams[index], index + 1);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTeamCard(TeamRanking team, int rank) {
//     Color rankColor = rank == 1
//         ? Color(0xFFFFD700)
//         : rank == 2
//         ? Color(0xFFC0C0C0)
//         : rank == 3
//         ? Color(0xFFCD7F32)
//         : Colors.white70;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF16213E), Color(0xFF0F3460)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 8,
//             left: 8,
//             child: Container(
//               width: 35,
//               height: 35,
//               decoration: BoxDecoration(
//                 color: rankColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: rankColor, width: 2),
//               ),
//               child: Center(
//                 child: Text(
//                   '$rank',
//                   style: TextStyle(
//                     color: rankColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: team.teamLogo.isNotEmpty
//                         ? CachedNetworkImage(
//                       imageUrl: team.teamLogo,
//                       fit: BoxFit.contain,
//                       placeholder: (context, url) => Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Color(0xFF28A745),
//                         ),
//                       ),
//                       errorWidget: (context, url, error) => Icon(
//                         Icons.shield,
//                         color: Colors.white54,
//                         size: 40,
//                       ),
//                     )
//                         : Icon(
//                       Icons.shield,
//                       color: Colors.white54,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         team.teamName,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         team.upazila,
//                         style: TextStyle(
//                           color: Color(0xFF28A745),
//                           fontSize: 13,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 8),
//                       Wrap(
//                         spacing: 6,
//                         runSpacing: 4,
//                         children: [
//                           _buildStatBadge('ম্যাচ ${team.matchesPlayed}'),
//                           _buildStatBadge('জিত ${team.wins}'),
//                           _buildStatBadge('ড্র ${team.draws}'),
//                           _buildStatBadge('হার ${team.losses}'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 8),
//
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF28A745),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         '${team.points}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         'পয়েন্ট',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlayerRankings() {
//     return StreamBuilder<List<PlayerRanking>>(
//       stream: _rankingService.getPlayerRankings(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Color(0xFF28A745),
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.person_outline,
//                   size: 80,
//                   color: Colors.white30,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'এখনো কোন খেলোয়াড় র‍্যাঙ্কিং নেই',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final players = snapshot.data!.where((player) {
//           if (_searchQuery.isEmpty) return true;
//           return player.playerName.toLowerCase().contains(_searchQuery) ||
//               player.upazila.toLowerCase().contains(_searchQuery) ||
//               player.position.toLowerCase().contains(_searchQuery);
//         }).toList();
//
//         if (players.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.search_off,
//                   size: 80,
//                   color: Colors.white30,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'কোন খেলোয়াড় পাওয়া যায়নি',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: players.length,
//           itemBuilder: (context, index) {
//             // ✅ Fetch player photo from Firebase
//             return _buildPlayerCardWithPhoto(players[index], index + 1);
//           },
//         );
//       },
//     );
//   }
//
//   // ✅ NEW: Build player card with photo fetched from players collection
//   Widget _buildPlayerCardWithPhoto(PlayerRanking player, int rank) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('players')
//           .where('playerId', isEqualTo: player.playerId)
//           .limit(1)
//           .snapshots(),
//       builder: (context, playerSnapshot) {
//         String photoUrl = '';
//
//         if (playerSnapshot.hasData && playerSnapshot.data!.docs.isNotEmpty) {
//           final playerData = playerSnapshot.data!.docs.first.data() as Map<String, dynamic>;
//           photoUrl = playerData['photoUrl'] ?? '';
//
//           debugPrint('🔍 Player: ${player.playerName}, Photo: $photoUrl');
//         }
//
//         return _buildPlayerCard(player, rank, photoUrl);
//       },
//     );
//   }
//
//   Widget _buildPlayerCard(PlayerRanking player, int rank, String photoUrl) {
//     Color rankColor = rank == 1
//         ? Color(0xFFFFD700)
//         : rank == 2
//         ? Color(0xFFC0C0C0)
//         : rank == 3
//         ? Color(0xFFCD7F32)
//         : Colors.white70;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF16213E), Color(0xFF0F3460)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: 8,
//             left: 8,
//             child: Container(
//               width: 35,
//               height: 35,
//               decoration: BoxDecoration(
//                 color: rankColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: rankColor, width: 2),
//               ),
//               child: Center(
//                 child: Text(
//                   '$rank',
//                   style: TextStyle(
//                     color: rankColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
//             child: Row(
//               children: [
//                 // ✅ Player Photo with proper handling
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF28A745),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: photoUrl.isNotEmpty
//                         ? CachedNetworkImage(
//                       imageUrl: photoUrl,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       ),
//                       errorWidget: (context, url, error) {
//                         debugPrint('❌ Failed to load photo: $photoUrl, Error: $error');
//                         return Center(
//                           child: Text(
//                             player.playerName.isNotEmpty
//                                 ? player.playerName[0].toUpperCase()
//                                 : 'P',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                         : Center(
//                       child: Text(
//                         player.playerName.isNotEmpty
//                             ? player.playerName[0].toUpperCase()
//                             : 'P',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         player.playerName,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           if (player.position.isNotEmpty) ...[
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF28A745).withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(6),
//                                 border: Border.all(
//                                   color: Color(0xFF28A745),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Text(
//                                 player.position,
//                                 style: TextStyle(
//                                   color: Color(0xFF28A745),
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 6),
//                           ],
//                           Flexible(
//                             child: Text(
//                               player.upazila,
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Wrap(
//                         spacing: 6,
//                         runSpacing: 4,
//                         children: [
//                           _buildStatBadge('গোল ${player.goals}'),
//                           _buildStatBadge('এসিস্ট ${player.assists}'),
//                           _buildStatBadge('ম্যাচ ${player.matchesPlayed}'),
//                           if (player.yellowCards > 0)
//                             _buildCardBadge('🟨 ${player.yellowCards}', Colors.yellow),
//                           if (player.redCards > 0)
//                             _buildCardBadge('🟥 ${player.redCards}', Colors.red),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 8),
//
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF28A745),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         '${player.points}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         'পয়েন্ট',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatBadge(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white70,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCardBadge(String text, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: color, width: 1),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/player_ranking.dart';
import '../models/team_ranking.dart';
import '../services/ranking_service.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RankingService _rankingService = RankingService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF16213E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'র‍্যাঙ্কিং',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'টিম বা খেলোয়াড় খুঁজুন...',
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF28A745),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFF28A745),
                indicatorWeight: 3,
                labelColor: Color(0xFF28A745),
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'টিম র‍্যাঙ্কিং'),
                  Tab(text: 'খেলোয়াড় র‍্যাঙ্কিং'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamRankings(),
          _buildPlayerRankings(),
        ],
      ),
    );
  }

  Widget _buildTeamRankings() {
    return StreamBuilder<List<TeamRanking>>(
      stream: _rankingService.getTeamRankings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF28A745),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 80,
                  color: Colors.white30,
                ),
                SizedBox(height: 16),
                Text(
                  'এখনো কোন টিম র‍্যাঙ্কিং নেই',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        final teams = snapshot.data!.where((team) {
          if (_searchQuery.isEmpty) return true;
          return team.teamName.toLowerCase().contains(_searchQuery) ||
              team.upazila.toLowerCase().contains(_searchQuery);
        }).toList();

        if (teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.white30,
                ),
                SizedBox(height: 16),
                Text(
                  'কোন টিম পাওয়া যায়নি',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return _buildTeamCard(teams[index], index + 1);
          },
        );
      },
    );
  }

  Widget _buildTeamCard(TeamRanking team, int rank) {
    Color rankColor = rank == 1
        ? Color(0xFFFFD700)
        : rank == 2
        ? Color(0xFFC0C0C0)
        : rank == 3
        ? Color(0xFFCD7F32)
        : Colors.white70;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: rankColor, width: 2),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rankColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: team.teamLogo.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: team.teamLogo,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF28A745),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.shield,
                        color: Colors.white54,
                        size: 40,
                      ),
                    )
                        : Icon(
                      Icons.shield,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        team.upazila,
                        style: TextStyle(
                          color: Color(0xFF28A745),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildStatBadge('ম্যাচ ${team.matchesPlayed}'),
                          _buildStatBadge('জিত ${team.wins}'),
                          _buildStatBadge('ড্র ${team.draws}'),
                          _buildStatBadge('হার ${team.losses}'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF28A745),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${team.points}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'পয়েন্ট',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRankings() {
    return StreamBuilder<List<PlayerRanking>>(
      stream: _rankingService.getPlayerRankings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF28A745),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: Colors.white30,
                ),
                SizedBox(height: 16),
                Text(
                  'এখনো কোন খেলোয়াড় র‍্যাঙ্কিং নেই',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        final players = snapshot.data!.where((player) {
          if (_searchQuery.isEmpty) return true;
          return player.playerName.toLowerCase().contains(_searchQuery) ||
              player.upazila.toLowerCase().contains(_searchQuery) ||
              player.position.toLowerCase().contains(_searchQuery);
        }).toList();

        if (players.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.white30,
                ),
                SizedBox(height: 16),
                Text(
                  'কোন খেলোয়াড় পাওয়া যায়নি',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: players.length,
          itemBuilder: (context, index) {
            // ✅ Fetch player photo from players collection
            return _buildPlayerCardWithPhoto(players[index], index + 1);
          },
        );
      },
    );
  }

  // ✅ Build player card with photo fetched from players collection
  Widget _buildPlayerCardWithPhoto(PlayerRanking player, int rank) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .doc(player.playerId)
          .snapshots(),
      builder: (context, playerSnapshot) {
        String photoUrl = '';

        if (playerSnapshot.hasData && playerSnapshot.data!.exists) {
          final playerData = playerSnapshot.data!.data() as Map<String, dynamic>;

          // ✅ Priority: profilePhotoUrl > playerPhoto > photoUrl > imageUrl
          photoUrl = playerData['profilePhotoUrl'] ??
              playerData['playerPhoto'] ??
              playerData['photoUrl'] ??
              playerData['imageUrl'] ??
              '';

          if (photoUrl.isNotEmpty) {
            debugPrint('✅ Photo found for ${player.playerName}: $photoUrl');
          }
        }

        return _buildPlayerCard(player, rank, photoUrl);
      },
    );
  }

  Widget _buildPlayerCard(PlayerRanking player, int rank, String photoUrl) {
    Color rankColor = rank == 1
        ? Color(0xFFFFD700)
        : rank == 2
        ? Color(0xFFC0C0C0)
        : rank == 3
        ? Color(0xFFCD7F32)
        : Colors.white70;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: rankColor, width: 2),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rankColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              children: [
                // ✅ Player Photo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF28A745),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: photoUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: photoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        debugPrint('❌ Failed to load photo: $photoUrl');
                        return _buildPlayerInitial(player.playerName);
                      },
                    )
                        : _buildPlayerInitial(player.playerName),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.playerName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          if (player.position.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF28A745).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Color(0xFF28A745),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                player.position,
                                style: TextStyle(
                                  color: Color(0xFF28A745),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              player.upazila,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildStatBadge('গোল ${player.goals}'),
                          _buildStatBadge('এসিস্ট ${player.assists}'),
                          _buildStatBadge('ম্যাচ ${player.matchesPlayed}'),
                          if (player.yellowCards > 0)
                            _buildCardBadge(
                                '🟨 ${player.yellowCards}', Colors.yellow),
                          if (player.redCards > 0)
                            _buildCardBadge(
                                '🟥 ${player.redCards}', Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF28A745),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${player.points}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'পয়েন্ট',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInitial(String playerName) {
    return Center(
      child: Text(
        playerName.isNotEmpty ? playerName[0].toUpperCase() : 'P',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildCardBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}