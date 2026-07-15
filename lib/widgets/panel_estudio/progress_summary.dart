import 'package:flutter/material.dart';

import 'streak_fire_badge.dart';

class ProgressSummary extends StatelessWidget {
  final int materiasIniciadas;
  final int totalMaterias;
  final int rachaActivaMax;
  final String mejorResultadoLabel;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onStreakTap;

  const ProgressSummary({
    super.key,
    required this.materiasIniciadas,
    required this.totalMaterias,
    required this.rachaActivaMax,
    required this.mejorResultadoLabel,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onStreakTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Debe verse un poco más grande que la llama del header (72/79/92).
    final double streakBadgeSize = screenWidth >= 600
        ? 100.0
        : (screenWidth <= 340 ? 78.0 : 86.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Semantics(
            label: 'Materias iniciadas: $materiasIniciadas de $totalMaterias',
            excludeSemantics: true,
            child: _StatChip(
              value: '$materiasIniciadas/$totalMaterias',
              label: 'MATERIAS',
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
        const SizedBox(width: 10),
        Expanded(
          child: Semantics(
            label: mejorResultadoLabel == '—'
                ? 'Mejor resultado: sin intentos'
                : 'Mejor resultado: $mejorResultadoLabel',
            excludeSemantics: true,
            child: _StatChip(
              value: mejorResultadoLabel,
              label: 'MEJOR',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
        ),
      ],
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
              fontSize: 16,
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
