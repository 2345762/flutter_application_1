import 'package:flutter/material.dart';

import 'streak_fire_badge.dart';

class PanelEstudioHeader extends StatelessWidget {
  final String userName;
  final int rachaActivaMax;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onStreakTap;

  const PanelEstudioHeader({
    super.key,
    required this.userName,
    required this.rachaActivaMax,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onStreakTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double streakBadgeSize = screenWidth >= 600
        ? 92.0
        : (screenWidth <= 340 ? 72.0 : 79.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: Colors.indigo,
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hola, $userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'ENCARGADO DE OPERACIONES DE VUELO',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        StreakFireBadge(
          streakDays: rachaActivaMax,
          onTap: onStreakTap,
          size: streakBadgeSize,
        ),
        const SizedBox(width: 6),
        Semantics(
          button: true,
          label: 'Abrir menú',
          child: Material(
            color: textColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(Icons.menu, size: 22, color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
