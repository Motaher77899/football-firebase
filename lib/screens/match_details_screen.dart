// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/match_model.dart';
// import '../models/team_model.dart';
// import '../providers/team_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class MatchDetailsScreen extends StatelessWidget {
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
//   Widget build(BuildContext context) {
//     TeamModel? teamA = teamProvider.getTeamByName(match.teamA);
//     TeamModel? teamB = teamProvider.getTeamByName(match.teamB);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16213E),
//         elevation: 0,
//         title: const Text(
//           'ম্যাচ বিস্তারিত',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Match Status Banner
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(match.status),
//               ),
//               child: Text(
//                 _getStatusText(match.status),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Teams and Score
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Team A
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildTeamLogo(teamA?.logoUrl),
//                         const SizedBox(height: 12),
//                         Text(
//                           match.teamA,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         if (teamA != null) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             teamA.upazila,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//
//                   // Score
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF16213E),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               '${match.scoreA}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 40,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 15),
//                               child: Text(
//                                 '-',
//                                 style: TextStyle(
//                                   color: Colors.white54,
//                                   fontSize: 30,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${match.scoreB}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 40,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (match.status == 'live')
//                           Container(
//                             margin: const EdgeInsets.only(top: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Text(
//                               'LIVE',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//
//                   // Team B
//                   Expanded(
//                     child: Column(
//                       children: [
//                         _buildTeamLogo(teamB?.logoUrl),
//                         const SizedBox(height: 12),
//                         Text(
//                           match.teamB,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         if (teamB != null) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             teamB.upazila,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Match Info
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF16213E),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 children: [
//                   _buildInfoRow(
//                     '📅 Date',
//                     DateFormat('dd MMMM yyyy').format(match.matchTime),
//                   ),
//                   const Divider(color: Colors.white24, height: 24),
//                   _buildInfoRow(
//                     '⏰ Time',
//                     DateFormat('hh:mm a').format(match.matchTime),
//                   ),
//                   if (teamA != null) ...[
//                     const Divider(color: Colors.white24, height: 24),
//                     _buildInfoRow(
//                       '👥 ${match.teamA} Players',
//                       '${teamA.playersCount}',
//                     ),
//                   ],
//                   if (teamB != null) ...[
//                     const Divider(color: Colors.white24, height: 24),
//                     _buildInfoRow(
//                       '👥 ${match.teamB} Players',
//                       '${teamB.playersCount}',
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTeamLogo(String? logoUrl) {
//     if (logoUrl == null || logoUrl.isEmpty) {
//       return Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F3460),
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.shield,
//           color: Colors.white,
//           size: 40,
//         ),
//       );
//     }
//
//     return CachedNetworkImage(
//       imageUrl: logoUrl,
//       imageBuilder: (context, imageProvider) => Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             image: imageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       placeholder: (context, url) => Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F3460),
//           shape: BoxShape.circle,
//         ),
//         child: const CircularProgressIndicator(
//           color: Colors.white,
//         ),
//       ),
//       errorWidget: (context, url, error) => Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: const Color(0xFF0F3460),
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.shield,
//           color: Colors.white,
//           size: 40,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white70,
//             fontSize: 16,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
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
//         return '🔴Live Match';
//       case 'upcoming':
//         return '📅 Upcoming Match';
//       case 'finished':
//         return '✅ Finished Match';
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

class MatchDetailsScreen extends StatelessWidget {
  final MatchModel match;
  final TeamProvider teamProvider;

  const MatchDetailsScreen({
    Key? key,
    required this.match,
    required this.teamProvider,
  }) : super(key: key);

  // Get default flag URL based on team name
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
    TeamModel? team = teamProvider.getTeamByName(teamName);
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
    String teamALogoUrl = _getTeamLogoUrl(match.teamA);
    String teamBLogoUrl = _getTeamLogoUrl(match.teamB);
    TeamModel? teamA = teamProvider.getTeamByName(match.teamA);
    TeamModel? teamB = teamProvider.getTeamByName(match.teamB);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF16213E),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF16213E),
                      const Color(0xFF0F3460),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
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
                            color: _getStatusColor(match.status).withOpacity(0.5),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tournament & Venue
                    if (match.tournament != null) ...[
                      Text(
                        match.tournament!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (match.venue != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white60,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            match.venue!,
                            style: const TextStyle(
                              color: Colors.white60,
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

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Score Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF16213E),
                        const Color(0xFF0F3460),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Team A
                      Expanded(
                        child: Column(
                          children: [
                            _buildTeamLogo(teamALogoUrl, size: 90),
                            const SizedBox(height: 16),
                            Text(
                              match.teamA.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            if (teamA != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                teamA.upazila,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${match.scoreA}',
                                  style: TextStyle(
                                    color: match.scoreA > match.scoreB
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 36,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${match.scoreB}',
                                  style: TextStyle(
                                    color: match.scoreB > match.scoreA
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (match.status == 'live') ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Team B
                      Expanded(
                        child: Column(
                          children: [
                            _buildTeamLogo(teamBLogoUrl, size: 90),
                            const SizedBox(height: 16),
                            Text(
                              match.teamB.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            if (teamB != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                teamB.upazila,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Match Information Card
                _buildInfoCard(
                  context,
                  title: 'ম্যাচ তথ্য',
                  icon: Icons.info_outline,
                  children: [
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'তারিখ',
                      value: DateFormat('EEEE, dd MMMM yyyy').format(match.date),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: 'সময়',
                      value: DateFormat('hh:mm a').format(match.time),
                    ),
                    if (match.tournament != null) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.emoji_events,
                        label: 'টুর্নামেন্ট',
                        value: match.tournament!,
                      ),
                    ],
                    if (match.venue != null) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.stadium,
                        label: 'স্টেডিয়াম',
                        value: match.venue!,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 20),

                // Teams Stats Card
                if (teamA != null || teamB != null)
                  _buildInfoCard(
                    context,
                    title: 'টিম পরিসংখ্যান',
                    icon: Icons.group,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatBox(
                              team: match.teamA,
                              label: 'খেলোয়াড়',
                              value: teamA?.playersCount.toString() ?? '-',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatBox(
                              team: match.teamB,
                              label: 'খেলোয়াড়',
                              value: teamB?.playersCount.toString() ?? '-',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Match Result Card (for finished matches)
                if (match.status == 'finished')
                  _buildResultCard(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> children,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
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
        Icon(
          icon,
          color: Colors.white54,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
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

  Widget _buildStatBox({
    required String team,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            team,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    String winner = match.scoreA > match.scoreB
        ? match.teamA
        : match.scoreB > match.scoreA
        ? match.teamB
        : 'Draw';

    if (winner == 'Draw') {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C757D), Color(0xFF495057)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            const Text(
              'Match Drawn',
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                'Winner',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
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
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 3,
          ),
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
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 3,
        ),
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