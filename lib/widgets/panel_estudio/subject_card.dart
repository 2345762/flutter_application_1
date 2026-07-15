import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String nombre;
  final String imagenAsset;
  final int streakDays;
  final VoidCallback onTap;
  final Color darkGradientColor;
  final Color darkTextColor;
  final Color lightTextColor;

  const SubjectCard({
    super.key,
    required this.nombre,
    required this.imagenAsset,
    required this.streakDays,
    required this.onTap,
    required this.darkGradientColor,
    required this.darkTextColor,
    required this.lightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: esModoOscuro ? Colors.black26 : Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: esModoOscuro
                  ? [
                      darkGradientColor.withOpacity(0.9),
                      darkGradientColor.withOpacity(0.7),
                    ]
                  : [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
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
                      double escala = esEscritorio ? 0.85 : 1.15;
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
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            ),
                            if (streakDays > 0)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.orange.shade400, Colors.red.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.local_fire_department, color: Colors.white, size: 11),
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
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: esModoOscuro ? darkTextColor : lightTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
