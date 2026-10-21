import 'package:flutter/material.dart';

import 'streak_fire_badge.dart';

class ProgressSummary extends StatelessWidget {
  final int materiasIniciadas;
  final int totalMaterias;
  final int rachaActivaMax;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onStreakTap;
  final VoidCallback? onAiTap;
  final int dailyExamsPassed; // New parameter for daily progress

  const ProgressSummary({
    super.key,
    required this.materiasIniciadas,
    required this.totalMaterias,
    required this.rachaActivaMax,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onStreakTap,
    this.onAiTap,
    this.dailyExamsPassed = 0, // Default to 0
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Smaller fire badge for the lower section
    final double streakBadgeSize = screenWidth >= 600
        ? 70.0
        : (screenWidth <= 340 ? 55.0 : 60.0);

    // Calculate daily progress display (max 1/1)
    final dailyProgress = dailyExamsPassed > 1 ? 1 : dailyExamsPassed;
    final dailyProgressText = '$dailyProgress/1';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Semantics(
            label: 'Exámenes necesarios para mantener la racha: $dailyProgressText',
            excludeSemantics: true,
            child: _StatChip(
              value: dailyProgressText,
              label: 'NECESARIOS',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Center(
            child: StreakFireBadge(
              streakDays: rachaActivaMax,
              onTap: onStreakTap,
              size: streakBadgeSize,
              variant: StreakBadgeVariant.summary,
              captionColor: secondaryTextColor,
            ),
          ),
        ),
        if (onAiTap != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _AiButton(
              onTap: onAiTap!,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _AiButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color textColor;
  final Color secondaryTextColor;

  const _AiButton({
    required this.onTap,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: textColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 22,
              color: textColor,
            ),
            const SizedBox(height: 3),
            Text(
              'TUTOR IA',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color textColor;
  final Color secondaryTextColor;

  const _StatChip({
    required this.value,
    required this.label,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: textColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
