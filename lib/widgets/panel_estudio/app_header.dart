import 'package:flutter/material.dart';

class PanelEstudioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalStreakExams;
  final ValueNotifier<ThemeMode> themeNotifier;
  final VoidCallback onOpenInstructions;
  final VoidCallback onOpenSuggestions;
  final VoidCallback onOpenHistory;
  final VoidCallback onStreakTap;
  final VoidCallback onLogout;

  const PanelEstudioAppBar({
    super.key,
    required this.totalStreakExams,
    required this.themeNotifier,
    required this.onOpenInstructions,
    required this.onOpenSuggestions,
    required this.onOpenHistory,
    required this.onStreakTap,
    required this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Panel de Estudio", style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, size: 20),
            onSelected: (String choice) {
              switch (choice) {
                case 'instructions':
                  onOpenInstructions();
                  break;
                case 'suggestions':
                  onOpenSuggestions();
                  break;
                case 'history':
                  onOpenHistory();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'instructions',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Ver Instructivo'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'suggestions',
                child: Row(
                  children: [
                    Icon(Icons.feedback_outlined, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Buzón de Sugerencias'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('Historial de Exámenes'),
                  ],
                ),
              ),
            ],
          ),
          if (totalStreakExams > 0)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: InkWell(
                onTap: onStreakTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "$totalStreakExams",
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
        ],
      ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            bool isDark = currentMode == ThemeMode.dark ||
                (currentMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

            return Switch(
              value: isDark,
              activeColor: Colors.amber,
              activeTrackColor: Colors.black45,
              inactiveThumbColor: Colors.indigo,
              onChanged: (value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: onLogout,
        ),
      ],
    );
  }
}
