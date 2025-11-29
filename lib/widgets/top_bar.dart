import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';

/// Top bar showing XP, level, and streak
class TopBar extends StatelessWidget {
  final UserProfile profile;

  const TopBar({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // calculate level from XP (Duolingo style)
    final int level = profile.totalXP ~/ 100;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + UIHelpers.spacingS,
        left: UIHelpers.spacingM,
        right: UIHelpers.spacingM,
        bottom: UIHelpers.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🔥 STREAK
          _buildStatChip(
            icon: '🔥',
            value: '${profile.streakDays}',
            label: 'day streak',
            color: AppColors.streakOrange,
          ),

          // ⚡ XP
          _buildStatChip(
            icon: '⚡',
            value: '${profile.totalXP}',
            label: 'total XP',
            color: AppColors.xpGold,
          ),

          // 🎯 LEVEL
          _buildLevelBadge(level),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIHelpers.spacingM,
        vertical: UIHelpers.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIHelpers.radiusL),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: UIHelpers.spacingS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(int level) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.blueGradient,
        boxShadow: UIHelpers.buttonShadow,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$level',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'LVL',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
