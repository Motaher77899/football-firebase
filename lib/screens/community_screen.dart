

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
    setState(() => _isCheckingPlayer = true);

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
                const SnackBar(
                  content: Text('খুঁজুন (শীঘ্রই আসছে)'),
                  backgroundColor: Color(0xFF28A745),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, PlayerProvider>(
        builder: (context, authProvider, playerProvider, child) {
          return RefreshIndicator(
            onRefresh: _checkPlayerProfile,
            color: const Color(0xFF28A745),
            backgroundColor: const Color(0xFF16213E),
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
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

                const SizedBox(height: 80), // Bottom padding
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
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Color(0xFF28A745),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'প্লেয়ার প্রোফাইল চেক করা হচ্ছে...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'প্লেয়ার অ্যাকাউন্ট তৈরি করুন',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'প্লেয়ার প্রোফাইল তৈরি করুন এবং আপনার নিজস্ব প্লেয়ার আইডি পান',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              // সংশোধিত কল: now it's async
              onPressed: () async => await _showCreatePlayerDialog(
                context,
                authProvider,
                playerProvider,
              ),
              icon: const Icon(Icons.add_circle_outline, size: 24),
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
              decoration: BoxDecoration(
                color: const Color(0xFF28A745),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF28A745).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                  const SizedBox(height: 6),
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${player.playerId}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
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
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
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
            content: Text('পোস্ট তৈরি করুন (শীঘ্রই আসছে)'),
            backgroundColor: Color(0xFF28A745),
          ),
        );
      },
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF28A745),
                    Color(0xFF20C997),
                  ],
                ),
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
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF28A745),
                      Color(0xFF20C997),
                    ],
                  ),
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
                    const SizedBox(height: 2),
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
              height: 1.5,
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

  // **** সংশোধিত ফাংশন: লোডিং ঠিক করার জন্য পরিবর্তন করা হয়েছে ****
  Future<void> _showCreatePlayerDialog(
      BuildContext context,
      AuthProvider authProvider,
      PlayerProvider playerProvider,
      ) async {
    String? selectedPosition;

    // Step 1: পজিশন নির্বাচনের ডায়ালগটি দেখান এবং ফলাফল অপেক্ষা করুন
    final bool? shouldCreate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.sports_soccer, color: Color(0xFF28A745)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'প্লেয়ার প্রোফাইল তৈরি করুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'আপনার খেলার পজিশন নির্বাচন করুন:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
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
                          setDialogState(() {
                            selectedPosition = value;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false), // বাতিল করলে false রিটার্ন হবে
                  child: const Text(
                    'বাতিল',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedPosition == null
                      ? null
                      : () {
                    // পজিশন নির্বাচন হলে, প্রথম ডায়ালগ বন্ধ করে true রিটার্ন করুন
                    Navigator.pop(dialogContext, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('তৈরি করুন'),
                ),
              ],
            );
          },
        );
      },
    );

    // Step 2: যদি ইউজার 'তৈরি করুন' (true) নির্বাচন করে তবেই লোডিং দেখান এবং প্লেয়ার তৈরি করুন
    if (shouldCreate == true && selectedPosition != null) {

      // লোডিং ডায়ালগ দেখান (এটি মেইন কনটেক্সটে, তাই এটি ব্লক করবে)
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF28A745),
            ),
          ),
        );
      }

      // প্লেয়ার তৈরির প্রক্রিয়া
      bool success = false;
      if (authProvider.currentUser != null) {
        success = await playerProvider.createPlayerProfile(
          user: authProvider.currentUser!,
          position: selectedPosition!,
        );
      }

      // লোডিং ডায়ালগ বন্ধ করুন
      if (context.mounted) {
        Navigator.pop(context);
      }

      // সফল হলে মূল স্ক্রিনটি রিফ্রেশ করুন (এটিই অনুপস্থিত ছিল)
      if (success && mounted) {
        await _checkPlayerProfile(); // এই ফাংশনটি _isCheckingPlayer কে false সেট করে দেবে
      }

      // মেসেজ দেখান
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'প্লেয়ার প্রোফাইল তৈরি সফল হয়েছে!'
                  : playerProvider.errorMessage ?? 'প্রোফাইল তৈরি ব্যর্থ',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}