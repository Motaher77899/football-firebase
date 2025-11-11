import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tournament_provider.dart';
import '../widgets/tournament_header_widget.dart';
import '../widgets/tournament_stats_widget.dart';
import '../widgets/tournament_tabs_widget.dart';


class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  State<TournamentDetailsScreen> createState() => _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TournamentProvider>().fetchTournamentById(widget.tournamentId);
    });
  }

  @override
  void dispose() {
    context.read<TournamentProvider>().clearSelectedTournament();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Consumer<TournamentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D9FF),
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
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.refreshTournament(widget.tournamentId);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('আবার চেষ্টা করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D9FF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.selectedTournament == null) {
            return const Center(
              child: Text(
                'টুর্নামেন্ট পাওয়া যায়নি',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          final tournament = provider.selectedTournament!;

          return RefreshIndicator(
            onRefresh: () => provider.refreshTournament(widget.tournamentId),
            color: const Color(0xFF00D9FF),
            backgroundColor: const Color(0xFF16213E),
            child: CustomScrollView(
              slivers: [
                // App Bar with Tournament Header
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: const Color(0xFF16213E),
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: FlexibleSpaceBar(
                    background: TournamentHeaderWidget(tournament: tournament),
                  ),
                ),

                // Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TournamentStatsWidget(
                      totalTeams: tournament.totalTeams,
                      totalMatches: tournament.totalMatches,
                      liveMatches: provider.liveMatchesCount,
                      completedMatches: provider.completedMatchesCount,
                    ),
                  ),
                ),

                // Tournament Info
                SliverToBoxAdapter(
                  child: _buildInfoSection(tournament),
                ),

                // Tabs Section (Matches, Teams)
                SliverFillRemaining(
                  child: TournamentTabsWidget(
                    matches: provider.tournamentMatches,
                    teams: provider.tournamentTeams,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(tournament) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'টুর্নামেন্ট সম্পর্কে',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (tournament.description.isNotEmpty) ...[
            _buildInfoRow(
              Icons.description,
              'বিবরণ',
              tournament.description,
            ),
            const SizedBox(height: 12),
          ],

          _buildInfoRow(
            Icons.location_on,
            'স্থান',
            tournament.location.isNotEmpty ? tournament.location : 'নির্ধারিত নয়',
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            Icons.person,
            'আয়োজক',
            tournament.organizer.isNotEmpty ? tournament.organizer : 'অজানা',
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            Icons.calendar_today,
            'সময়কাল',
            tournament.durationText,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF00D9FF),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
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
}