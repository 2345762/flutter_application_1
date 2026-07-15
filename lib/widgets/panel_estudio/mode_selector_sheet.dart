import 'package:flutter/material.dart';

class ModeSelectorSheet extends StatelessWidget {
  final int lives;
  final VoidCallback onPractice;
  final VoidCallback onTest;
  final VoidCallback onRacha;

  const ModeSelectorSheet({
    super.key,
    required this.lives,
    required this.onPractice,
    required this.onTest,
    required this.onRacha,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLives = lives > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.school, color: Colors.indigo),
            title: const Text("Modo Práctica"),
            subtitle: const Text("Retroalimentación inmediata."),
            onTap: onPractice,
          ),
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.orange),
            title: const Text("Modo Test (Examen)"),
            subtitle: const Text("Solucionario solo al final."),
            onTap: onTest,
          ),
          ListTile(
            leading: const Icon(Icons.local_fire_department, color: Colors.red),
            title: Row(
              children: [
                const Text("¡Racha!"),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      index < lives ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            subtitle: Text(
              hasLives
                  ? "Examen cronometrado de racha diaria."
                  : "No tienes vidas disponibles. Espera a que se recarguen (00:00).",
              style: TextStyle(
                color: hasLives ? null : Colors.red,
                fontWeight: hasLives ? null : FontWeight.bold,
              ),
            ),
            onTap: hasLives ? onRacha : null,
            enabled: hasLives,
          ),
        ],
      ),
    );
  }
}
