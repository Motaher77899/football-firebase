// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/tournament_provider.dart';
// import '../widgets/tournament_header_widget.dart';
// import '../widgets/tournament_stats_widget.dart';
// import '../widgets/tournament_tabs_widget.dart';
//
//
// class TournamentDetailsScreen extends StatefulWidget {
//   final String tournamentId;
//
//   const TournamentDetailsScreen({
//     Key? key,
//     required this.tournamentId,
//   }) : super(key: key);
//
//   @override
//   State<TournamentDetailsScreen> createState() => _TournamentDetailsScreenState();
// }
//
// class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<TournamentProvider>().fetchTournamentById(widget.tournamentId);
//     });
//   }
//
//   @override
//   void dispose() {
//     context.read<TournamentProvider>().clearSelectedTournament();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       body: Consumer<TournamentProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF00D9FF),
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
//                     color: Colors.red,
//                     size: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32),
//                     child: Text(
//                       provider.error!,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       provider.refreshTournament(widget.tournamentId);
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('আবার চেষ্টা করুন'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF00D9FF),
//                       foregroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (provider.selectedTournament == null) {
//             return const Center(
//               child: Text(
//                 'টুর্নামেন্ট পাওয়া যায়নি',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             );
//           }
//
//           final tournament = provider.selectedTournament!;
//
//           return RefreshIndicator(
//             onRefresh: () => provider.refreshTournament(widget.tournamentId),
//             color: const Color(0xFF00D9FF),
//             backgroundColor: const Color(0xFF16213E),
//             child: CustomScrollView(
//               slivers: [
//                 // App Bar with Tournament Header
//                 SliverAppBar(
//                   expandedHeight: 280,
//                   pinned: true,
//                   backgroundColor: const Color(0xFF16213E),
//                   iconTheme: const IconThemeData(color: Colors.white),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: TournamentHeaderWidget(tournament: tournament),
//                   ),
//                 ),
//
//                 // Stats Section
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: TournamentStatsWidget(
//                       totalTeams: tournament.totalTeams,
//                       totalMatches: tournament.totalMatches,
//                       liveMatches: provider.liveMatchesCount,
//                       completedMatches: provider.completedMatchesCount,
//                     ),
//                   ),
//                 ),
//
//                 // Tournament Info
//                 SliverToBoxAdapter(
//                   child: _buildInfoSection(tournament),
//                 ),
//
//                 // Tabs Section (Matches, Teams)
//                 SliverFillRemaining(
//                   child: TournamentTabsWidget(
//                     matches: provider.tournamentMatches,
//                     teams: provider.tournamentTeams,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(tournament) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF16213E),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'টুর্নামেন্ট সম্পর্কে',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           if (tournament.description.isNotEmpty) ...[
//             _buildInfoRow(
//               Icons.description,
//               'বিবরণ',
//               tournament.description,
//             ),
//             const SizedBox(height: 12),
//           ],
//
//           _buildInfoRow(
//             Icons.location_on,
//             'স্থান',
//             tournament.location.isNotEmpty ? tournament.location : 'নির্ধারিত নয়',
//           ),
//           const SizedBox(height: 12),
//
//           _buildInfoRow(
//             Icons.person,
//             'আয়োজক',
//             tournament.organizer.isNotEmpty ? tournament.organizer : 'অজানা',
//           ),
//           const SizedBox(height: 12),
//
//           _buildInfoRow(
//             Icons.calendar_today,
//             'সময়কাল',
//             tournament.durationText,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           icon,
//           color: const Color(0xFF00D9FF),
//           size: 20,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tournament.dart';
import '../providers/tournament_provider.dart';
import '../models/tournament_model.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  Tournament? _tournament;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournamentDetails();
  }

  Future<void> _loadTournamentDetails() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<TournamentProvider>(context, listen: false);
    final tournament = await provider.getTournamentById(widget.tournamentId);

    if (mounted) {
      setState(() {
        _tournament = tournament;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF28A745),
        ),
      )
          : _tournament == null
          ? _buildErrorView()
          : _buildContent(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'টুর্নামেন্ট খুঁজে পাওয়া যায়নি',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF28A745),
              foregroundColor: Colors.white,
            ),
            child: const Text('ফিরে যান'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final tournament = _tournament!;
    final dateFormat = DateFormat('dd MMMM yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: const Color(0xFF16213E),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                tournament.imageUrl.isNotEmpty
                    ? Image.network(
                  tournament.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultHeaderImage();
                  },
                )
                    : _buildDefaultHeaderImage(),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Status Badge
                Positioned(
                  top: 60,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(tournament.status),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(tournament.status),
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tournament.statusInBengali,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tournament Name & Basic Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF16213E),
                      const Color(0xFF0F3460),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tournament Name
                    Text(
                      tournament.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Stats
                    Row(
                      children: [
                        _buildQuickStat(
                          icon: Icons.groups,
                          label: 'টিম',
                          value: '${tournament.totalTeams}',
                        ),
                        const SizedBox(width: 24),
                        _buildQuickStat(
                          icon: Icons.location_on,
                          label: 'স্থান',
                          value: tournament.location,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description Section
              _buildSection(
                title: '📋 বিবরণ',
                child: Text(
                  tournament.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),

              // Schedule Section
              _buildSection(
                title: '📅 সময়সূচী',
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.play_circle_outline,
                      label: 'শুরুর তারিখ',
                      value: dateFormat.format(tournament.startDate),
                      iconColor: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.stop_circle_outlined,
                      label: 'শেষের তারিখ',
                      value: dateFormat.format(tournament.endDate),
                      iconColor: const Color(0xFFFF5252),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.timer_outlined,
                      label: 'সময়কাল',
                      value: '${tournament.endDate.difference(tournament.startDate).inDays + 1} দিন',
                      iconColor: const Color(0xFF2196F3),
                    ),
                  ],
                ),
              ),

              // Prize Pool (if available)
              if (tournament.prizePool.isNotEmpty)
                _buildSection(
                  title: '🏆 পুরস্কার',
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFD700).withOpacity(0.2),
                          const Color(0xFFFFA000).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFD700),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 40,
                          color: Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'মোট পুরস্কার',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tournament.prizePool,
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Organizer Section
              _buildSection(
                title: '👤 আয়োজক',
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'নাম',
                      value: tournament.organizerName,
                      iconColor: const Color(0xFF2196F3),
                    ),
                    if (tournament.organizerContact.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.phone,
                        label: 'যোগাযোগ',
                        value: tournament.organizerContact,
                        iconColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ],
                ),
              ),

              // Location Section
              _buildSection(
                title: '📍 স্থান',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF28A745),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28A745).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF28A745),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          tournament.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Teams Section Placeholder
              _buildSection(
                title: '👥 অংশগ্রহণকারী টিম',
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'টিমের তালিকা শীঘ্রই যোগ করা হবে',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultHeaderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F3460),
            const Color(0xFF1A5490),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.emoji_events,
          size: 120,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF28A745),
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.white,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
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
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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