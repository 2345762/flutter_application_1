import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// Dónde se usa la insignia: define composición y densidad visual,
/// no la fuente del dato (siempre `streakDays` real, recibido por parámetro).
enum StreakBadgeVariant {
  /// Esquina superior derecha del encabezado. Compacta pero prominente.
  header,

  /// Bloque de resumen inferior ("Racha Máx."). Versión dominante con
  /// etiqueta de columna adicional para alinearse con las tarjetas vecinas.
  summary,
}

/// Insignia animada de racha: llama en loop continuo + número real de días.
///
/// La llama se pinta directamente sobre el fondo del Panel de Estudio, sin
/// disco ni plataforma detrás: solo un glow radial muy suave (sin relleno
/// sólido ni borde) para dar algo de profundidad. El número y la etiqueta
/// se muestran siempre debajo de la llama, en una cápsula compacta propia,
/// nunca superpuestos sobre ella.
class StreakFireBadge extends StatelessWidget {
  final int streakDays;
  final VoidCallback onTap;
  final double size;
  final StreakBadgeVariant variant;
  final Color captionColor;

  const StreakFireBadge({
    super.key,
    required this.streakDays,
    required this.onTap,
    required this.size,
    this.variant = StreakBadgeVariant.header,
    this.captionColor = Colors.white70,
  });

  bool get _isActive => streakDays > 0;

  bool get _isSummary => variant == StreakBadgeVariant.summary;

  String get _diasLabel => streakDays == 1 ? 'día' : 'días';

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    final Widget flame = SizedBox(
      width: size,
      height: size,
      // clipBehavior.none: el glow (size*1.5) es intencionalmente más grande
      // que esta caja y debe poder pintarse por fuera sin ser recortado en
      // cuadrado por el Stack (el recorte duro es lo que se veía como una
      // capa/borde detrás de la llama). El tamaño de layout sigue siendo
      // size x size: esto solo afecta el pintado, no el espacio reservado.
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Capa 1 (fondo): glow suave, degradado radial que se desvanece a
          // transparente total. Sin relleno sólido, sin borde: no es un
          // disco, es luz ambiental detrás de la llama. Con racha en 0 el
          // único diferenciador es un glow más chico/tenue: la llama en sí
          // nunca pierde brillo, color ni saturación.
          IgnorePointer(
            child: Container(
              width: size * (_isActive ? 1.5 : 1.15),
              height: size * (_isActive ? 1.5 : 1.15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFFFC773,
                    ).withValues(alpha: _isActive ? 0.4 : 0.16),
                    const Color(
                      0xFFFF8A3D,
                    ).withValues(alpha: _isActive ? 0.22 : 0.09),
                    const Color(0xFFFF8A3D).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          // Capa 2 (frente): llama animada en loop continuo, pintada última
          // (encima del glow) y sin ningún contenedor/color/filtro alrededor.
          // Siempre a opacidad plena y con sus colores originales completos
          // (naranja/amarillo/rojo), incluso con racha en 0: el único
          // diferenciador visual del estado inactivo es el glow y el
          // contador "0 días" debajo, nunca el brillo de la llama.
          Lottie.asset(
            'assets/animations/streak_fire.json',
            width: size,
            height: size,
            fit: BoxFit.contain,
            animate: !reduceMotion,
            repeat: true,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.local_fire_department,
              size: size * 0.86,
              color: const Color(0xFFFF7A1A),
            ),
          ),
        ],
      ),
    );

    final Widget pill = Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.13,
        vertical: size * 0.04,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(
          color: (_isActive ? const Color(0xFFFF8A3D) : Colors.white24)
              .withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$streakDays',
                style: GoogleFonts.inter(
                  fontSize: size * 0.19,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: _isActive ? const Color(0xFFFFB067) : Colors.white70,
                ),
              ),
              TextSpan(
                text: ' $_diasLabel',
                style: GoogleFonts.inter(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        flame,
        SizedBox(height: size * 0.07),
        pill,
        if (_isSummary) ...[
          SizedBox(height: size * 0.05),
          Text(
            'RACHA MÁX.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: captionColor,
            ),
          ),
        ],
      ],
    );

    return Semantics(
      button: true,
      label: 'Racha activa: $streakDays $_diasLabel. Ver resumen de rachas.',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size * 0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
