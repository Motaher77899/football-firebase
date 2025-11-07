import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/player_provider.dart';

class MyPlayerProfileScreen extends StatefulWidget {
  const MyPlayerProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyPlayerProfileScreen> createState() => _MyPlayerProfileScreenState();
}

class _MyPlayerProfileScreenState extends State<MyPlayerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Consumer<PlayerProvider>(
        builder: (context, playerProvider, child) {
          final player = playerProvider.myPlayer;

          if (player == null) {
            return const Center(
              child: Text(
                'প্লেয়ার প্রোফাইল লোড হচ্ছে...',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditPositionDialog(context, playerProvider);
                    },
                    tooltip: 'পজিশন পরিবর্তন',
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
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
                        // Player Badge
                        Container(
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
                        ),
                        const SizedBox(height: 10),
                        // Player Name
                        Text(
                          player.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF28A745),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: const [
                    Tab(text: 'তথ্য'),
                    Tab(text: 'আমার ম্যাচ'),
                  ],
                ),
              ),

              // Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(player),
                    _buildMatchesTab(playerProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTab(player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Player Info Card
          _buildInfoCard(
            title: 'প্লেয়ার তথ্য',
            icon: Icons.sports_soccer,
            children: [
              _buildInfoRow(
                icon: Icons.person,
                label: 'নাম',
                value: player.name,
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildInfoRow(
                icon: Icons.badge,
                label: 'প্লেয়ার আইডি',
                value: player.playerId,
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildInfoRow(
                icon: Icons.sports,
                label: 'পজিশন',
                value: player.position,
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildInfoRow(
                icon: Icons.cake,
                label: 'জন্ম তারিখ',
                value: DateFormat('dd MMMM yyyy').format(player.dateOfBirth),
              ),
              if (player.teamName != null) ...[
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(
                  icon: Icons.shield,
                  label: 'টিম',
                  value: player.teamName!,
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Location Card
          _buildInfoCard(
            title: 'ঠিকানা',
            icon: Icons.location_on,
            children: [
              _buildInfoRow(
                icon: Icons.location_city,
                label: 'বিভাগ',
                value: player.division,
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildInfoRow(
                icon: Icons.map,
                label: 'জেলা',
                value: player.district,
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildInfoRow(
                icon: Icons.place,
                label: 'উপজেলা',
                value: player.upazila,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Account Info
          _buildInfoCard(
            title: 'অ্যাকাউন্ট',
            icon: Icons.info,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'তৈরির তারিখ',
                value: DateFormat('dd MMMM yyyy').format(player.createdAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(PlayerProvider playerProvider) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: playerProvider.getPlayerMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_soccer,
                  color: Colors.white30,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'আপনার এলাকার কোন ম্যাচ খেলা হয়নি',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final matches = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return _buildMatchCard(match);
          },
        );
      },
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    final teamA = match['teamA'] ?? '';
    final teamB = match['teamB'] ?? '';
    final scoreA = match['scoreA'] ?? 0;
    final scoreB = match['scoreB'] ?? 0;
    final date = (match['date'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date
          Text(
            DateFormat('dd MMM yyyy').format(date),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          // Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  teamA,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '$scoreA',
                      style: const TextStyle(
                        color: Colors.white,
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
                      '$scoreB',
                      style: const TextStyle(
                        color: Colors.white,
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
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16213E),
            Color(0xFF0F3460),
          ],
        ),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
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
        Icon(icon, color: Colors.white54, size: 20),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditPositionDialog(
      BuildContext context, PlayerProvider playerProvider) {
    String? selectedPosition = playerProvider.myPlayer?.position;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: const Text(
                'পজিশন পরিবর্তন করুন',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  'ফরওয়ার্ড',
                  'মিডফিল্ডার',
                  'ডিফেন্ডার',
                  'গোলকিপার',
                ].map((position) {
                  return RadioListTile<String>(
                    title: Text(
                      position,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: position,
                    groupValue: selectedPosition,
                    activeColor: const Color(0xFF28A745),
                    onChanged: (value) {
                      setState(() {
                        selectedPosition = value;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('বাতিল'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedPosition != null) {
                      bool success = await playerProvider
                          .updatePlayerPosition(selectedPosition!);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'পজিশন আপডেট সফল হয়েছে'
                                  : 'আপডেট ব্যর্থ হয়েছে',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'সংরক্ষণ',
                    style: TextStyle(color: Color(0xFF28A745)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
