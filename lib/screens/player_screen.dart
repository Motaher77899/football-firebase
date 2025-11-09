import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/player_model.dart';
import '../providers/auth_provider.dart';
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
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          // Header AppBar
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF16213E),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // ✅ Favorite Button - Fixed
              Consumer<PlayerProvider>(
                builder: (context, playerProvider, child) {
                  // ✅ Use new isFavoritePlayer method
                  final isFavorite =
                  playerProvider.isFavoritePlayer(player.id);

                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 28,
                    ),
                    onPressed: () async {
                      final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);

                      // ✅ Check login
                      if (authProvider.currentUser == null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('প্রথমে লগইন করুন'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        return;
                      }

                      try {
                        if (isFavorite) {
                          // ✅ Remove from favorites
                          final success = await playerProvider
                              .removePlayerFromFavorites(
                            authProvider.currentUser!.uid,
                            player.id,
                          );

                          if (mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '❌ প্রিয় থেকে সরানো হয়েছে'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          // ✅ Add to favorites
                          final success = await playerProvider
                              .addPlayerToFavorites(
                            authProvider.currentUser!.uid,
                            player.id,
                          );

                          if (mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❤️ প্রিয়তে যোগ করা হয়েছে'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        debugPrint('❌ Error: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('সমস্যা: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'প্রিয় তে যোগ করুন',
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(player),
            ),
          ),

          // TabBar
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: const Color(0xFF16213E),
            automaticallyImplyLeading: false,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF28A745),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(icon: Icon(Icons.info_outline), text: "তথ্য"),
                Tab(icon: Icon(Icons.bar_chart_outlined), text: "পরিসংখ্যান"),
                Tab(icon: Icon(Icons.sports_soccer_outlined), text: "ম্যাচ"),
              ],
            ),
          ),

          // Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(player),
                _buildStatsTab(player),
                _buildMatchesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Header Widget
  Widget _buildHeader(PlayerModel player) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F3460), Color(0xFF1A5490)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Player Avatar
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF28A745), Color(0xFF20C997)],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Player Name
          Text(
            player.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // ✅ Position Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF28A745),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              player.position,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Player ID and Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.badge, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                player.playerId,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                player.upazila,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Info Tab
  Widget _buildInfoTab(PlayerModel player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ✅ Personal Information Card
          _buildCard(
            title: '👤 ব্যক্তিগত তথ্য',
            children: [
              _buildRow('নাম', player.name, Icons.person),
              const SizedBox(height: 12),
              _buildRow(
                'জন্মতারিখ',
                DateFormat('dd MMMM yyyy').format(player.dateOfBirth),
                Icons.cake,
              ),
              const SizedBox(height: 12),
              _buildRow('পজিশন', player.position, Icons.sports_soccer),
              const SizedBox(height: 12),
              _buildRow('প্লেয়ার আইডি', player.playerId, Icons.badge),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Location Card
          _buildCard(
            title: '📍 অবস্থান',
            children: [
              _buildRow('বিভাগ', player.division, Icons.location_city),
              const SizedBox(height: 12),
              _buildRow('জেলা', player.district, Icons.map),
              const SizedBox(height: 12),
              _buildRow('উপজেলা', player.upazila, Icons.place),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Contact Info (if available)
          _buildCard(
            title: '📞 যোগাযোগ',
            children: [
              _buildRow('ইউজার আইডি', player.userId, Icons.verified_user),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Stats Tab
  Widget _buildStatsTab(PlayerModel player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ✅ Personal Stats
          _buildCard(
            title: '📊 ব্যক্তিগত পরিসংখ্যান',
            children: [
              _buildStatItem('পজিশন', player.position),
              const SizedBox(height: 12),
              _buildStatItem(
                'বয়স',
                '${DateTime.now().year - player.dateOfBirth.year} বছর',
              ),
              const SizedBox(height: 12),
              _buildStatItem('প্লেয়ার আইডি', player.playerId),
              const SizedBox(height: 12),
              _buildStatItem('বিভাগ', player.division),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Performance Stats
          _buildCard(
            title: '⚽ পারফরম্যান্স',
            children: [
              _buildStatItem('মোট ম্যাচ', '24'),
              const SizedBox(height: 12),
              _buildStatItem('মোট গোল', '12'),
              const SizedBox(height: 12),
              _buildStatItem('সহায়তা', '7'),
              const SizedBox(height: 12),
              _buildStatItem('ম্যান অফ দ্য ম্যাচ', '5'),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Skill Levels
          _buildCard(
            title: '🎯 দক্ষতা স্তর',
            children: [
              _buildProgressBar('আক্রমণ', 0.78),
              const SizedBox(height: 16),
              _buildProgressBar('প্রতিরক্ষা', 0.65),
              const SizedBox(height: 16),
              _buildProgressBar('প্যাসিং', 0.82),
              const SizedBox(height: 16),
              _buildProgressBar('সহনশীলতা', 0.90),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Matches Tab
  Widget _buildMatchesTab() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: playerProvider.getPlayerMatches(),
      builder: (context, snapshot) {
        // ✅ Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF28A745)),
          );
        }

        // ✅ Error State
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'ত্রুটি: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final matches = snapshot.data ?? [];

        // ✅ Empty State
        if (matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.sports_soccer, color: Colors.white30, size: 80),
                SizedBox(height: 16),
                Text(
                  'কোনো ম্যাচ পাওয়া যায়নি',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // ✅ Matches List
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            final teamA = match['teamA'] ?? 'দল A';
            final teamB = match['teamB'] ?? 'দল B';
            final scoreA = match['scoreA']?.toString() ?? '?';
            final scoreB = match['scoreB']?.toString() ?? '?';
            final date = match['date'] != null
                ? DateFormat('dd MMM yyyy').format(
                (match['date'] as dynamic).toDate?.call() ?? DateTime.now())
                : 'N/A';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16213E), Color(0xFF0F3460)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✅ Match Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ম্যাচ ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ✅ Match Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          teamA,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              scoreA,
                              style: TextStyle(
                                // ✅ FIXED: Proper comparison
                                color: (int.tryParse(scoreA) ?? 0) >
                                    (int.tryParse(scoreB) ?? 0)
                                    ? Colors.greenAccent
                                    : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              scoreB,
                              style: TextStyle(
                                // ✅ FIXED: Proper comparison
                                color: (int.tryParse(scoreB) ?? 0) >
                                    (int.tryParse(scoreA) ?? 0)
                                    ? Colors.greenAccent
                                    : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          teamB,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Helper: Card Widget
  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0F3460)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // ✅ Helper: Row Widget
  Widget _buildRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF28A745), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ Helper: Stat Item Widget
  Widget _buildStatItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF28A745),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ✅ Helper: Progress Bar Widget
  Widget _buildProgressBar(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: const TextStyle(
                color: Color(0xFF28A745),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF28A745),
            ),
          ),
        ),
      ],
    );
  }
}