// //
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import '../models/match_model.dart';
// // import '../models/team_model.dart';
// // import '../providers/team_provider.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// //
// // class MatchDetailsScreen extends StatelessWidget {
// //   final MatchModel match;
// //   final TeamProvider teamProvider;
// //
// //   const MatchDetailsScreen({
// //     Key? key,
// //     required this.match,
// //     required this.teamProvider,
// //   }) : super(key: key);
// //
// //   // Get default flag URL based on team name
// //   String? _getDefaultLogoUrl(String teamName) {
// //     final name = teamName.toLowerCase();
// //
// //     final flags = {
// //       'bangladesh': 'https://flagcdn.com/w80/bd.png',
// //       'india': 'https://flagcdn.com/w80/in.png',
// //       'pakistan': 'https://flagcdn.com/w80/pk.png',
// //       'sri lanka': 'https://flagcdn.com/w80/lk.png',
// //       'afghanistan': 'https://flagcdn.com/w80/af.png',
// //       'nepal': 'https://flagcdn.com/w80/np.png',
// //       'bhutan': 'https://flagcdn.com/w80/bt.png',
// //       'maldives': 'https://flagcdn.com/w80/mv.png',
// //     };
// //
// //     for (var entry in flags.entries) {
// //       if (name.contains(entry.key)) {
// //         return entry.value;
// //       }
// //     }
// //
// //     return null;
// //   }
// //
// //   String _getTeamLogoUrl(String teamName) {
// //     TeamModel? team = teamProvider.getTeamByName(teamName);
// //     if (team != null && team.logoUrl.isNotEmpty) {
// //       return team.logoUrl;
// //     }
// //
// //     String? defaultUrl = _getDefaultLogoUrl(teamName);
// //     if (defaultUrl != null) {
// //       return defaultUrl;
// //     }
// //
// //     return '';
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     String teamALogoUrl = _getTeamLogoUrl(match.teamA);
// //     String teamBLogoUrl = _getTeamLogoUrl(match.teamB);
// //     TeamModel? teamA = teamProvider.getTeamByName(match.teamA);
// //     TeamModel? teamB = teamProvider.getTeamByName(match.teamB);
// //
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF1A1A2E),
// //       body: CustomScrollView(
// //         slivers: [
// //           // App Bar
// //           SliverAppBar(
// //             expandedHeight: 200,
// //             floating: false,
// //             pinned: true,
// //             backgroundColor: const Color(0xFF16213E),
// //             iconTheme: const IconThemeData(color: Colors.white),
// //             flexibleSpace: FlexibleSpaceBar(
// //               background: Container(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     begin: Alignment.topCenter,
// //                     end: Alignment.bottomCenter,
// //                     colors: [
// //                       const Color(0xFF16213E),
// //                       const Color(0xFF0F3460),
// //                     ],
// //                   ),
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const SizedBox(height: 60),
// //                     // Status Badge
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 20,
// //                         vertical: 8,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor(match.status),
// //                         borderRadius: BorderRadius.circular(20),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: _getStatusColor(match.status).withOpacity(0.5),
// //                             blurRadius: 10,
// //                             spreadRadius: 2,
// //                           ),
// //                         ],
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           if (match.status == 'live')
// //                             Container(
// //                               width: 8,
// //                               height: 8,
// //                               margin: const EdgeInsets.only(right: 8),
// //                               decoration: const BoxDecoration(
// //                                 color: Colors.white,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                             ),
// //                           Text(
// //                             _getStatusText(match.status),
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     // Tournament & Venue
// //                     if (match.tournament != null) ...[
// //                       Text(
// //                         match.tournament!,
// //                         style: const TextStyle(
// //                           color: Colors.white70,
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                     if (match.venue != null) ...[
// //                       const SizedBox(height: 4),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           const Icon(
// //                             Icons.location_on,
// //                             color: Colors.white60,
// //                             size: 14,
// //                           ),
// //                           const SizedBox(width: 4),
// //                           Text(
// //                             match.venue!,
// //                             style: const TextStyle(
// //                               color: Colors.white60,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // Content
// //           SliverToBoxAdapter(
// //             child: Column(
// //               children: [
// //                 const SizedBox(height: 20),
// //
// //                 // Score Section
// //                 Container(
// //                   margin: const EdgeInsets.symmetric(horizontal: 20),
// //                   padding: const EdgeInsets.all(24),
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [
// //                         const Color(0xFF16213E),
// //                         const Color(0xFF0F3460),
// //                       ],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                     borderRadius: BorderRadius.circular(20),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.3),
// //                         blurRadius: 15,
// //                         offset: const Offset(0, 5),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                     children: [
// //                       // Team A
// //                       Expanded(
// //                         child: Column(
// //                           children: [
// //                             _buildTeamLogo(teamALogoUrl, size: 90),
// //                             const SizedBox(height: 16),
// //                             Text(
// //                               match.teamA.toUpperCase(),
// //                               textAlign: TextAlign.center,
// //                               maxLines: 2,
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 letterSpacing: 1.2,
// //                               ),
// //                             ),
// //                             if (teamA != null) ...[
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 teamA.upazila,
// //                                 textAlign: TextAlign.center,
// //                                 style: const TextStyle(
// //                                   color: Colors.white60,
// //                                   fontSize: 12,
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),
// //
// //                       // Score
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 20,
// //                           vertical: 16,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(16),
// //                           border: Border.all(
// //                             color: Colors.white.withOpacity(0.2),
// //                             width: 2,
// //                           ),
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 Text(
// //                                   '${match.scoreA}',
// //                                   style: TextStyle(
// //                                     color: match.scoreA > match.scoreB
// //                                         ? Colors.greenAccent
// //                                         : Colors.white,
// //                                     fontSize: 48,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                                 const Padding(
// //                                   padding: EdgeInsets.symmetric(horizontal: 12),
// //                                   child: Text(
// //                                     ':',
// //                                     style: TextStyle(
// //                                       color: Colors.white54,
// //                                       fontSize: 36,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 Text(
// //                                   '${match.scoreB}',
// //                                   style: TextStyle(
// //                                     color: match.scoreB > match.scoreA
// //                                         ? Colors.greenAccent
// //                                         : Colors.white,
// //                                     fontSize: 48,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             if (match.status == 'live') ...[
// //                               const SizedBox(height: 8),
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 12,
// //                                   vertical: 4,
// //                                 ),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.red,
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 child: const Text(
// //                                   'LIVE',
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 11,
// //                                     letterSpacing: 1.5,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),
// //
// //                       // Team B
// //                       Expanded(
// //                         child: Column(
// //                           children: [
// //                             _buildTeamLogo(teamBLogoUrl, size: 90),
// //                             const SizedBox(height: 16),
// //                             Text(
// //                               match.teamB.toUpperCase(),
// //                               textAlign: TextAlign.center,
// //                               maxLines: 2,
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 letterSpacing: 1.2,
// //                               ),
// //                             ),
// //                             if (teamB != null) ...[
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 teamB.upazila,
// //                                 textAlign: TextAlign.center,
// //                                 style: const TextStyle(
// //                                   color: Colors.white60,
// //                                   fontSize: 12,
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 30),
// //
// //                 // Match Information Card
// //                 _buildInfoCard(
// //                   context,
// //                   title: 'ম্যাচ তথ্য',
// //                   icon: Icons.info_outline,
// //                   children: [
// //                     _buildInfoRow(
// //                       icon: Icons.calendar_today,
// //                       label: 'তারিখ',
// //                       value: DateFormat('EEEE, dd MMMM yyyy').format(match.date),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     _buildInfoRow(
// //                       icon: Icons.access_time,
// //                       label: 'সময়',
// //                       value: DateFormat('hh:mm a').format(match.time),
// //                     ),
// //                     if (match.tournament != null) ...[
// //                       const SizedBox(height: 16),
// //                       _buildInfoRow(
// //                         icon: Icons.emoji_events,
// //                         label: 'টুর্নামেন্ট',
// //                         value: match.tournament!,
// //                       ),
// //                     ],
// //                     if (match.venue != null) ...[
// //                       const SizedBox(height: 16),
// //                       _buildInfoRow(
// //                         icon: Icons.stadium,
// //                         label: 'স্টেডিয়াম',
// //                         value: match.venue!,
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //
// //                 // Teams Stats Card
// //                 if (teamA != null || teamB != null)
// //                   _buildInfoCard(
// //                     context,
// //                     title: 'টিম পরিসংখ্যান',
// //                     icon: Icons.group,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _buildStatBox(
// //                               team: match.teamA,
// //                               label: 'খেলোয়াড়',
// //                               value: teamA?.playersCount.toString() ?? '-',
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: _buildStatBox(
// //                               team: match.teamB,
// //                               label: 'খেলোয়াড়',
// //                               value: teamB?.playersCount.toString() ?? '-',
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //
// //                 const SizedBox(height: 20),
// //
// //                 // Match Result Card (for finished matches)
// //                 if (match.status == 'finished')
// //                   _buildResultCard(context),
// //
// //                 const SizedBox(height: 40),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoCard(
// //       BuildContext context, {
// //         required String title,
// //         required IconData icon,
// //         required List<Widget> children,
// //       }) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20),
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF16213E),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.2),
// //             blurRadius: 10,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF0F3460),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Icon(
// //                   icon,
// //                   color: Colors.white,
// //                   size: 20,
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //           ...children,
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoRow({
// //     required IconData icon,
// //     required String label,
// //     required String value,
// //   }) {
// //     return Row(
// //       children: [
// //         Icon(
// //           icon,
// //           color: Colors.white54,
// //           size: 18,
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 label,
// //                 style: const TextStyle(
// //                   color: Colors.white54,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               Text(
// //                 value,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildStatBox({
// //     required String team,
// //     required String label,
// //     required String value,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF0F3460).withOpacity(0.5),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: Colors.white.withOpacity(0.1),
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           Text(
// //             team,
// //             textAlign: TextAlign.center,
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //             style: const TextStyle(
// //               color: Colors.white70,
// //               fontSize: 12,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               color: Colors.white54,
// //               fontSize: 11,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildResultCard(BuildContext context) {
// //     String winner = match.scoreA > match.scoreB
// //         ? match.teamA
// //         : match.scoreB > match.scoreA
// //         ? match.teamB
// //         : 'Draw';
// //
// //     if (winner == 'Draw') {
// //       return Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 20),
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFF6C757D), Color(0xFF495057)],
// //           ),
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.handshake, color: Colors.white, size: 30),
// //             const SizedBox(width: 12),
// //             const Text(
// //               'Match Drawn',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20),
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF28A745), Color(0xFF20C997)],
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFF28A745).withOpacity(0.4),
// //             blurRadius: 15,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.emoji_events, color: Colors.white, size: 30),
// //           const SizedBox(width: 12),
// //           Column(
// //             children: [
// //               const Text(
// //                 'Winner',
// //                 style: TextStyle(
// //                   color: Colors.white70,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //               Text(
// //                 winner.toUpperCase(),
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                   letterSpacing: 1.5,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTeamLogo(String logoUrl, {double size = 80}) {
// //     if (logoUrl.isEmpty) {
// //       return Container(
// //         width: size,
// //         height: size,
// //         decoration: BoxDecoration(
// //           color: const Color(0xFF0F3460),
// //           shape: BoxShape.circle,
// //           border: Border.all(
// //             color: Colors.white.withOpacity(0.2),
// //             width: 3,
// //           ),
// //         ),
// //         child: Icon(
// //           Icons.shield,
// //           color: Colors.white60,
// //           size: size * 0.5,
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       width: size,
// //       height: size,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: Colors.white.withOpacity(0.3),
// //           width: 3,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.3),
// //             blurRadius: 10,
// //             spreadRadius: 2,
// //           ),
// //         ],
// //       ),
// //       child: ClipOval(
// //         child: CachedNetworkImage(
// //           imageUrl: logoUrl,
// //           fit: BoxFit.cover,
// //           placeholder: (context, url) => Container(
// //             color: const Color(0xFF0F3460),
// //             child: const Center(
// //               child: CircularProgressIndicator(
// //                 color: Colors.white,
// //                 strokeWidth: 2,
// //               ),
// //             ),
// //           ),
// //           errorWidget: (context, url, error) => Container(
// //             color: const Color(0xFF0F3460),
// //             child: Icon(
// //               Icons.shield,
// //               color: Colors.white60,
// //               size: size * 0.5,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'live':
// //         return Colors.red;
// //       case 'upcoming':
// //         return Colors.orange;
// //       case 'finished':
// //         return Colors.green;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   String _getStatusText(String status) {
// //     switch (status) {
// //       case 'live':
// //         return '🔴 লাইভ চলছে';
// //       case 'upcoming':
// //         return '📅 আসন্ন ম্যাচ';
// //       case 'finished':
// //         return '✅ ম্যাচ সমাপ্ত';
// //       default:
// //         return status;
// //     }
// //   }
// // }
//
//
// //
// // import 'package:flutter/material.dart';
// // import '../models/match_model.dart';
// // import '../providers/team_provider.dart';
// // import '../models/team_model.dart';
// // import 'match_info_tab.dart';
// // import 'match_timeline_tab.dart';
// // import 'match_stats_tab.dart';
// // import 'match_lineups_tab.dart';
// //
// // class MatchDetailsScreen extends StatelessWidget {
// //   final MatchModel match;
// //   final TeamProvider teamProvider;
// //
// //   const MatchDetailsScreen({
// //     Key? key,
// //     required this.match,
// //     required this.teamProvider,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     TeamModel? teamA = teamProvider.getTeamByName(match.teamA);
// //     TeamModel? teamB = teamProvider.getTeamByName(match.teamB);
// //
// //     return DefaultTabController(
// //       length: 4,
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFF1A1A2E),
// //         body: NestedScrollView(
// //           headerSliverBuilder: (context, innerBoxIsScrolled) => [
// //             SliverAppBar(
// //               pinned: true,
// //               expandedHeight: 220,
// //               backgroundColor: const Color(0xFF16213E),
// //               flexibleSpace: FlexibleSpaceBar(
// //                 background: _buildHeader(teamA, teamB),
// //               ),
// //               bottom: const TabBar(
// //                 indicatorColor: Colors.greenAccent,
// //                 labelColor: Colors.white,
// //                 unselectedLabelColor: Colors.white54,
// //                 tabs: [
// //                   Tab(text: "Info"),
// //                   Tab(text: "Timeline"),
// //                   Tab(text: "Stats"),
// //                   Tab(text: "Line-ups"),
// //                 ],
// //               ),
// //             ),
// //           ],
// //           body: TabBarView(
// //             children: [
// //               MatchInfoTab(match: match, teamProvider: teamProvider),
// //               MatchTimelineTab(matchId: match.id),
// //               MatchStatsTab(matchId: match.id),
// //               MatchLineupsTab(matchId: match.id),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader(TeamModel? teamA, TeamModel? teamB) {
// //     return Container(
// //       padding: const EdgeInsets.only(top: 70),
// //       decoration: const BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Color(0xFF16213E), Color(0xFF0F3460)],
// //           begin: Alignment.topCenter,
// //           end: Alignment.bottomCenter,
// //         ),
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(
// //             "${teamA?.name ?? 'Team A'}  vs  ${teamB?.name ?? 'Team B'}",
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             match.status.toUpperCase(),
// //             style: TextStyle(
// //               color: _getStatusColor(match.status),
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             "${match.scoreA} : ${match.scoreB}",
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 36,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'live':
// //         return Colors.redAccent;
// //       case 'upcoming':
// //         return Colors.orangeAccent;
// //       case 'finished':
// //         return Colors.greenAccent;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/match_model.dart';
// import '../models/team_model.dart';
// import '../providers/team_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class MatchDetailsScreen extends StatefulWidget {
//   final MatchModel match;
//   final TeamProvider teamProvider;
//
//   const MatchDetailsScreen({
//     Key? key,
//     required this.match,
//     required this.teamProvider,
//   }) : super(key: key);
//
//   @override
//   State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
// }
//
// class _MatchDetailsScreenState extends State<MatchDetailsScreen>
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
//   String? _getDefaultLogoUrl(String teamName) {
//     final name = teamName.toLowerCase();
//     final flags = {
//       'bangladesh': 'https://flagcdn.com/w80/bd.png',
//       'india': 'https://flagcdn.com/w80/in.png',
//       'pakistan': 'https://flagcdn.com/w80/pk.png',
//       'sri lanka': 'https://flagcdn.com/w80/lk.png',
//       'afghanistan': 'https://flagcdn.com/w80/af.png',
//       'nepal': 'https://flagcdn.com/w80/np.png',
//       'bhutan': 'https://flagcdn.com/w80/bt.png',
//       'maldives': 'https://flagcdn.com/w80/mv.png',
//     };
//
//     for (var entry in flags.entries) {
//       if (name.contains(entry.key)) {
//         return entry.value;
//       }
//     }
//     return null;
//   }
//
//   String _getTeamLogoUrl(String teamName) {
//     TeamModel? team = widget.teamProvider.getTeamByName(teamName);
//     if (team != null && team.logoUrl.isNotEmpty) {
//       return team.logoUrl;
//     }
//     String? defaultUrl = _getDefaultLogoUrl(teamName);
//     if (defaultUrl != null) {
//       return defaultUrl;
//     }
//     return '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String teamALogoUrl = _getTeamLogoUrl(widget.match.teamA);
//     String teamBLogoUrl = _getTeamLogoUrl(widget.match.teamB);
//     TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
//     TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: CustomScrollView(
//         slivers: [
//           // App Bar with Match Score
//           SliverAppBar(
//             expandedHeight: 280,
//             floating: false,
//             pinned: true,
//             backgroundColor: const Color(0xFF16213E),
//             iconTheme: const IconThemeData(color: Colors.white),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFF16213E),
//                       Color(0xFF0F3460),
//                     ],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 20),
//                       // Status Badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(widget.match.status),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: _getStatusColor(widget.match.status)
//                                   .withOpacity(0.5),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (widget.match.status == 'live')
//                               Container(
//                                 width: 8,
//                                 height: 8,
//                                 margin: const EdgeInsets.only(right: 8),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                             Text(
//                               _getStatusText(widget.match.status),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Score Section
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Team A
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 _buildTeamLogo(teamALogoUrl, size: 70),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   widget.match.teamA.toUpperCase(),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
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
//                           // Score
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 16,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.2),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   '${widget.match.scoreA}',
//                                   style: TextStyle(
//                                     color: widget.match.scoreA >
//                                         widget.match.scoreB
//                                         ? Colors.greenAccent
//                                         : Colors.white,
//                                     fontSize: 42,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 12),
//                                   child: Text(
//                                     ':',
//                                     style: TextStyle(
//                                       color: Colors.white54,
//                                       fontSize: 32,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   '${widget.match.scoreB}',
//                                   style: TextStyle(
//                                     color: widget.match.scoreB >
//                                         widget.match.scoreA
//                                         ? Colors.greenAccent
//                                         : Colors.white,
//                                     fontSize: 42,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // Team B
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 _buildTeamLogo(teamBLogoUrl, size: 70),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   widget.match.teamB.toUpperCase(),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 2,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // Tournament & Venue
//                       if (widget.match.tournament != null) ...[
//                         Text(
//                           widget.match.tournament!,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                       if (widget.match.venue != null) ...[
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               color: Colors.white60,
//                               size: 12,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               widget.match.venue!,
//                               style: const TextStyle(
//                                 color: Colors.white60,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(48),
//               child: Container(
//                 color: const Color(0xFF16213E),
//                 child: TabBar(
//                   controller: _tabController,
//                   indicatorColor: Colors.white,
//                   indicatorWeight: 3,
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.white60,
//                   labelStyle: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   unselectedLabelStyle: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   tabs: const [
//                     Tab(text: 'ম্যাচ তথ্য'),
//                     Tab(text: 'টাইমলাইন'),
//                     Tab(text: 'পরিসংখ্যান'),
//                     Tab(text: 'লাইনআপ'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Tab Content
//           SliverFillRemaining(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildMatchInfoTab(),
//                 _buildTimelineTab(),
//                 _buildStatsTab(),
//                 _buildLineupTab(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Match Info Tab
//   Widget _buildMatchInfoTab() {
//     TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
//     TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);
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
//                     .format(widget.match.date),
//               ),
//               const SizedBox(height: 16),
//               _buildInfoRow(
//                 icon: Icons.access_time,
//                 label: 'সময়',
//                 value: DateFormat('hh:mm a').format(widget.match.time),
//               ),
//               if (widget.match.tournament != null) ...[
//                 const SizedBox(height: 16),
//                 _buildInfoRow(
//                   icon: Icons.emoji_events,
//                   label: 'টুর্নামেন্ট',
//                   value: widget.match.tournament!,
//                 ),
//               ],
//               if (widget.match.venue != null) ...[
//                 const SizedBox(height: 16),
//                 _buildInfoRow(
//                   icon: Icons.stadium,
//                   label: 'স্টেডিয়াম',
//                   value: widget.match.venue!,
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
//                         teamName: widget.match.teamA,
//                         players: teamA?.playersCount.toString() ?? '-',
//                         location: teamA?.upazila ?? '-',
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _buildTeamInfoBox(
//                         teamName: widget.match.teamB,
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
//           if (widget.match.status == 'finished') _buildResultCard(),
//         ],
//       ),
//     );
//   }
//
//   // Timeline Tab
//   Widget _buildTimelineTab() {
//     if (widget.match.timeline.isEmpty) {
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
//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: widget.match.timeline.length,
//       itemBuilder: (context, index) {
//         final event = widget.match.timeline[index];
//         return _buildTimelineItem(event, index);
//       },
//     );
//   }
//
//   Widget _buildTimelineItem(MatchEvent event, int index) {
//     IconData icon;
//     Color color;
//
//     switch (event.type) {
//       case 'goal':
//         icon = Icons.sports_soccer;
//         color = Colors.greenAccent;
//         break;
//       case 'card':
//         icon = Icons.square;
//         color = event.details == 'red_card' ? Colors.red : Colors.yellow;
//         break;
//       case 'substitution':
//         icon = Icons.swap_horiz;
//         color = Colors.blueAccent;
//         break;
//       default:
//         icon = Icons.circle;
//         color = Colors.grey;
//     }
//
//     bool isTeamA = event.team == 'teamA';
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           // Minute
//           Container(
//             width: 50,
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF16213E),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               "${event.minute}'",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           // Timeline Line
//           Column(
//             children: [
//               if (index > 0)
//                 Container(
//                   width: 2,
//                   height: 20,
//                   color: Colors.white24,
//                 ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: color, width: 2),
//                 ),
//                 child: Icon(icon, color: color, size: 16),
//               ),
//               if (index < widget.match.timeline.length - 1)
//                 Container(
//                   width: 2,
//                   height: 20,
//                   color: Colors.white24,
//                 ),
//             ],
//           ),
//
//           const SizedBox(width: 16),
//
//           // Event Details
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF16213E),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: isTeamA
//                       ? Colors.blue.withOpacity(0.3)
//                       : Colors.orange.withOpacity(0.3),
//                   width: 2,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           event.playerName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         isTeamA ? widget.match.teamA : widget.match.teamB,
//                         style: TextStyle(
//                           color: Colors.white60,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _getEventDescription(event),
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getEventDescription(MatchEvent event) {
//     switch (event.type) {
//       case 'goal':
//         return '⚽ গোল করেছেন';
//       case 'card':
//         return event.details == 'red_card' ? '🟥 লাল কার্ড' : '🟨 হলুদ কার্ড';
//       case 'substitution':
//         return '🔄 পরিবর্তন';
//       default:
//         return event.details ?? '';
//     }
//   }
//
//   // Stats Tab
//   Widget _buildStatsTab() {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           Container(
//             color: const Color(0xFF16213E),
//             child: const TabBar(
//               indicatorColor: Colors.white,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white60,
//               tabs: [
//                 Tab(text: 'ম্যাচ পরিসংখ্যান'),
//                 Tab(text: 'H2H'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _buildMatchStatsView(),
//                 _buildH2HView(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMatchStatsView() {
//     if (widget.match.stats == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.bar_chart,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'পরিসংখ্যান নেই',
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
//     final stats = widget.match.stats!;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           _buildStatBar(
//             'বল নিয়ন্ত্রণ',
//             stats.possessionA,
//             stats.possessionB,
//             isPercentage: true,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'শট',
//             stats.shotsA,
//             stats.shotsB,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'টার্গেট শট',
//             stats.shotsOnTargetA,
//             stats.shotsOnTargetB,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'কর্নার',
//             stats.cornersA,
//             stats.cornersB,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'ফাউল',
//             stats.foulsA,
//             stats.foulsB,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'হলুদ কার্ড',
//             stats.yellowCardsA,
//             stats.yellowCardsB,
//           ),
//           const SizedBox(height: 20),
//           _buildStatBar(
//             'লাল কার্ড',
//             stats.redCardsA,
//             stats.redCardsB,
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
//   Widget _buildH2HView() {
//     if (widget.match.h2h == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.history,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'পূর্ববর্তী রেকর্ড নেই',
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
//     final h2h = widget.match.h2h!;
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           // Total Matches
//           _buildH2HCard(
//             title: 'মোট ম্যাচ',
//             value: '${h2h.totalMatches}',
//             icon: Icons.sports_soccer,
//           ),
//
//           const SizedBox(height: 16),
//
//           // Win Comparison
//           Row(
//             children: [
//               Expanded(
//                 child: _buildH2HCard(
//                   title: widget.match.teamA,
//                   subtitle: 'জয়',
//                   value: '${h2h.teamAWins}',
//                   color: Colors.blue,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'ড্র',
//                   value: '${h2h.draws}',
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: widget.match.teamB,
//                   subtitle: 'জয়',
//                   value: '${h2h.teamBWins}',
//                   color: Colors.orange,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Goals Comparison
//           Row(
//             children: [
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'গোল',
//                   subtitle: widget.match.teamA,
//                   value: '${h2h.teamAGoals}',
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildH2HCard(
//                   title: 'গোল',
//                   subtitle: widget.match.teamB,
//                   value: '${h2h.teamBGoals}',
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildH2HCard({
//     required String title,
//     required String value,
//     String? subtitle,
//     IconData? icon,
//     Color? color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: (color ?? Colors.white).withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         children: [
//           if (icon != null)
//             Icon(
//               icon,
//               color: color ?? Colors.white,
//               size: 24,
//             ),
//           if (icon != null) const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 12,
//             ),
//           ),
//           if (subtitle != null) ...[
//             Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: color ?? Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Lineup Tab
//   Widget _buildLineupTab() {
//     if (widget.match.lineUpA == null && widget.match.lineUpB == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.sports_outlined,
//               size: 64,
//               color: Colors.white30,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'লাইনআপ নেই',
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
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Team A Lineup
//           if (widget.match.lineUpA != null)
//             _buildTeamLineup(
//               widget.match.teamA,
//               widget.match.lineUpA!,
//               Colors.blue,
//             ),
//
//           const SizedBox(height: 20),
//
//           // Team B Lineup
//           if (widget.match.lineUpB != null)
//             _buildTeamLineup(
//               widget.match.teamB,
//               widget.match.lineUpB!,
//               Colors.orange,
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamLineup(String teamName, LineUp lineUp, Color color) {
//     // Group players by position
//     final gk = lineUp.players.where((p) => p.position == 'GK').toList();
//     final def = lineUp.players.where((p) => p.position == 'DEF').toList();
//     final mid = lineUp.players.where((p) => p.position == 'MID').toList();
//     final fwd = lineUp.players.where((p) => p.position == 'FWD').toList();
//     final subs = lineUp.players.where((p) => p.isSubstitute).toList();
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.shield, color: color, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 teamName.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   lineUp.formation,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Starting XI
//           if (gk.isNotEmpty) ...[
//             _buildPositionGroup('গোলরক্ষক', gk, color),
//             const SizedBox(height: 12),
//           ],
//           if (def.isNotEmpty) ...[
//             _buildPositionGroup('ডিফেন্ডার', def, color),
//             const SizedBox(height: 12),
//           ],
//           if (mid.isNotEmpty) ...[
//             _buildPositionGroup('মিডফিল্ডার', mid, color),
//             const SizedBox(height: 12),
//           ],
//           if (fwd.isNotEmpty) ...[
//             _buildPositionGroup('ফরোয়ার্ড', fwd, color),
//           ],
//
//           // Substitutes
//           if (subs.isNotEmpty) ...[
//             const SizedBox(height: 20),
//             const Divider(color: Colors.white24),
//             const SizedBox(height: 12),
//             Text(
//               'সাবস্টিটিউট',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ...subs.map((player) => _buildPlayerCard(player, color)),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPositionGroup(
//       String position, List<PlayerLineUp> players, Color color) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           position,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...players.map((player) => _buildPlayerCard(player, color)),
//       ],
//     );
//   }
//
//   Widget _buildPlayerCard(PlayerLineUp player, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0F3460).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: player.isCaptain
//               ? Colors.amber.withOpacity(0.5)
//               : Colors.white.withOpacity(0.1),
//           width: player.isCaptain ? 2 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           // Jersey Number
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 '${player.jerseyNumber}',
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Player Name
//           Expanded(
//             child: Text(
//               player.playerName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//
//           // Captain Badge
//           if (player.isCaptain)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.amber.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: Colors.amber, width: 1),
//               ),
//               child: const Text(
//                 'C',
//                 style: TextStyle(
//                   color: Colors.amber,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Helper Widgets
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
//   Widget _buildResultCard() {
//     String winner = widget.match.scoreA > widget.match.scoreB
//         ? widget.match.teamA
//         : widget.match.scoreB > widget.match.scoreA
//         ? widget.match.teamB
//         : 'Draw';
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
//
//   Widget _buildTeamLogo(String logoUrl, {double size = 80}) {
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
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'live':
//         return Colors.red;
//       case 'upcoming':
//         return Colors.orange;
//       case 'finished':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status) {
//       case 'live':
//         return '🔴 লাইভ চলছে';
//       case 'upcoming':
//         return '📅 আসন্ন ম্যাচ';
//       case 'finished':
//         return '✅ ম্যাচ সমাপ্ত';
//       default:
//         return status;
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchDetailsScreen extends StatefulWidget {
  final MatchModel match;
  final TeamProvider teamProvider;

  const MatchDetailsScreen({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen>
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

  String? _getDefaultLogoUrl(String teamName) {
    final name = teamName.toLowerCase();
    final flags = {
      'bangladesh': 'https://flagcdn.com/w80/bd.png',
      'india': 'https://flagcdn.com/w80/in.png',
      'pakistan': 'https://flagcdn.com/w80/pk.png',
      'sri lanka': 'https://flagcdn.com/w80/lk.png',
      'afghanistan': 'https://flagcdn.com/w80/af.png',
      'nepal': 'https://flagcdn.com/w80/np.png',
      'bhutan': 'https://flagcdn.com/w80/bt.png',
      'maldives': 'https://flagcdn.com/w80/mv.png',
    };

    for (var entry in flags.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  String _getTeamLogoUrl(String teamName) {
    TeamModel? team = widget.teamProvider.getTeamByName(teamName);
    if (team != null && team.logoUrl.isNotEmpty) {
      return team.logoUrl;
    }
    String? defaultUrl = _getDefaultLogoUrl(teamName);
    if (defaultUrl != null) {
      return defaultUrl;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    String teamALogoUrl = _getTeamLogoUrl(widget.match.teamA);
    String teamBLogoUrl = _getTeamLogoUrl(widget.match.teamB);
    TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
    TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          // App Bar with Match Score
          SliverAppBar(
            expandedHeight: 280,
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
                      const SizedBox(height: 20),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.match.status),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor(widget.match.status)
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.match.status == 'live')
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
                              _getStatusText(widget.match.status),
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
                                  widget.match.teamA.toUpperCase(),
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
                                  '${widget.match.scoreA}',
                                  style: TextStyle(
                                    color: widget.match.scoreA >
                                        widget.match.scoreB
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
                                  '${widget.match.scoreB}',
                                  style: TextStyle(
                                    color: widget.match.scoreB >
                                        widget.match.scoreA
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
                                  widget.match.teamB.toUpperCase(),
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

                      // Tournament & Venue
                      if (widget.match.tournament != null) ...[
                        Text(
                          widget.match.tournament!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (widget.match.venue != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white60,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.match.venue!,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
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
                _buildMatchInfoTab(),
                _buildTimelineTab(),
                _buildStatsTab(),
                _buildLineupTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Match Info Tab
  Widget _buildMatchInfoTab() {
    TeamModel? teamA = widget.teamProvider.getTeamByName(widget.match.teamA);
    TeamModel? teamB = widget.teamProvider.getTeamByName(widget.match.teamB);

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
                    .format(widget.match.date),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.access_time,
                label: 'সময়',
                value: DateFormat('hh:mm a').format(widget.match.time),
              ),
              if (widget.match.tournament != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.emoji_events,
                  label: 'টুর্নামেন্ট',
                  value: widget.match.tournament!,
                ),
              ],
              if (widget.match.venue != null) ...[
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.stadium,
                  label: 'স্টেডিয়াম',
                  value: widget.match.venue!,
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
                        teamName: widget.match.teamA,
                        players: teamA?.playersCount.toString() ?? '-',
                        location: teamA?.upazila ?? '-',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTeamInfoBox(
                        teamName: widget.match.teamB,
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
          if (widget.match.status == 'finished') _buildResultCard(),
        ],
      ),
    );
  }

  // Timeline Tab
  Widget _buildTimelineTab() {
    if (widget.match.timeline.isEmpty) {
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
    final sortedTimeline = List<MatchEvent>.from(widget.match.timeline)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedTimeline.length,
      itemBuilder: (context, index) {
        final event = sortedTimeline[index];
        final isLast = index == sortedTimeline.length - 1;
        return _buildTimelineItem(event, isLast);
      },
    );
  }

  Widget _buildTimelineItem(MatchEvent event, bool isLast) {
    IconData icon;
    Color color;
    String eventText;

    switch (event.type) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = Colors.greenAccent;
        eventText = '⚽ গোল';
        break;
      case 'card':
        icon = Icons.square;
        color = event.details == 'red_card' ? Colors.red : Colors.yellow;
        eventText = event.details == 'red_card' ? '🟥 লাল কার্ড' : '🟨 হলুদ কার্ড';
        break;
      case 'substitution':
        icon = Icons.swap_horiz;
        color = Colors.blueAccent;
        eventText = '🔄 সাবস্টিটিউশন';
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
        eventText = event.details ?? '';
    }

    bool isTeamA = event.team == 'teamA';

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

  // Stats Tab
  Widget _buildStatsTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF16213E),
            child: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(text: 'ম্যাচ পরিসংখ্যান'),
                Tab(text: 'H2H'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMatchStatsView(),
                _buildH2HView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStatsView() {
    if (widget.match.stats == null) {
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

    final stats = widget.match.stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatBar(
            'বল নিয়ন্ত্রণ',
            stats.possessionA,
            stats.possessionB,
            isPercentage: true,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'শট',
            stats.shotsA,
            stats.shotsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'টার্গেট শট',
            stats.shotsOnTargetA,
            stats.shotsOnTargetB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'কর্নার',
            stats.cornersA,
            stats.cornersB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'ফাউল',
            stats.foulsA,
            stats.foulsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'হলুদ কার্ড',
            stats.yellowCardsA,
            stats.yellowCardsB,
          ),
          const SizedBox(height: 20),
          _buildStatBar(
            'লাল কার্ড',
            stats.redCardsA,
            stats.redCardsB,
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

  Widget _buildH2HView() {
    if (widget.match.h2h == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'পূর্ববর্তী রেকর্ড নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final h2h = widget.match.h2h!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Total Matches
          _buildH2HCard(
            title: 'মোট ম্যাচ',
            value: '${h2h.totalMatches}',
            icon: Icons.sports_soccer,
          ),

          const SizedBox(height: 16),

          // Win Comparison
          Row(
            children: [
              Expanded(
                child: _buildH2HCard(
                  title: widget.match.teamA,
                  subtitle: 'জয়',
                  value: '${h2h.teamAWins}',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: 'ড্র',
                  value: '${h2h.draws}',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: widget.match.teamB,
                  subtitle: 'জয়',
                  value: '${h2h.teamBWins}',
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Goals Comparison
          Row(
            children: [
              Expanded(
                child: _buildH2HCard(
                  title: 'গোল',
                  subtitle: widget.match.teamA,
                  value: '${h2h.teamAGoals}',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildH2HCard(
                  title: 'গোল',
                  subtitle: widget.match.teamB,
                  value: '${h2h.teamBGoals}',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildH2HCard({
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? Colors.white).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? Colors.white,
              size: 24,
            ),
          if (icon != null) const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Lineup Tab
  Widget _buildLineupTab() {
    if (widget.match.lineUpA == null && widget.match.lineUpB == null) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team A Lineup (Left Side)
          Expanded(
            child: widget.match.lineUpA != null
                ? _buildTeamLineupCompact(
              widget.match.teamA,
              widget.match.lineUpA!,
              Colors.blue,
              true,
            )
                : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'লাইনআপ নেই',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Team B Lineup (Right Side)
          Expanded(
            child: widget.match.lineUpB != null
                ? _buildTeamLineupCompact(
              widget.match.teamB,
              widget.match.lineUpB!,
              Colors.orange,
              false,
            )
                : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  'লাইনআপ নেই',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLineup(String teamName, LineUp lineUp, Color color) {
    // Group players by position
    final gk = lineUp.players.where((p) => p.position == 'GK').toList();
    final def = lineUp.players.where((p) => p.position == 'DEF').toList();
    final mid = lineUp.players.where((p) => p.position == 'MID').toList();
    final fwd = lineUp.players.where((p) => p.position == 'FWD').toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shield, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                teamName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lineUp.formation,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Starting XI
          if (gk.isNotEmpty) ...[
            _buildPositionGroup('গোলরক্ষক', gk, color),
            const SizedBox(height: 12),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroup('ডিফেন্ডার', def, color),
            const SizedBox(height: 12),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroup('মিডফিল্ডার', mid, color),
            const SizedBox(height: 12),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroup('ফরোয়ার্ড', fwd, color),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Text(
              'সাবস্টিটিউট',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...subs.map((player) => _buildPlayerCard(player, color)),
          ],
        ],
      ),
    );
  }

  // Compact version for side-by-side layout
  Widget _buildTeamLineupCompact(
      String teamName, LineUp lineUp, Color color, bool isLeftSide) {
    // Group players by position (exclude substitutes from main list)
    final gk = lineUp.players
        .where((p) => p.position == 'GK' && !p.isSubstitute)
        .toList();
    final def = lineUp.players
        .where((p) => p.position == 'DEF' && !p.isSubstitute)
        .toList();
    final mid = lineUp.players
        .where((p) => p.position == 'MID' && !p.isSubstitute)
        .toList();
    final fwd = lineUp.players
        .where((p) => p.position == 'FWD' && !p.isSubstitute)
        .toList();
    final subs = lineUp.players.where((p) => p.isSubstitute).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Header - Simple text only
          Center(
            child: Column(
              children: [
                Text(
                  teamName.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Formation Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    lineUp.formation,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Starting XI
          if (gk.isNotEmpty) ...[
            _buildPositionGroupCompact('গোলরক্ষক', gk, color),
            const SizedBox(height: 10),
          ],
          if (def.isNotEmpty) ...[
            _buildPositionGroupCompact('ডিফেন্ডার', def, color),
            const SizedBox(height: 10),
          ],
          if (mid.isNotEmpty) ...[
            _buildPositionGroupCompact('মিডফিল্ডার', mid, color),
            const SizedBox(height: 10),
          ],
          if (fwd.isNotEmpty) ...[
            _buildPositionGroupCompact('ফরোয়ার্ড', fwd, color),
          ],

          // Substitutes
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'সাবস্টিটিউট',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...subs.map((player) => _buildPlayerCardCompact(player, color)),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionGroup(
      String position, List<PlayerLineUp> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...players.map((player) => _buildPlayerCard(player, color)),
      ],
    );
  }

  Widget _buildPositionGroupCompact(
      String position, List<PlayerLineUp> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          position,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ...players.map((player) => _buildPlayerCardCompact(player, color)),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerLineUp player, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: player.isCaptain ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Jersey Number
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${player.jerseyNumber}',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Player Name
          Expanded(
            child: Text(
              player.playerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Captain Badge
          if (player.isCaptain)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: const Text(
                'C',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardCompact(PlayerLineUp player, Color color) {
    // Get first letter of player name
    String firstLetter = player.playerName.isNotEmpty
        ? player.playerName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: player.isCaptain
              ? Colors.amber.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: player.isCaptain ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar with First Letter (Left)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                firstLetter,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Player Name (Middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.playerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Captain Badge below name if captain
                if (player.isCaptain)
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Captain',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Jersey Number (Right)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Text(
              '${player.jerseyNumber}',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
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

  Widget _buildResultCard() {
    String winner = widget.match.scoreA > widget.match.scoreB
        ? widget.match.teamA
        : widget.match.scoreB > widget.match.scoreA
        ? widget.match.teamB
        : 'Draw';

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

  Widget _buildTeamLogo(String logoUrl, {double size = 80}) {
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'live':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      case 'finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'live':
        return '🔴 লাইভ চলছে';
      case 'upcoming':
        return '📅 আসন্ন ম্যাচ';
      case 'finished':
        return '✅ ম্যাচ সমাপ্ত';
      default:
        return status;
    }
  }
}