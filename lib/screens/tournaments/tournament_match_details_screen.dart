//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// // Models
// import '../models/tournament/tournament_match_model.dart';
// import '../models/team_model.dart';
//
// // Providers
// import '../providers/team_provider.dart';
//
// /// Tournament Match Details Screen - Same Design as Regular Match
// class TournamentMatchDetailsScreen extends StatefulWidget {
//   final TournamentMatch match;
//   final TeamProvider teamProvider;
//
//   const TournamentMatchDetailsScreen({
//     Key? key,
//     required this.match,
//     required this.teamProvider,
//   }) : super(key: key);
//
//   @override
//   State<TournamentMatchDetailsScreen> createState() =>
//       _TournamentMatchDetailsScreenState();
// }
//
// class _TournamentMatchDetailsScreenState
//     extends State<TournamentMatchDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // ==================== HELPER METHODS ====================
//
//   String _getTeamLogoUrl(String teamId) {
//     TeamModel? team = widget.teamProvider.getTeamById(teamId);
//     return team?.logoUrl ?? '';
//   }
//
//   String _getTeamName(String teamId) {
//     TeamModel? team = widget.teamProvider.getTeamById(teamId);
//     return team?.name ?? 'Unknown';
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'live':
//         return Colors.red;
//       case 'upcoming':
//         return Colors.orange;
//       case 'finished':
//       case 'completed':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status.toLowerCase()) {
//       case 'live':
//         return '🔴 লাইভ চলছে';
//       case 'upcoming':
//         return '📅 আসন্ন ম্যাচ';
//       case 'finished':
//       case 'completed':
//         return '✅ ম্যাচ সমাপ্ত';
//       default:
//         return status;
//     }
//   }
//
//   String _getPositionFullName(String position) {
//     switch (position.toUpperCase()) {
//       case 'GK':
//         return 'গোলরক্ষক';
//       case 'DEF':
//         return 'ডিফেন্ডার';
//       case 'MID':
//         return 'মিডফিল্ডার';
//       case 'FWD':
//         return 'ফরোয়ার্ড';
//       default:
//         return position;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('tournament_matches')
//             .doc(widget.match.id)
//             .snapshots(),
//         builder: (context, snapshot) {
//           TournamentMatch match = widget.match;
//
//           if (snapshot.hasData && snapshot.data != null) {
//             try {
//               match = TournamentMatch.fromMap(
//                 snapshot.data!.data() as Map<String, dynamic>,
//                 snapshot.data!.id,
//               );
//             } catch (e) {
//               debugPrint('Error parsing match: $e');
//             }
//           }
//
//           String teamALogoUrl = _getTeamLogoUrl(match.teamAId);
//           String teamBLogoUrl = _getTeamLogoUrl(match.teamBId);
//           String teamAName = _getTeamName(match.teamAId);
//           String teamBName = _getTeamName(match.teamBId);
//
//           return CustomScrollView(
//             slivers: [
//               // ==================== APP BAR ====================
//               SliverAppBar(
//                 expandedHeight: 380,
//                 floating: false,
//                 pinned: true,
//                 backgroundColor: const Color(0xFF16213E),
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xFF16213E),
//                           Color(0xFF0F3460),
//                         ],
//                       ),
//                     ),
//                     child: SafeArea(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 10),
//
//                           // Status Badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getStatusColor(match.status),
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: _getStatusColor(match.status)
//                                       .withOpacity(0.5),
//                                   blurRadius: 10,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 if (match.status == 'live')
//                                   Container(
//                                     width: 8,
//                                     height: 8,
//                                     margin: const EdgeInsets.only(right: 8),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 Text(
//                                   _getStatusText(match.status),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           // Score Section
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // Team A
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     _buildTeamLogo(teamALogoUrl, size: 70),
//                                     const SizedBox(height: 12),
//                                     Text(
//                                       teamAName.toUpperCase(),
//                                       textAlign: TextAlign.center,
//                                       maxLines: 2,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               // Score
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                   vertical: 16,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(0.2),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       '${match.scoreA}',
//                                       style: TextStyle(
//                                         color: match.scoreA > match.scoreB
//                                             ? Colors.greenAccent
//                                             : Colors.white,
//                                         fontSize: 42,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 12),
//                                       child: Text(
//                                         ':',
//                                         style: TextStyle(
//                                           color: Colors.white54,
//                                           fontSize: 32,
//                                         ),
//                                       ),
//                                     ),
//                                     Text(
//                                       '${match.scoreB}',
//                                       style: TextStyle(
//                                         color: match.scoreB > match.scoreA
//                                             ? Colors.greenAccent
//                                             : Colors.white,
//                                         fontSize: 42,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               // Team B
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     _buildTeamLogo(teamBLogoUrl, size: 70),
//                                     const SizedBox(height: 12),
//                                     Text(
//                                       teamBName.toUpperCase(),
//                                       textAlign: TextAlign.center,
//                                       maxLines: 2,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 16),
//
//                           // Tournament & Round
//                           if (match.tournamentId.isNotEmpty) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 match.tournamentId.toUpperCase(),
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//
//                           if (match.round.isNotEmpty) ...[
//                             const SizedBox(height: 6),
//                             Text(
//                               match.round,
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//
//                           if (match.venue.isNotEmpty) ...[
//                             const SizedBox(height: 6),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.location_on,
//                                   color: Colors.white70,
//                                   size: 14,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   match.venue,
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 bottom: PreferredSize(
//                   preferredSize: const Size.fromHeight(48),
//                   child: Container(
//                     color: const Color(0xFF16213E),
//                     child: TabBar(
//                       controller: _tabController,
//                       indicatorColor: Colors.white,
//                       indicatorWeight: 3,
//                       labelColor: Colors.white,
//                       unselectedLabelColor: Colors.white60,
//                       labelStyle: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       unselectedLabelStyle: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.normal,
//                       ),
//                       tabs: const [
//                         Tab(text: 'ম্যাচ তথ্য'),
//                         Tab(text: 'টাইমলাইন'),
//                         Tab(text: 'পরিসংখ্যান'),
//                         Tab(text: 'লাইনআপ'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Tab Content
//               SliverFillRemaining(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildMatchInfoTab(match),
//                     _buildTimelineTab(match, teamAName, teamBName),
//                     _buildStatsTab(match),
//                     _buildLineupTab(match, teamAName, teamBName),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // ==================== TEAM LOGO ====================
//
//   Widget _buildTeamLogo(String logoUrl, {double size = 70}) {
//     if (logoUrl.isEmpty) {
//       return Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F3460),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
//         ),
//         child: Icon(
//           Icons.shield,
//           color: Colors.white60,
//           size: size * 0.5,
//         ),
//       );
//     }
//
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ClipOval(
//         child: CachedNetworkImage(
//           imageUrl: logoUrl,
//           fit: BoxFit.cover,
//           placeholder: (context, url) => Container(
//             color: const Color(0xFF0F3460),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               ),
//             ),
//           ),
//           errorWidget: (context, url, error) => Container(
//             color: const Color(0xFF0F3460),
//             child: Icon(
//               Icons.shield,
//               color: Colors.white60,
//               size: size * 0.5,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ==================== MATCH INFO TAB ====================
//
//   Widget _buildMatchInfoTab(TournamentMatch match) {
//     TeamModel? teamA = widget.teamProvider.getTeamById(match.teamAId);
//     TeamModel? teamB = widget.teamProvider.getTeamById(match.teamBId);
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Basic Match Info
//           _buildInfoCard(
//             title: 'ম্যাচ বিবরণ',
//             icon: Icons.info_outline,
//             children: [
//               _buildInfoRow(
//                 icon: Icons.calendar_today,
//                 label: 'তারিখ',
//                 value: DateFormat('EEEE, dd MMMM yyyy')
//                     .format(match.matchDate),
//               ),
//               const SizedBox(height: 16),
//               _buildInfoRow(
//                 icon: Icons.access_time,
//                 label: 'সময়',
//                 value: DateFormat('hh:mm a').format(match.matchDate),
//               ),
//               if (match.tournamentId.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 _buildInfoRow(
//                   icon: Icons.emoji_events,
//                   label: 'টুর্নামেন্ট',
//                   value: match.tournamentId.toUpperCase(),
//                 ),
//               ],
//               if (match.round.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 _buildInfoRow(
//                   icon: Icons.flag,
//                   label: 'রাউন্ড',
//                   value: match.round,
//                 ),
//               ],
//               if (match.venue.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 _buildInfoRow(
//                   icon: Icons.stadium,
//                   label: 'স্টেডিয়াম',
//                   value: match.venue,
//                 ),
//               ],
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Teams Info
//           if (teamA != null || teamB != null)
//             _buildInfoCard(
//               title: 'টিম তথ্য',
//               icon: Icons.group,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildTeamInfoBox(
//                         teamName: _getTeamName(match.teamAId),
//                         players: teamA?.playersCount.toString() ?? '-',
//                         location: teamA?.upazila ?? '-',
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _buildTeamInfoBox(
//                         teamName: _getTeamName(match.teamBId),
//                         players: teamB?.playersCount.toString() ?? '-',
//                         location: teamB?.upazila ?? '-',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//           const SizedBox(height: 20),
//
//           // Match Result (for finished matches)
//           if (match.status == 'finished' || match.status == 'completed')
//             _buildResultCard(match),
//         ],
//       ),
//     );
//   }
//
//   // ==================== TIMELINE TAB ====================
//
//   Widget _buildTimelineTab(TournamentMatch match, String teamAName, String teamBName) {
//     if (match.timeline.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.timeline_outlined,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'কোন ইভেন্ট নেই',
//               style: TextStyle(
//                 color: Colors.white54,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     // Sort timeline by minute in descending order (latest events on top)
//     final sortedTimeline = List<TimelineEvent>.from(match.timeline)
//       ..sort((a, b) => b.minute.compareTo(a.minute));
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: sortedTimeline.length,
//       itemBuilder: (context, index) {
//         final event = sortedTimeline[index];
//         final isLast = index == sortedTimeline.length - 1;
//         return _buildTimelineItem(event, isLast, teamAName, teamBName);
//       },
//     );
//   }
//
//   Widget _buildTimelineItem(TimelineEvent event, bool isLast, String teamAName, String teamBName) {
//     IconData icon;
//     Color color;
//     String eventText;
//
//     switch (event.type.toLowerCase()) {
//       case 'goal':
//         icon = Icons.sports_soccer;
//         color = Colors.greenAccent;
//         eventText = '⚽ গোল';
//         break;
//       case 'yellow_card':
//       case 'card':
//         if (event.details == 'yellow_card') {
//           icon = Icons.square;
//           color = Colors.yellow;
//           eventText = '🟨 হলুদ কার্ড';
//         } else if (event.details == 'red_card') {
//           icon = Icons.square;
//           color = Colors.red;
//           eventText = '🟥 লাল কার্ড';
//         } else {
//           icon = Icons.square;
//           color = Colors.yellow;
//           eventText = '🟨 হলুদ কার্ড';
//         }
//         break;
//       case 'red_card':
//         icon = Icons.square;
//         color = Colors.red;
//         eventText = '🟥 লাল কার্ড';
//         break;
//       case 'substitution':
//         icon = Icons.swap_horiz;
//         color = Colors.blueAccent;
//         eventText = '🔄 সাবস্টিটিউশন';
//         break;
//       default:
//         icon = Icons.circle;
//         color = Colors.grey;
//         eventText = event.type;
//     }
//
//     bool isTeamA = event.team.toUpperCase() == 'A';
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Team A Event (Left Side)
//           Expanded(
//             child: isTeamA
//                 ? _buildEventCard(
//               playerName: event.playerName,
//               eventText: eventText,
//               color: Colors.blue,
//               isLeft: true,
//             )
//                 : const SizedBox(),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Center Timeline
//           Column(
//             children: [
//               // Minute Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 6,
//                   horizontal: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: color.withOpacity(0.4),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   "${event.minute}'",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               // Timeline Line
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 60,
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         color.withOpacity(0.5),
//                         Colors.white24,
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//
//           const SizedBox(width: 12),
//
//           // Team B Event (Right Side)
//           Expanded(
//             child: !isTeamA
//                 ? _buildEventCard(
//               playerName: event.playerName,
//               eventText: eventText,
//               color: Colors.orange,
//               isLeft: false,
//             )
//                 : const SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEventCard({
//     required String playerName,
//     required String eventText,
//     required Color color,
//     required bool isLeft,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.4),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment:
//         isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             playerName,
//             textAlign: isLeft ? TextAlign.right : TextAlign.left,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 8,
//               vertical: 4,
//             ),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               eventText,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ==================== STATS TAB ====================
//
//   Widget _buildStatsTab(TournamentMatch match) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_matches')
//           .doc(match.id)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         }
//
//         if (!snapshot.hasData) {
//           return _buildNoStatsMessage();
//         }
//
//         final data = snapshot.data!.data() as Map<String, dynamic>?;
//
//         if (data == null || data['stats'] == null) {
//           return _buildNoStatsMessage();
//         }
//
//         final stats = data['stats'] as Map<String, dynamic>;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Overview Stats Cards
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatOverviewCard(
//                       title: 'গোল',
//                       teamAValue: '${match.scoreA}',
//                       teamBValue: '${match.scoreB}',
//                       icon: Icons.sports_soccer,
//                       color: const Color(0xFF4CAF50),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatOverviewCard(
//                       title: 'শট',
//                       teamAValue: '${stats['shotsA'] ?? 0}',
//                       teamBValue: '${stats['shotsB'] ?? 0}',
//                       icon: Icons.adjust,
//                       color: const Color(0xFF2196F3),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // Detailed Stats
//               _buildStatBar(
//                 'বল নিয়ন্ত্রণ',
//                 stats['possessionA'] ?? 50,
//                 stats['possessionB'] ?? 50,
//                 isPercentage: true,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'শট',
//                 stats['shotsA'] ?? 0,
//                 stats['shotsB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'টার্গেট শট',
//                 stats['shotsOnTargetA'] ?? 0,
//                 stats['shotsOnTargetB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'কর্নার',
//                 stats['cornersA'] ?? 0,
//                 stats['cornersB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'ফাউল',
//                 stats['foulsA'] ?? 0,
//                 stats['foulsB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'হলুদ কার্ড',
//                 stats['yellowCardsA'] ?? 0,
//                 stats['yellowCardsB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'লাল কার্ড',
//                 stats['redCardsA'] ?? 0,
//                 stats['redCardsB'] ?? 0,
//               ),
//               const SizedBox(height: 20),
//               _buildStatBar(
//                 'অফসাইড',
//                 stats['offsidesA'] ?? 0,
//                 stats['offsidesB'] ?? 0,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildNoStatsMessage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.bar_chart,
//             size: 64,
//             color: Colors.white30,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'পরিসংখ্যান নেই',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatOverviewCard({
//     required String title,
//     required String teamAValue,
//     required String teamBValue,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             color.withOpacity(0.2),
//             color.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 32),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               color: color,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 teamAValue,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 '-',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.3),
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 teamBValue,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatBar(
//       String label,
//       int valueA,
//       int valueB, {
//         bool isPercentage = false,
//       }) {
//     int total = valueA + valueB;
//     double percentageA = total > 0 ? (valueA / total) : 0.5;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               isPercentage ? '$valueA%' : '$valueA',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//             Text(
//               isPercentage ? '$valueB%' : '$valueB',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Stack(
//             children: [
//               Container(
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.3),
//                 ),
//               ),
//               FractionallySizedBox(
//                 widthFactor: percentageA,
//                 child: Container(
//                   height: 12,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue, Colors.blueAccent],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ==================== LINEUP TAB ====================
//
//   Widget _buildLineupTab(TournamentMatch match, String teamAName, String teamBName) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('tournament_matches')
//           .doc(match.id)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         }
//
//         if (!snapshot.hasData) {
//           return _buildNoLineupMessage();
//         }
//
//         final data = snapshot.data!.data() as Map<String, dynamic>?;
//
//         if (data == null) {
//           return _buildNoLineupMessage();
//         }
//
//         // Handle both structures
//         dynamic lineupAData;
//         dynamic lineupBData;
//
//         if (data['lineUpA'] != null) {
//           final lineupAMap = data['lineUpA'] as Map<String, dynamic>;
//
//           if (lineupAMap.containsKey('lineUpA')) {
//             lineupAData = {
//               'formation': lineupAMap['lineUpA'],
//               'players': lineupAMap['players'] ?? []
//             };
//           } else if (lineupAMap.containsKey('formation')) {
//             lineupAData = lineupAMap;
//           }
//         }
//
//         if (data['lineUpB'] != null) {
//           final lineupBMap = data['lineUpB'] as Map<String, dynamic>;
//
//           if (lineupBMap.containsKey('lineUpB')) {
//             lineupBData = {
//               'formation': lineupBMap['lineUpB'],
//               'players': lineupBMap['players'] ?? []
//             };
//           } else if (lineupBMap.containsKey('formation')) {
//             lineupBData = lineupBMap;
//           }
//         }
//
//         if (lineupAData == null && lineupBData == null) {
//           return _buildNoLineupMessage();
//         }
//
//         return DefaultTabController(
//           length: 2,
//           child: Column(
//             children: [
//               // Team Tabs
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF16213E),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.1),
//                     width: 1,
//                   ),
//                 ),
//                 child: TabBar(
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.blue.withOpacity(0.3),
//                         Colors.blue.withOpacity(0.2),
//                       ],
//                     ),
//                   ),
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.white54,
//                   labelStyle: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   unselectedLabelStyle: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   tabs: [
//                     Tab(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Flexible(
//                             child: Text(
//                               teamAName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Tab(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Flexible(
//                             child: Text(
//                               teamBName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Team Lineup Content
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     // Team A Lineup
//                     _buildSingleTeamLineup(
//                       lineupAData,
//                       teamAName,
//                       Colors.blue,
//                     ),
//                     // Team B Lineup
//                     _buildSingleTeamLineup(
//                       lineupBData,
//                       teamBName,
//                       Colors.orange,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildNoLineupMessage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.sports_outlined,
//             size: 64,
//             color: Colors.white30,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'লাইনআপ নেই',
//             style: TextStyle(
//               color: Colors.white54,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSingleTeamLineup(
//       dynamic lineupData,
//       String teamName,
//       Color teamColor,
//       ) {
//     if (lineupData == null) {
//       return _buildNoLineupMessage();
//     }
//
//     final lineup = lineupData as Map<String, dynamic>;
//     final String formation = lineup['formation'] ?? '4-4-2';
//     final List<dynamic> playersData = lineup['players'] ?? [];
//
//     if (playersData.isEmpty) {
//       return _buildNoLineupMessage();
//     }
//
//     // Parse players
//     List<Map<String, dynamic>> players = [];
//     for (var playerData in playersData) {
//       if (playerData is Map) {
//         players.add(Map<String, dynamic>.from(playerData as Map));
//       }
//     }
//
//     // Group by position
//     final gk = players.where((p) =>
//     (p['position']?.toString().toUpperCase() == 'GK') &&
//         !(p['isSubstitute'] ?? false)).toList();
//
//     final def = players.where((p) =>
//     (p['position']?.toString().toUpperCase() == 'DEF') &&
//         !(p['isSubstitute'] ?? false)).toList();
//
//     final mid = players.where((p) =>
//     (p['position']?.toString().toUpperCase() == 'MID') &&
//         !(p['isSubstitute'] ?? false)).toList();
//
//     final fwd = players.where((p) =>
//     (p['position']?.toString().toUpperCase() == 'FWD') &&
//         !(p['isSubstitute'] ?? false)).toList();
//
//     final subs = players.where((p) =>
//     p['isSubstitute'] == true).toList();
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Formation Header
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   teamColor.withOpacity(0.2),
//                   teamColor.withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: teamColor, width: 2),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.shield,
//                       color: teamColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         teamName.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: teamColor.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.sports_soccer,
//                         color: teamColor,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Formation: $formation',
//                         style: TextStyle(
//                           color: teamColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Starting XI Header
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: teamColor,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'স্টার্টিং ইলেভেন',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Positions
//           if (gk.isNotEmpty) ...[
//             _buildPositionGroupFull('গোলরক্ষক', gk, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (def.isNotEmpty) ...[
//             _buildPositionGroupFull('ডিফেন্ডার', def, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (mid.isNotEmpty) ...[
//             _buildPositionGroupFull('মিডফিল্ডার', mid, teamColor),
//             const SizedBox(height: 16),
//           ],
//           if (fwd.isNotEmpty) ...[
//             _buildPositionGroupFull('ফরোয়ার্ড', fwd, teamColor),
//           ],
//
//           // Substitutes
//           if (subs.isNotEmpty) ...[
//             const SizedBox(height: 32),
//             Row(
//               children: [
//                 Container(
//                   width: 4,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white54,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'সাবস্টিটিউট',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...subs.map((player) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _buildPlayerCardFull(player, teamColor),
//             )),
//           ],
//
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPositionGroupFull(
//       String position,
//       List<Map<String, dynamic>> players,
//       Color color,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             position,
//             style: TextStyle(
//               color: color,
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...players.map((player) => Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _buildPlayerCardFull(player, color),
//         )),
//       ],
//     );
//   }
//
//   Widget _buildPlayerCardFull(Map<String, dynamic> player, Color color) {
//     final String playerName = player['playerName']?.toString() ?? 'Unknown';
//     final int jerseyNumber = player['jerseyNumber'] is int
//         ? player['jerseyNumber']
//         : int.tryParse(player['jerseyNumber']?.toString() ?? '0') ?? 0;
//     final bool isCaptain = player['isCaptain'] == true;
//     final String position = player['position']?.toString() ?? '';
//
//     String firstLetter = playerName.isNotEmpty
//         ? playerName[0].toUpperCase()
//         : '?';
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isCaptain ? Colors.amber : color.withOpacity(0.3),
//           width: isCaptain ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.4),
//                   color.withOpacity(0.2),
//                 ],
//               ),
//               shape: BoxShape.circle,
//               border: Border.all(color: color, width: 2),
//             ),
//             child: Center(
//               child: Text(
//                 firstLetter,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           // Player Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         playerName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (isCaptain)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.amber.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.amber),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Captain',
//                               style: TextStyle(
//                                 color: Colors.amber,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     _getPositionFullName(position),
//                     style: TextStyle(
//                       color: color,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Jersey Number
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.3),
//                   color.withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.5), width: 2),
//             ),
//             child: Center(
//               child: Text(
//                 '$jerseyNumber',
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ==================== HELPER WIDGETS ====================
//
//   Widget _buildInfoCard({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0F3460),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white54, size: 18),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white54, fontSize: 12),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTeamInfoBox({
//     required String teamName,
//     required String players,
//     required String location,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F3460).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             teamName,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     players,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     'খেলোয়াড়',
//                     style: TextStyle(color: Colors.white54, fontSize: 11),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             location,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.white60, fontSize: 11),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildResultCard(TournamentMatch match) {
//     String winner;
//     if (match.scoreA > match.scoreB) {
//       winner = _getTeamName(match.teamAId);
//     } else if (match.scoreB > match.scoreA) {
//       winner = _getTeamName(match.teamBId);
//     } else {
//       winner = 'Draw';
//     }
//
//     if (winner == 'Draw') {
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6C757D), Color(0xFF495057)],
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.handshake, color: Colors.white, size: 30),
//             SizedBox(width: 12),
//             Text(
//               'ম্যাচ ড্র',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF28A745), Color(0xFF20C997)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF28A745).withOpacity(0.4),
//             blurRadius: 15,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.emoji_events, color: Colors.white, size: 30),
//           const SizedBox(width: 12),
//           Column(
//             children: [
//               const Text(
//                 'বিজয়ী',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//               Text(
//                 winner.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/team_model.dart';

