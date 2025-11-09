import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import '../models/player_model.dart';
import 'player_screen.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({Key? key}) : super(key: key);

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'সকল'; // সকল, উপজেলা অনুযায়ী

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);
    final userUpazila = authProvider.currentUser?.upazila ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          '⚽ সকল খেলোয়াড়',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // সার্চ বার এবং ফিল্টার
          Container(
            color: const Color(0xFF16213E),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // সার্চ বার
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'খেলোয়াড়ের নাম বা পজিশন...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white54),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF0F3460),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                // ফিল্টার বাটন
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'সকল';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedFilter == 'সকল'
                                ? const Color(0xFF28A745)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedFilter == 'সকল'
                                  ? const Color(0xFF28A745)
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            'সকল (সব)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedFilter == 'সকল'
                                  ? Colors.white
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'উপজেলা';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedFilter == 'উপজেলা'
                                ? const Color(0xFF28A745)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedFilter == 'উপজেলা'
                                  ? const Color(0xFF28A745)
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            'আমার উপজেলা',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _selectedFilter == 'উপজেলা'
                                  ? Colors.white
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // খেলোয়াড়দের লিস্ট
          Expanded(
            child: StreamBuilder<List<PlayerModel>>(
              stream: _selectedFilter == 'উপজেলা'
                  ? playerProvider.getPlayersByUpazila(userUpazila)
                  : playerProvider.getAllPlayers(),
              builder: (context, snapshot) {
                // লোডিং স্টেট
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF28A745),
                    ),
                  );
                }

                // এরর স্টেট
                if (snapshot.hasError) {
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
                        Text(
                          'ত্রুটি: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // ডেটা নেই
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
                        Text(
                          _selectedFilter == 'উপজেলা'
                              ? '$userUpazila এ কোন খেলোয়াড় নেই'
                              : 'কোন খেলোয়াড় পাওয়া যায়নি',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'নতুন খেলোয়াড়দের জন্য অপেক্ষা করুন...',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // খেলোয়াড়দের লিস্ট
                List<PlayerModel> players = snapshot.data!;

                // সার্চ ফিল্টার করুন
                if (_searchController.text.isNotEmpty) {
                  final query = _searchController.text.toLowerCase();
                  players = players.where((player) {
                    return player.name.toLowerCase().contains(query) ||
                        player.position.toLowerCase().contains(query) ||
                        player.upazila.toLowerCase().contains(query);
                  }).toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return _buildPlayerCard(
                      context,
                      players[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, PlayerModel player) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(player: player),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // খেলোয়াড়ের অ্যাভাটার
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF28A745),
                      Color(0xFF20C997),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: player.imageUrl.isEmpty
                      ? Text(
                    player.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : ClipOval(
                    child: Image.network(
                      player.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          player.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // খেলোয়াড়ের তথ্য
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // নাম
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // পজিশন
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3460),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        player.position,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // প্লেয়ার আইডি এবং উপজেলা
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          player.playerId,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            player.upazila,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // তীর আইকন
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}