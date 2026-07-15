import 'package:flutter/material.dart';

class ModeSelectorSheet extends StatelessWidget {
  static const Color practicaColor = Color(0xFF0091D5);
  static const Color testColor = Color(0xFFFFA000);
  static const Color rachaColor = Color(0xFFFF7043);
  static const Color corazonDisponible = Color(0xFFEF5350);
  static const Color corazonGastado = Color(0xFF9AA5B1);

  final String materiaNombre;
  final int preguntasPractica;
  final int preguntasTest;
  final int lives;
  final int rachaActiva;
  final VoidCallback onPractice;
  final VoidCallback onTest;
  final VoidCallback onRacha;

  const ModeSelectorSheet({
    super.key,
    required this.materiaNombre,
    required this.preguntasPractica,
    required this.preguntasTest,
    required this.lives,
    required this.rachaActiva,
    required this.onPractice,
    required this.onTest,
    required this.onRacha,
  });

  static String _vidasLabel(int lives) {
    final String sustantivo = lives == 1 ? 'vida' : 'vidas';
    final String adjetivo = lives == 1 ? 'disponible' : 'disponibles';
    return '$lives $sustantivo $adjetivo';
  }

  @override
  Widget build(BuildContext context) {
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final Color surface = esModoOscuro ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = esModoOscuro
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF0F172A);
    final Color secondaryTextColor = esModoOscuro
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);
    final bool hasLives = lives > 0;

    final double maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SafeArea(
        // SafeArea(top: false) ya agrega MediaQuery.of(context).padding.bottom
        // como inset inferior — no se debe sumar de nuevo en este padding.
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: secondaryTextColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                'Elige tu modo de estudio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                materiaNombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, color: secondaryTextColor),
              ),
              const SizedBox(height: 14),
              Semantics(
                button: true,
                label: 'Seleccionar Modo Práctica',
                child: _ModeCard(
                  color: practicaColor,
                  icon: Icons.school,
                  title: 'Modo Práctica',
                  description: 'Retroalimentación inmediata en cada pregunta',
                  trailing: _CountBadge(
                    text: '$preguntasPractica preguntas',
                    color: practicaColor,
                  ),
                  onTap: onPractice,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Semantics(
                button: true,
                label: 'Seleccionar Modo Test',
                child: _ModeCard(
                  color: testColor,
                  icon: Icons.timer_outlined,
                  title: 'Modo Test (Examen)',
                  description: 'Solucionario disponible solo al finalizar',
                  trailing: _CountBadge(
                    text: '$preguntasTest preguntas',
                    color: testColor,
                  ),
                  onTap: onTest,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Semantics(
                button: true,
                enabled: hasLives,
                label: hasLives
                    ? 'Seleccionar Modo Racha. ${_vidasLabel(lives)}. Racha activa de $rachaActiva días.'
                    : 'Modo Racha deshabilitado. Sin vidas disponibles.',
                child: _ModeCard(
                  color: rachaColor,
                  icon: Icons.local_fire_department,
                  title: '¡Racha!',
                  description: hasLives
                      ? 'Examen cronometrado de racha diaria'
                      : 'No tienes vidas disponibles. Espera a que se recarguen (00:00).',
                  disabled: !hasLives,
                  trailing: _HeartsRow(lives: lives),
                  extra: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Text(
                          _vidasLabel(lives),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasLives
                                ? corazonDisponible
                                : secondaryTextColor,
                          ),
                        ),
                        if (rachaActiva > 0) ...[
                          Text(
                            '  ·  ',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                          Icon(
                            Icons.local_fire_department,
                            size: 13,
                            color: rachaColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Racha activa: $rachaActiva',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: rachaColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  onTap: hasLives ? onRacha : null,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final Widget trailing;
  final Widget? extra;
  final bool disabled;
  final VoidCallback? onTap;
  final Color textColor;
  final Color secondaryTextColor;

  const _ModeCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    this.extra,
    this.disabled = false,
    required this.onTap,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = disabled ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(child: trailing),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: secondaryTextColor,
                          height: 1.3,
                        ),
                      ),
                      if (extra != null) extra!,
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

class _CountBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _CountBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
    );
  }
}

class _HeartsRow extends StatelessWidget {
  final int lives;

  const _HeartsRow({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final bool disponible = index < lives;
        return Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Icon(
            disponible ? Icons.favorite : Icons.favorite_border,
            size: 15,
            color: disponible
                ? ModeSelectorSheet.corazonDisponible
                : ModeSelectorSheet.corazonGastado,
          ),
        );
      }),
    );
  }
}