// Providers
import '../../models/tournament_models/tournament_match_model.dart';
import '../../providers/team_provider.dart';

/// Tournament Match Details Screen - Same Design as Regular Match
class TournamentMatchDetailsScreen extends StatefulWidget {
  final TournamentMatch match;
  final TeamProvider teamProvider;

  const TournamentMatchDetailsScreen({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  State<TournamentMatchDetailsScreen> createState() =>
      _TournamentMatchDetailsScreenState();
}

class _TournamentMatchDetailsScreenState
    extends State<TournamentMatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== HELPER METHODS ====================

  String _getTeamLogoUrl(String teamId) {
    TeamModel? team = widget.teamProvider.getTeamById(teamId);
    return team?.logoUrl ?? '';
  }

  String _getTeamName(String teamId) {
    TeamModel? team = widget.teamProvider.getTeamById(teamId);
    return team?.name ?? 'Unknown';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      case 'finished':
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return '🔴 লাইভ চলছে';
      case 'upcoming':
        return '📅 আসন্ন ম্যাচ';
      case 'finished':
      case 'completed':
        return '✅ ম্যাচ সমাপ্ত';
      default:
        return status;
    }
  }

  String _getPositionFullName(String position) {
    switch (position.toUpperCase()) {
      case 'GK':
        return 'গোলরক্ষক';
      case 'DEF':
        return 'ডিফেন্ডার';
      case 'MID':
        return 'মিডফিল্ডার';
      case 'FWD':
        return 'ফরোয়ার্ড';
      default:
        return position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tournament_matches')
            .doc(widget.match.id)
            .snapshots(),
        builder: (context, snapshot) {
          TournamentMatch match = widget.match;

          if (snapshot.hasData && snapshot.data != null) {
            try {
              match = TournamentMatch.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
                snapshot.data!.id,
              );
            } catch (e) {
              debugPrint('Error parsing match: $e');
            }
          }

          String teamALogoUrl = _getTeamLogoUrl(match.teamAId);
          String teamBLogoUrl = _getTeamLogoUrl(match.teamBId);
          String teamAName = _getTeamName(match.teamAId);
          String teamBName = _getTeamName(match.teamBId);

          return CustomScrollView(
            slivers: [
              // ==================== APP BAR ====================
              SliverAppBar(
                expandedHeight: 380,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(match.status),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _getStatusColor(match.status)
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (match.status == 'live')
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  _getStatusText(match.status),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Score Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Team A
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildTeamLogo(teamALogoUrl, size: 70),
                                    const SizedBox(height: 12),
                                    Text(
                                      teamAName.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Score
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${match.scoreA}',
                                      style: TextStyle(
                                        color: match.scoreA > match.scoreB
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${match.scoreB}',
                                      style: TextStyle(
                                        color: match.scoreB > match.scoreA
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Team B
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildTeamLogo(teamBLogoUrl, size: 70),
                                    const SizedBox(height: 12),
                                    Text(
                                      teamBName.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Tournament & Round - ✅ FIXED
                          if (match.tournamentId.isNotEmpty) ...[
                            _buildTournamentNameBadge(match.tournamentId),
                          ],

                          if (match.round.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              match.round,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],

                          if (match.venue.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  match.venue,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: const Color(0xFF16213E),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: const [
                        Tab(text: 'ম্যাচ তথ্য'),
                        Tab(text: 'টাইমলাইন'),
                        Tab(text: 'পরিসংখ্যান'),
                        Tab(text: 'লাইনআপ'),
                      ],
                    ),
                  ),
                ),
              ),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMatchInfoTab(match),
                    _buildTimelineTab(match, teamAName, teamBName),
                    _buildStatsTab(match),
                    _buildLineupTab(match, teamAName, teamBName),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== ✅ NEW: TOURNAMENT NAME BADGE ====================

  Widget _buildTournamentNameBadge(String tournamentId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('tournaments')
          .doc(tournamentId)
          .get(),
      builder: (context, snapshot) {
        String tournamentName = tournamentId; // Fallback to ID

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null && data['name'] != null) {
            tournamentName = data['name']; // ✅ Get actual tournament name
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withOpacity(0.3),
                Colors.cyan.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.cyan.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.cyan,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tournamentName.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== TEAM LOGO ====================

  Widget _buildTeamLogo(String logoUrl, {double size = 70}) {
    if (logoUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF0F3460),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
        ),
        child: Icon(
          Icons.shield,
          color: Colors.white60,
          size: size * 0.5,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xFF0F3460),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFF0F3460),
            child: Icon(
              Icons.shield,
              color: Colors.white60,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== MATCH INFO TAB ====================

  Widget _buildMatchInfoTab(TournamentMatch match) {
    TeamModel? teamA = widget.teamProvider.getTeamById(match.teamAId);
    TeamModel? teamB = widget.teamProvider.getTeamById(match.teamBId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Basic Match Info
          _buildInfoCard(
            title: 'ম্যাচ বিবরণ',
            icon: Icons.info_outline,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'তারিখ',
                value: DateFormat('EEEE, dd MMMM yyyy')
                    .format(match.matchDate),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.access_time,
                label: 'সময়',
                value: DateFormat('hh:mm a').format(match.matchDate),
              ),
              if (match.tournamentId.isNotEmpty) ...[
                const SizedBox(height: 16),
                // ✅ Tournament name in info tab too
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('tournaments')
                      .doc(match.tournamentId)
                      .get(),
                  builder: (context, snapshot) {
                    String tournamentName = match.tournamentId;
                    if (snapshot.hasData && snapshot.data != null) {
                      final data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null && data['name'] != null) {
                        tournamentName = data['name'];
                      }
                    }
                    return _buildInfoRow(
                      icon: Icons.emoji_events,
                      label: 'টুর্নামেন্ট',
                      value: tournamentName,
                    );
                  },
                ),
              ],
              if (match.round.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.flag,
                  label: 'রাউন্ড',
                  value: match.round,
                ),
              ],
              if (match.venue.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.stadium,
                  label: 'স্টেডিয়াম',
                  value: match.venue,
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Teams Info
          if (teamA != null || teamB != null)
            _buildInfoCard(
              title: 'টিম তথ্য',
              icon: Icons.group,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTeamInfoBox(
                        teamName: _getTeamName(match.teamAId),
                        players: teamA?.playersCount.toString() ?? '-',
                        location: teamA?.upazila ?? '-',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTeamInfoBox(
                        teamName: _getTeamName(match.teamBId),
                        players: teamB?.playersCount.toString() ?? '-',
                        location: teamB?.upazila ?? '-',
                      ),
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Match Result (for finished matches)
          if (match.status == 'finished' || match.status == 'completed')
            _buildResultCard(match),
        ],
      ),
    );
  }

  // ==================== TIMELINE TAB ====================

  Widget _buildTimelineTab(TournamentMatch match, String teamAName, String teamBName) {
    if (match.timeline.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'কোন ইভেন্ট নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Sort timeline by minute in descending order (latest events on top)
    final sortedTimeline = List<TimelineEvent>.from(match.timeline)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedTimeline.length,
      itemBuilder: (context, index) {
        final event = sortedTimeline[index];
        final isLast = index == sortedTimeline.length - 1;
        return _buildTimelineItem(event, isLast, teamAName, teamBName);
      },
    );
  }

  Widget _buildTimelineItem(TimelineEvent event, bool isLast, String teamAName, String teamBName) {
    IconData icon;
    Color color;
    String eventText;

    switch (event.type.toLowerCase()) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = Colors.greenAccent;
        eventText = '⚽ গোল';
        break;
      case 'yellow_card':
      case 'card':
        if (event.details == 'yellow_card') {
          icon = Icons.square;
          color = Colors.yellow;
          eventText = '🟨 হলুদ কার্ড';
        } else if (event.details == 'red_card') {
          icon = Icons.square;
          color = Colors.red;
          eventText = '🟥 লাল কার্ড';
        } else {
          icon = Icons.square;
          color = Colors.yellow;
          eventText = '🟨 হলুদ কার্ড';
        }
        break;
      case 'red_card':
        icon = Icons.square;
        color = Colors.red;
        eventText = '🟥 লাল কার্ড';
        break;
      case 'substitution':
        icon = Icons.swap_horiz;
        color = Colors.blueAccent;
        eventText = '🔄 সাবস্টিটিউশন';
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
        eventText = event.type;
    }

    bool isTeamA = event.team.toUpperCase() == 'A';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team A Event (Left Side)
          Expanded(
            child: isTeamA
                ? _buildEventCard(
              playerName: event.playerName,
              eventText: eventText,
              color: Colors.blue,
              isLeft: true,
            )
                : const SizedBox(),
          ),

          const SizedBox(width: 12),

          // Center Timeline
          Column(
            children: [
              // Minute Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  "${event.minute}'",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Timeline Line
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withOpacity(0.5),
                        Colors.white24,
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Team B Event (Right Side)
          Expanded(
            child: !isTeamA
                ? _buildEventCard(
              playerName: event.playerName,
              eventText: eventText,
              color: Colors.orange,
              isLeft: false,
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String playerName,
    required String eventText,
    required Color color,
    required bool isLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            playerName,
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              eventText,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATS TAB ====================

  Widget _buildStatsTab(TournamentMatch match) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .doc(match.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData) {
          return _buildNoStatsMessage();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || data['stats'] == null) {
          return _buildNoStatsMessage();
        }

        final stats = data['stats'] as Map<String, dynamic>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Overview Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatOverviewCard(
                      title: 'গোল',
                      teamAValue: '${match.scoreA}',
                      teamBValue: '${match.scoreB}',
                      icon: Icons.sports_soccer,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatOverviewCard(
                      title: 'শট',
                      teamAValue: '${stats['shotsA'] ?? 0}',
                      teamBValue: '${stats['shotsB'] ?? 0}',
                      icon: Icons.adjust,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Detailed Stats
              _buildStatBar(
                'বল নিয়ন্ত্রণ',
                stats['possessionA'] ?? 50,
                stats['possessionB'] ?? 50,
                isPercentage: true,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'শট',
                stats['shotsA'] ?? 0,
                stats['shotsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'টার্গেট শট',
                stats['shotsOnTargetA'] ?? 0,
                stats['shotsOnTargetB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'কর্নার',
                stats['cornersA'] ?? 0,
                stats['cornersB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'ফাউল',
                stats['foulsA'] ?? 0,
                stats['foulsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'হলুদ কার্ড',
                stats['yellowCardsA'] ?? 0,
                stats['yellowCardsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'লাল কার্ড',
                stats['redCardsA'] ?? 0,
                stats['redCardsB'] ?? 0,
              ),
              const SizedBox(height: 20),
              _buildStatBar(
                'অফসাইড',
                stats['offsidesA'] ?? 0,
                stats['offsidesB'] ?? 0,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoStatsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Colors.white30,
          ),
          const SizedBox(height: 16),
          Text(
            'পরিসংখ্যান নেই',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatOverviewCard({
    required String title,
    required String teamAValue,
    required String teamBValue,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                teamAValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '-',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 20,
                ),
              ),
              Text(
                teamBValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(
      String label,
      int valueA,
      int valueB, {
        bool isPercentage = false,
      }) {
    int total = valueA + valueB;
    double percentageA = total > 0 ? (valueA / total) : 0.5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isPercentage ? '$valueA%' : '$valueA',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              isPercentage ? '$valueB%' : '$valueB',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentageA,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== LINEUP TAB ====================

  Widget _buildLineupTab(TournamentMatch match, String teamAName, String teamBName) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tournament_matches')
          .doc(match.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData) {
          return _buildNoLineupMessage();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null) {
          return _buildNoLineupMessage();
        }

        // Handle both structures
        dynamic lineupAData;
        dynamic lineupBData;

        if (data['lineUpA'] != null) {
          final lineupAMap = data['lineUpA'] as Map<String, dynamic>;

          if (lineupAMap.containsKey('lineUpA')) {
            lineupAData = {
              'formation': lineupAMap['lineUpA'],
              'players': lineupAMap['players'] ?? []
            };
          } else if (lineupAMap.containsKey('formation')) {
            lineupAData = lineupAMap;
          }
        }

        if (data['lineUpB'] != null) {
          final lineupBMap = data['lineUpB'] as Map<String, dynamic>;

          if (lineupBMap.containsKey('lineUpB')) {
            lineupBData = {
              'formation': lineupBMap['lineUpB'],
              'players': lineupBMap['players'] ?? []
            };
          } else if (lineupBMap.containsKey('formation')) {
            lineupBData = lineupBMap;
          }
        }

        if (lineupAData == null && lineupBData == null) {
          return _buildNoLineupMessage();
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // Team Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.blue.withOpacity(0.2),
                      ],
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              teamAName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              teamBName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Team Lineup Content
              Expanded(
                child: TabBarView(
                  children: [
                    // Team A Lineup
                    _buildSingleTeamLineup(
                      lineupAData,
                      teamAName,
                      Colors.blue,
                    ),
                    // Team B Lineup
                    _buildSingleTeamLineup(
                      lineupBData,
                      teamBName,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoLineupMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_outlined,
            size: 64,
            color: Colors.white30,
          ),
          const SizedBox(height: 16),
          Text(
            'লাইনআপ নেই',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTeamLineup(
      dynamic lineupData,
      String teamName,
      Color teamColor,
      ) {
    if (lineupData == null) {
      return _buildNoLineupMessage();
    }

    final lineup = lineupData as Map<String, dynamic>;
    final String formation = lineup['formation'] ?? '4-4-2';
    final List<dynamic> playersData = lineup['players'] ?? [];

    if (playersData.isEmpty) {
      return _buildNoLineupMessage();
    }

    // Parse players
    List<Map<String, dynamic>> players = [];
    for (var playerData in playersData) {
      if (playerData is Map) {
        players.add(Map<String, dynamic>.from(playerData as Map));
      }
    }

    // Group by position
    final gk = players
        .where((p) =>
    (p['position']?.toString().toUpperCase() == 'GK') &&
        !(p['isSubstitute'] ?? false))
        .toList();

    final def = players
        .where((p) =>
    (p['position']?.toString().toUpperCase() == 'DEF') &&
        !(p['isSubstitute'] ?? false))
        .toList();

    final mid = players
        .where((p) =>
    (p['position']?.toString().toUpperCase() == 'MID') &&
        !(p['isSubstitute'] ?? false))
        .toList();

    final fwd = players
        .where((p) =>
    (p['position']?.toString().toUpperCase() == 'FWD') &&
        !(p['isSubstitute'] ?? false))
        .toList();

    final subs = players.where((p) => p['isSubstitute'] == true).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Formation Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  teamColor.withOpacity(0.2),
                  teamColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: teamColor, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      color: teamColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        teamName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: teamColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        color: teamColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Formation: $formation',
                        style: TextStyle(
                          color: teamColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Starting XI Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: teamColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'স্টার্টিং ইলেভেন',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Positions
          if (gk.isNotEmpty) ...[
            _buildPositionGroupFull('গোলরক্ষক', gk, teamColor),
            const SizedBox(height: 16),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroupFull('ডিফেন্ডার', def, teamColor),
            const SizedBox(height: 16),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroupFull('মিডফিল্ডার', mid, teamColor),
            const SizedBox(height: 16),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroupFull('ফরোয়ার্ড', fwd, teamColor),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'সাবস্টিটিউট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...subs.map((player) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPlayerCardFull(player, teamColor),
            )),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPositionGroupFull(
      String position,
      List<Map<String, dynamic>> players,
      Color color,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            position,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPlayerCardFull(player, color),
        )),
      ],
    );
  }

  Widget _buildPlayerCardFull(Map<String, dynamic> player, Color color) {
    final String playerName = player['playerName']?.toString() ?? 'Unknown';
    final int jerseyNumber = player['jerseyNumber'] is int
        ? player['jerseyNumber']
        : int.tryParse(player['jerseyNumber']?.toString() ?? '0') ?? 0;
    final bool isCaptain = player['isCaptain'] == true;
    final String position = player['position']?.toString() ?? '';

    String firstLetter =
    playerName.isNotEmpty ? playerName[0].toUpperCase() : '?';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCaptain ? Colors.amber : color.withOpacity(0.3),
          width: isCaptain ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                firstLetter,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Captain',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getPositionFullName(position),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Jersey Number
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Text(
                '$jerseyNumber',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfoBox({
    required String teamName,
    required String players,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    players,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'খেলোয়াড়',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            location,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(TournamentMatch match) {
    String winner;
    if (match.scoreA > match.scoreB) {
      winner = _getTeamName(match.teamAId);
    } else if (match.scoreB > match.scoreA) {
      winner = _getTeamName(match.teamBId);
    } else {
      winner = 'Draw';
    }

    if (winner == 'Draw') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C757D), Color(0xFF495057)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake, color: Colors.white, size: 30),
            SizedBox(width: 12),
            Text(
              'ম্যাচ ড্র',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28A745), Color(0xFF20C997)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28A745).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Column(
            children: [
              const Text(
                'বিজয়ী',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                winner.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}