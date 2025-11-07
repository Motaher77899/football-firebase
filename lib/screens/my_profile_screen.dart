import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import 'edit_profile_screen.dart';
import 'my_player_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isCheckingPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
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
      body: Consumer2<AuthProvider, PlayerProvider>(
        builder: (context, authProvider, playerProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text(
                'প্রোফাইল লোড হচ্ছে...',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              /// ✅ TOP PROFILE AREA
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: const Color(0xFF16213E),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _showLogoutDialog(context, authProvider),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F3460), Color(0xFF16213E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF1A5490),
                            child: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : "U",
                              style: const TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              /// ✅ CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// ✅ Player Profile Section
                      _isCheckingPlayer
                          ? _buildLoadingCard()
                          : playerProvider.hasPlayer
                          ? _buildPlayerProfileButton(context)
                          : _buildCreatePlayerButton(
                          context, authProvider, playerProvider),

                      const SizedBox(height: 20),

                      /// ✅ PERSONAL INFO CARD
                      _buildInfoCard(
                        title: "ব্যক্তিগত তথ্য",
                        icon: Icons.person,
                        children: [
                          _buildInfoRow("পূর্ণ নাম", user.fullName,
                              Icons.person_outline),
                          _divider(),
                          _buildInfoRow("ইমেইল", user.email,
                              Icons.email_outlined),
                          _divider(),
                          _buildInfoRow("লিঙ্গ", user.gender, Icons.wc),
                          _divider(),
                          _buildInfoRow(
                              "জন্ম তারিখ",
                              DateFormat('dd MMMM yyyy')
                                  .format(user.dateOfBirth),
                              Icons.cake),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// ✅ ADDRESS
                      _buildInfoCard(
                        title: "ঠিকানা",
                        icon: Icons.location_on,
                        children: [
                          _buildInfoRow(
                              "বিভাগ", user.division, Icons.location_city),
                          _divider(),
                          _buildInfoRow("জেলা", user.district, Icons.map),
                          _divider(),
                          _buildInfoRow("উপজেলা", user.upazila, Icons.place),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// ✅ ACCOUNT
                      _buildInfoCard(
                        title: "অ্যাকাউন্ট তথ্য",
                        icon: Icons.info_outline,
                        children: [
                          _buildInfoRow(
                            "যোগদানের তারিখ",
                            DateFormat('dd MMMM yyyy').format(user.createdAt),
                            Icons.calendar_today,
                          ),
                          _divider(),
                          _buildInfoRow(
                            "ইউজার আইডি",
                            "${user.uid.substring(0, 12)}...",
                            Icons.fingerprint,
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // ✅ UI COMPONENTS
  // -------------------------------------------------------------

  Widget _divider() =>
      const Divider(color: Colors.white24, height: 22, thickness: 1);

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF0F3460)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // ✅ PLAYER BUTTONS
  // -------------------------------------------------------------

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text("প্রোফাইল যাচাই হচ্ছে...",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerProfileButton(BuildContext context) {
    return _playerButton(
      title: "⚽ আমার প্লেয়ার প্রোফাইল",
      subtitle: "আপনার ম্যাচ এবং স্ট্যাটস দেখুন",
      color1: Color(0xFF0F3460),
      color2: Color(0xFF1A5490),
      iconColor: Colors.green,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyPlayerProfileScreen()),
      ),
    );
  }

  Widget _buildCreatePlayerButton(
      BuildContext context, AuthProvider auth, PlayerProvider player) {
    return _playerButton(
      title: "⚽ প্লেয়ার প্রোফাইল তৈরি করুন",
      subtitle: "আপনার নিজস্ব প্লেয়ার আইডি পান",
      color1: Color(0xFF28A745),
      color2: Color(0xFF20C997),
      iconColor: Colors.white,
      onTap: () => _showCreatePlayerDialog(context, auth, player),
    );
  }

  Widget _playerButton({
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required Color iconColor,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconColor,
              child:
              const Icon(Icons.sports_soccer, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(color: Colors.white, fontSize: 18)),
                  Text(subtitle,
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // ✅ CREATE PLAYER DIALOG
  // -------------------------------------------------------------

  void _showCreatePlayerDialog(
      BuildContext context,
      AuthProvider auth,
      PlayerProvider player,
      ) {
    String? selectedPosition;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: const Text("পজিশন নির্বাচন করুন",
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...[
                    "ফরওয়ার্ড",
                    "মিডফিল্ডার",
                    "ডিফেন্ডার",
                    "গোলকিপার",
                  ].map((p) {
                    return RadioListTile<String>(
                      title: Text(p, style: const TextStyle(color: Colors.white)),
                      value: p,
                      groupValue: selectedPosition,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        setState(() => selectedPosition = val);
                      },
                    );
                  })
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("বাতিল", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: selectedPosition == null
                      ? null
                      : () async {
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                    );

                    bool ok = await player.createPlayerProfile(
                      user: auth.currentUser!,
                      position: selectedPosition!,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok
                            ? "✅ প্লেয়ার প্রোফাইল তৈরি সফল!"
                            : (player.errorMessage ??
                            "প্লেয়ার প্রোফাইল তৈরি ব্যর্থ")),
                        backgroundColor: ok ? Colors.green : Colors.red,
                      ),
                    );

                    if (ok) setState(() {});
                  },
                  child:
                  const Text("তৈরি করুন", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // ✅ LOGOUT DIALOG
  // -------------------------------------------------------------

  void _showLogoutDialog(
      BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          title: const Text("লগআউট", style: TextStyle(color: Colors.white)),
          content: const Text("আপনি কি লগআউট করতে চান?",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("না", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, "/login");
                }
              },
              child:
              const Text("হ্যাঁ", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
