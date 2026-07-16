import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  static const Color accent = Color(0xFF0091D5);

  final String nombre;
  final String imagenAsset;
  final int streakDays;
  final bool tieneIntentos;
  final double? ultimoPct;
  final bool esMateriaActual;
  final double progressPercentage; // Study mode progress (0.0 to 1.0)
  final VoidCallback onTap;
  final Color darkGradientColor;
  final Color darkTextColor;
  final Color lightTextColor;

  const SubjectCard({
    super.key,
    required this.nombre,
    required this.imagenAsset,
    required this.streakDays,
    required this.tieneIntentos,
    required this.ultimoPct,
    required this.esMateriaActual,
    this.progressPercentage = 0.0,
    required this.onTap,
    required this.darkGradientColor,
    required this.darkTextColor,
    required this.lightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = esModoOscuro ? darkTextColor : lightTextColor;

    final String estadoLabel = 'Progreso: ${(progressPercentage * 100).round()}%';
    final String rachaLabel = streakDays > 0
        ? '. Racha activa de $streakDays días'
        : '';
    final String actualLabel = esMateriaActual ? '. Materia actual' : '';
    final String semanticsLabel =
        '$nombre. $estadoLabel$rachaLabel$actualLabel';

    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shadowColor: esModoOscuro ? Colors.black26 : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: esMateriaActual
                ? const BorderSide(color: accent, width: 2)
                : BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: esModoOscuro
                    ? [
                        darkGradientColor.withValues(alpha: 0.9),
                        darkGradientColor.withValues(alpha: 0.7),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.7),
                      ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool esEscritorio = constraints.maxWidth > 600;
                        double escala = esEscritorio ? 0.78 : 0.88;
                        return Transform.scale(
                          scale: escala,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                imagenAsset,
                                cacheWidth: 800,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                              if (streakDays > 0)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.shade400,
                                          Colors.red.shade400,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.local_fire_department,
                                          color: Colors.white,
                                          size: 11,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "$streakDays",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 1),
                  child: Text(
                    nombre,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      height: 1.1,
                      color: textColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1.5),
                          child: LinearProgressIndicator(
                            value: progressPercentage,
                            minHeight: 3,
                            backgroundColor: esModoOscuro
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressPercentage >= 1.0 ? Colors.green : accent,
                            ),
                          ),
                        ),
                      ),
                      if (progressPercentage > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${(progressPercentage * 100).round()}%',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: progressPercentage >= 1.0 ? Colors.green : textColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
