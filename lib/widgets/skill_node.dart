// filename: lib/widgets/skill_node.dart

import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';
import 'progress_ring.dart';

/// Skill node widget - circular node in the skill tree
class SkillNode extends StatelessWidget {
  final Skill skill;
  final VoidCallback onTap;

  const SkillNode({Key? key, required this.skill, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLocked = !skill.isUnlocked;
    final isCompleted = skill.progress >= 1.0;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Node with progress ring
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress ring
              ProgressRing(
                progress: skill.progress,
                size: 80,
                ringColor: isLocked
                    ? AppColors.lockedGray
                    : AppColors.primaryGreen,
                child: _buildNodeContent(isLocked, isCompleted),
              ),

              // Completion star badge
              if (isCompleted)
                Positioned(top: -4, right: -4, child: _buildStarBadge()),
            ],
          ),

          const SizedBox(height: UIHelpers.spacingS),

          // Skill name label
          SizedBox(
            width: 100,
            child: Text(
              skill.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isLocked ? AppColors.textLight : AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeContent(bool isLocked, bool isCompleted) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isLocked
            ? null
            : (isCompleted
                  ? AppColors.goldGradient
                  : AppColors.primaryGradient),
        color: isLocked ? AppColors.lockedGray : null,
        boxShadow: isLocked ? null : UIHelpers.buttonShadow,
      ),
      child: Center(
        child: Text(
          skill.iconEmoji,
          style: TextStyle(
            fontSize: 32,
            color: isLocked ? AppColors.textLight : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStarBadge() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.goldGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.xpGold.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(child: Text('⭐', style: TextStyle(fontSize: 16))),
    );
  }
}
