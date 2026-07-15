import 'package:flutter/material.dart';

class ContinueStudyingCard extends StatelessWidget {
  static const Color accent = Color(0xFF0091D5);

  final bool hasHistory;
  final String materiaNombre;
  final String imagenAsset;
  final String? modoLabel;
  final double? resultadoPct;
  final VoidCallback onTap;
  final Color darkGradientColor;
  final Color darkTextColor;
  final Color lightTextColor;

  const ContinueStudyingCard({
    super.key,
    required this.hasHistory,
    required this.materiaNombre,
    required this.imagenAsset,
    required this.modoLabel,
    required this.resultadoPct,
    required this.onTap,
    required this.darkGradientColor,
    required this.darkTextColor,
    required this.lightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = esModoOscuro ? darkTextColor : lightTextColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.35)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: esModoOscuro
                ? [darkGradientColor.withOpacity(0.95), darkGradientColor.withOpacity(0.8)]
                : [Colors.white, Colors.white],
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                imagenAsset,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasHistory ? 'CONTINUAR ESTUDIANDO' : 'EMPIEZA POR AQUÍ',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    materiaNombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 3),
                  if (hasHistory) ...[
                    Text(
                      'Último modo: $modoLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.7)),
                    ),
                    if (resultadoPct != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Último resultado: ${resultadoPct!.round()}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent),
                        ),
                      ),
                  ] else
                    Text(
                      'Elige tu modo de estudio',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.7)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: accent, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
