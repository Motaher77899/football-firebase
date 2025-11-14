// import 'package:flutter/material.dart';
// import 'package:football_user_app/screens/tournament_%20details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../models/tournament.dart';
// import '../providers/tournament_provider.dart';
//
// class TournamentListScreen extends StatefulWidget {
//   const TournamentListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TournamentListScreen> createState() => _TournamentListScreenState();
// }
//
// class _TournamentListScreenState extends State<TournamentListScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//
//     // Data load করা
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TournamentProvider>(context, listen: false)
//           .fetchTournaments();
//     });
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
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF16213E),
//         elevation: 0,
//         title: _isSearching
//             ? TextField(
//           controller: _searchController,
//           autofocus: true,
//           style: const TextStyle(color: Colors.white),
//           decoration: const InputDecoration(
//             hintText: 'টুর্নামেন্ট খুঁজুন...',
//             hintStyle: TextStyle(color: Colors.white54),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) => setState(() {}),
//         )
//             : const Text(
//           '🏆 টুর্নামেন্ট',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//                 if (!_isSearching) {
//                   _searchController.clear();
//                 }
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               Provider.of<TournamentProvider>(context, listen: false)
//                   .fetchTournaments();
//             },
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: const Color(0xFF28A745),
//           indicatorWeight: 3,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white60,
//           tabs: const [
//             Tab(text: '🔵 আসন্ন'),
//             Tab(text: '🟢 চলমান'),
//             Tab(text: '⚪ সমাপ্ত'),
//           ],
//         ),
//       ),
//       body: Consumer<TournamentProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF28A745),
//               ),
//             );
//           }
//
//           if (provider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.error_outline,
//                     size: 64,
//                     color: Colors.red,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     provider.error!,
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: () => provider.fetchTournaments(),
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('আবার চেষ্টা করুন'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF28A745),
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Search functionality
//           final tournaments = _searchController.text.isEmpty
//               ? provider.tournaments
//               : provider.searchTournaments(_searchController.text);
//
//           if (tournaments.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     _isSearching ? Icons.search_off : Icons.emoji_events_outlined,
//                     size: 80,
//                     color: Colors.white24,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _isSearching
//                         ? 'কোন টুর্নামেন্ট পাওয়া যায়নি'
//                         : 'এখনও কোন টুর্নামেন্ট নেই',
//                     style: const TextStyle(
//                       color: Colors.white54,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return TabBarView(
//             controller: _tabController,
//             children: [
//               _buildTournamentList(
//                 tournaments.where((t) => t.status == 'upcoming').toList(),
//               ),
//               _buildTournamentList(
//                 tournaments.where((t) => t.status == 'ongoing').toList(),
//               ),
//               _buildTournamentList(
//                 tournaments.where((t) => t.status == 'completed').toList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTournamentList(List<Tournament> tournaments) {
//     if (tournaments.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inbox_outlined,
//               size: 80,
//               color: Colors.white24,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'এই ক্যাটাগরিতে কোন টুর্নামেন্ট নেই',
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
//     return RefreshIndicator(
//       color: const Color(0xFF28A745),
//       onRefresh: () async {
//         await Provider.of<TournamentProvider>(context, listen: false)
//             .fetchTournaments();
//       },
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: tournaments.length,
//         itemBuilder: (context, index) {
//           return _buildTournamentCard(tournaments[index]);
//         },
//       ),
//     );
//   }
//
//   Widget _buildTournamentCard(Tournament tournament) {
//     final dateFormat = DateFormat('dd MMM yyyy');
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TournamentDetailsScreen(
//               tournamentId: tournament.id,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFF16213E),
//               const Color(0xFF0F3460),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Section
//             if (tournament.imageUrl.isNotEmpty)
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 child: Image.network(
//                   tournament.imageUrl,
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return _buildDefaultImage();
//                   },
//                 ),
//               )
//             else
//               _buildDefaultImage(),
//
//             // Content Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Status Badge
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(tournament.status),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               _getStatusIcon(tournament.status),
//                               size: 16,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               tournament.statusInBengali,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       // Teams count
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.groups,
//                               size: 16,
//                               color: Colors.white70,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               '${tournament.totalTeams} টিম',
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // Tournament Name
//                   Text(
//                     tournament.name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Location
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: Color(0xFF28A745),
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           tournament.location,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 14,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Date Range
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: Color(0xFF28A745),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${dateFormat.format(tournament.startDate)} - ${dateFormat.format(tournament.endDate)}',
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Prize Pool (if available)
//                   if (tournament.prizePool.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.emoji_events,
//                           size: 16,
//                           color: Color(0xFFFFD700),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'পুরস্কার: ${tournament.prizePool}',
//                           style: const TextStyle(
//                             color: Color(0xFFFFD700),
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//
//                   const SizedBox(height: 12),
//
//                   // Organizer
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.person_outline,
//                         size: 16,
//                         color: Colors.white54,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'আয়োজক: ${tournament.organizerName}',
//                         style: const TextStyle(
//                           color: Colors.white54,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDefaultImage() {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFF0F3460),
//             const Color(0xFF1A5490),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Center(
//         child: Icon(
//           Icons.emoji_events,
//           size: 80,
//           color: Colors.white.withOpacity(0.3),
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'upcoming':
//         return const Color(0xFF2196F3);
//       case 'ongoing':
//         return const Color(0xFF4CAF50);
//       case 'completed':
//         return const Color(0xFF757575);
//       default:
//         return const Color(0xFF757575);
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'upcoming':
//         return Icons.schedule;
//       case 'ongoing':
//         return Icons.play_circle_filled;
//       case 'completed':
//         return Icons.check_circle;
//       default:
//         return Icons.circle;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:football_user_app/screens/tournament_%20details_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tournament.dart';
import '../providers/tournament_provider.dart';


class TournamentListScreen extends StatefulWidget {
  const TournamentListScreen({Key? key}) : super(key: key);

  @override
  State<TournamentListScreen> createState() => _TournamentListScreenState();
}

class _TournamentListScreenState extends State<TournamentListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Data load করা
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TournamentProvider>(context, listen: false)
          .fetchTournaments();
    });
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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'টুর্নামেন্ট খুঁজুন...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() {}),
        )
            : const Text(
          '🏆 টুর্নামেন্ট',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TournamentProvider>(context, listen: false)
                  .fetchTournaments();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF28A745),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: '🔵 আসন্ন'),
            Tab(text: '🟢 চলমান'),
            Tab(text: '⚪ সমাপ্ত'),
          ],
        ),
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF28A745),
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.fetchTournaments(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('আবার চেষ্টা করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          // Search functionality
          final tournaments = _searchController.text.isEmpty
              ? provider.tournaments
              : provider.searchTournaments(_searchController.text);

          if (tournaments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSearching ? Icons.search_off : Icons.emoji_events_outlined,
                    size: 80,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isSearching
                        ? 'কোন টুর্নামেন্ট পাওয়া যায়নি'
                        : 'এখনও কোন টুর্নামেন্ট নেই',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTournamentList(
                tournaments.where((t) => t.status == 'upcoming').toList(),
              ),
              _buildTournamentList(
                tournaments.where((t) => t.status == 'ongoing').toList(),
              ),
              _buildTournamentList(
                tournaments.where((t) => t.status == 'completed').toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTournamentList(List<Tournament> tournaments) {
    if (tournaments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            const Text(
              'এই ক্যাটাগরিতে কোন টুর্নামেন্ট নেই',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF28A745),
      onRefresh: () async {
        await Provider.of<TournamentProvider>(context, listen: false)
            .fetchTournaments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          return _buildTournamentCard(tournaments[index]);
        },
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentDetailsScreen(
              tournamentId: tournament.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (tournament.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  tournament.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultImage();
                  },
                ),
              )
            else
              _buildDefaultImage(),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(tournament.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(tournament.status),
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tournament.statusInBengali,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Teams count
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.groups,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tournament.totalTeams} টিম',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Tournament Name
                  Text(
                    tournament.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF28A745),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tournament.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Date Range
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFF28A745),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dateFormat.format(tournament.startDate)} - ${dateFormat.format(tournament.endDate)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Prize Pool (if available)
                  if (tournament.prizePool.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'পুরস্কার: ${tournament.prizePool}',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Organizer
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'আয়োজক: ${tournament.organizerName}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F3460),
            const Color(0xFF1A5490),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.emoji_events,
          size: 80,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color(0xFF2196F3);
      case 'ongoing':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF757575);
      default:
        return const Color(0xFF757575);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.schedule;
      case 'ongoing':
        return Icons.play_circle_filled;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }
}