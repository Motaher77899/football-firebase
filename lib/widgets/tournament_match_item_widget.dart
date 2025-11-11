import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TournamentMatchItemWidget extends StatelessWidget {
  final Map<String, dynamic> match;

  const TournamentMatchItemWidget({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = match['status'] ?? 'upcoming';
    final teamA = match['teamA'] ?? 'টিম ১';
    final teamB = match['teamB'] ?? 'টিম ২';
    final scoreA = match['scoreA'] ?? 0;
    final scoreB = match['scoreB'] ?? 0;

    DateTime? matchTime;
    if (match['matchTime'] != null) {
      if (match['matchTime'] is Timestamp) {
        matchTime = (match['matchTime'] as Timestamp).toDate();
      } else if (match['matchTime'] is DateTime) {
        matchTime = match['matchTime'];
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == 'live'
              ? Colors.red.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status and Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(status),
              if (matchTime != null)
                Text(
                  DateFormat('dd MMM, hh:mm a').format(matchTime),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Teams and Score Row
          Row(
            children: [
              // Team A
              Expanded(
                child: Column(
                  children: [
                    _buildTeamLogo(match['teamALogo']),
                    const SizedBox(height: 8),
                    Text(
                      teamA,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Score
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status == 'upcoming' ? 'VS' : '$scoreA - $scoreB',
                  style: TextStyle(
                    color: status == 'live'
                        ? const Color(0xFF00D9FF)
                        : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Team B
              Expanded(
                child: Column(
                  children: [
                    _buildTeamLogo(match['teamBLogo']),
                    const SizedBox(height: 8),
                    Text(
                      teamB,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String? logoUrl) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: logoUrl != null && logoUrl.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: logoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF00D9FF),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.sports_soccer,
            color: Color(0xFF00D9FF),
            size: 30,
          ),
        )
            : const Icon(
          Icons.sports_soccer,
          color: Color(0xFF00D9FF),
          size: 30,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (status) {
      case 'live':
        badgeColor = Colors.red;
        badgeText = 'লাইভ';
        badgeIcon = Icons.play_circle_filled;
        break;
      case 'upcoming':
        badgeColor = Colors.orange;
        badgeText = 'আসন্ন';
        badgeIcon = Icons.schedule;
        break;
      case 'finished':
        badgeColor = Colors.grey;
        badgeText = 'সমাপ্ত';
        badgeIcon = Icons.check_circle;
        break;
      default:
        badgeColor = Colors.blue;
        badgeText = 'অজানা';
        badgeIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}