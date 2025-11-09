import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import 'my_player_profile_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _isCheckingPlayer = true;

  @override
  void initState() {
    super.initState();
    _checkPlayerProfile();
  }

  Future<void> _checkPlayerProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await playerProvider.checkPlayerProfile(authProvider.currentUser!.uid);
    }

    if (mounted) {
      setState(() => _isCheckingPlayer = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: const Text(
          '👥 কমিউনিটি',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search (Coming Soon)')),
              );
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, PlayerProvider>(
        builder: (context, authProvider, playerProvider, child) {
          return RefreshIndicator(
            onRefresh: _checkPlayerProfile,
            color: const Color(0xFF0F3460),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Player Profile Section
                if (_isCheckingPlayer)
                  _buildLoadingCard()
                else if (!playerProvider.hasPlayer)
                  _buildCreatePlayerSection(context, authProvider, playerProvider)
                else
                  _buildPlayerProfileCard(context, playerProvider),

                const SizedBox(height: 24),

                // Community Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people,
                        label: 'সদস্য',
                        value: '1.2K',
                        color: const Color(0xFF28A745),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.chat,
                        label: 'পোস্ট',
                        value: '350',
                        color: const Color(0xFF0F3460),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Create Post Button
                _buildCreatePostButton(context),
                const SizedBox(height: 24),

                // Section Title
                const Text(
                  'সাম্প্রতিক পোস্ট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Posts
                _buildPostCard(
                  userName: 'মোহাম্মদ রহিম',
                  userImage: 'M',
                  time: '২ ঘন্টা আগে',
                  content: 'আজকের ম্যাচটা দারুণ ছিল! বাংলাদেশ টিম অসাধারণ খেলেছে 🎉⚽',
                  likes: 45,
                  comments: 12,
                ),
                const SizedBox(height: 16),

                _buildPostCard(
                  userName: 'সাকিব হাসান',
                  userImage: 'S',
                  time: '৫ ঘন্টা আগে',
                  content: 'পরের ম্যাচের জন্য কে কে যাচ্ছেন? 🏟️',
                  likes: 28,
                  comments: 8,
                ),
                const SizedBox(height: 16),

                _buildPostCard(
                  userName: 'আহমেদ করিম',
                  userImage: 'A',
                  time: '১ দিন আগে',
                  content: 'নতুন টুর্নামেন্ট শুরু হয়েছে! সবাই দেখুন 🏆',
                  likes: 67,
                  comments: 23,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text(
              'প্লেয়ার প্রোফাইল চেক করা হচ্ছে...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePlayerSection(
      BuildContext context,
      AuthProvider authProvider,
      PlayerProvider playerProvider,
      ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF28A745),
            Color(0xFF20C997),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28A745).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Want to create a player account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            'প্লেয়ার অ্যাকাউন্ট তৈরি করুন এবং আপনার নিজস্ব প্লেয়ার আইডি পান',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Create Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _showCreatePlayerDialog(
                context,
                authProvider,
                playerProvider,
              ),
              icon: const Icon(Icons.add_circle_outline, size: 28),
              label: const Text(
                'প্লেয়ার প্রোফাইল তৈরি করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF28A745),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerProfileCard(
      BuildContext context,
      PlayerProvider playerProvider,
      ) {
    final player = playerProvider.myPlayer!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyPlayerProfileScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F3460),
              Color(0xFF1A5490),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xFF28A745),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚽ আমার প্লেয়ার প্রোফাইল',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${player.playerId}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('পোস্ট তৈরি করুন (Coming Soon)'),
            backgroundColor: Color(0xFF0F3460),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F3460),
              Color(0xFF1A5490),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF28A745),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'কি ভাবছেন? পোস্ট করুন...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard({
    required String userName,
    required String userImage,
    required String time,
    required String content,
    required int likes,
    required int comments,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF28A745),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userImage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white54),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.favorite_outline,
                label: '$likes',
                color: Colors.red,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: '$comments',
                color: Colors.blue,
              ),
              const Spacer(),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'শেয়ার',
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showCreatePlayerDialog(
      BuildContext context,
      AuthProvider authProvider,
      PlayerProvider playerProvider,
      ) {
    String? selectedPosition;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: const Text(
                'প্লেয়ার প্রোফাইল তৈরি করুন',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'আপনার খেলার পজিশন নির্বাচন করুন:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ...[
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('বাতিল'),
                ),
                TextButton(
                  onPressed: selectedPosition == null
                      ? null
                      : () async {
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF28A745),
                        ),
                      ),
                    );

                    bool success = await playerProvider.createPlayerProfile(
                      user: authProvider.currentUser!,
                      position: selectedPosition!,
                    );

                    if (mounted) {
                      Navigator.pop(context);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('প্লেয়ার প্রোফাইল তৈরি সফল হয়েছে!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 500));
                        if (mounted) {
                          setState(() {
                            _isCheckingPlayer = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              playerProvider.errorMessage ??
                                  'প্লেয়ার প্রোফাইল তৈরি ব্যর্থ',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'তৈরি করুন',
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