import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';
import 'my_profile_screen.dart';
import 'team_list_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.currentUser;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0F3460),
                                Color(0xFF1A5490),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user?.fullName.isNotEmpty == true
                                  ? user!.fullName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.fullName ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person),
                          label: const Text('প্রোফাইল দেখুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF28A745),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Menu Items
              _buildMenuSection(
                context,
                title: 'ফুটবল',
                items: [
                  _MenuItem(
                    icon: Icons.shield,
                    title: 'সকল টিম',
                    subtitle: 'টিম তালিকা দেখুন',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeamListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.emoji_events,
                    title: 'টুর্নামেন্ট',
                    subtitle: 'সব টুর্নামেন্ট',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.sports_soccer,
                    title: 'খেলোয়াড়',
                    subtitle: 'সব খেলোয়াড়',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                ],
              ),

              _buildMenuSection(
                context,
                title: 'সেটিংস',
                items: [
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'নোটিফিকেশন',
                    subtitle: 'নোটিফিকেশন সেটিংস',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    title: 'ভাষা',
                    subtitle: 'বাংলা',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.dark_mode,
                    title: 'থিম',
                    subtitle: 'Dark Mode',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                ],
              ),

              _buildMenuSection(
                context,
                title: 'সাপোর্ট',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'সাহায্য',
                    subtitle: 'FAQ এবং সাপোর্ট',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'অ্যাপ সম্পর্কে',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  _MenuItem(
                    icon: Icons.share,
                    title: 'শেয়ার করুন',
                    subtitle: 'বন্ধুদের সাথে শেয়ার করুন',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming Soon')),
                      );
                    },
                  ),
                ],
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context, authProvider);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'লগআউট',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, {
        required String title,
        required List<_MenuItem> items,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: items.map((item) {
                return _buildMenuItem(context, item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.icon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
      onTap: item.onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          title: const Text(
            'লগআউট',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'আপনি কি লগআউট করতে চান?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('না'),
            ),
            TextButton(
              onPressed: () async {
                await authProvider.signOut();
                // Clear player data
                if (context.mounted) {
                  Provider.of<PlayerProvider>(context, listen: false)
                      .clearPlayer();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text(
                'হ্যাঁ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          title: const Text(
            '⚽ ফুটবল লাইভ স্কোর',
            style: TextStyle(color: Colors.white),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version: 1.0.0',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 8),
              Text(
                'বাংলাদেশের সবচেয়ে জনপ্রিয় ফুটবল লাইভ স্কোর অ্যাপ',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                '© 2024 Football Live Score',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ঠিক আছে'),
            ),
          ],
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}