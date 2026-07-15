import 'package:flutter/material.dart';

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
        Semantics(
          button: true,
          label: 'Ver resumen de rachas. Racha máxima: $rachaActivaMax días.',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStreakTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$rachaActivaMax',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
