import 'package:flutter/material.dart';

class PanelEstudioHeader extends StatelessWidget {
  final String userName;
  final int rachaActivaMax;
  final ValueNotifier<ThemeMode> themeNotifier;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onOpenInstructions;
  final VoidCallback onOpenSuggestions;
  final VoidCallback onOpenHistory;
  final VoidCallback onStreakTap;
  final VoidCallback onLogout;

  const PanelEstudioHeader({
    super.key,
    required this.userName,
    required this.rachaActivaMax,
    required this.themeNotifier,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onOpenInstructions,
    required this.onOpenSuggestions,
    required this.onOpenHistory,
    required this.onStreakTap,
    required this.onLogout,
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
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
        InkWell(
          onTap: onStreakTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 14),
                const SizedBox(width: 3),
                Text(
                  '$rachaActivaMax',
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 34,
          height: 22,
          child: FittedBox(
            fit: BoxFit.fill,
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                bool isDark = currentMode == ThemeMode.dark ||
                    (currentMode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness == Brightness.dark);

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
          ),
        ),
        const SizedBox(width: 2),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          iconSize: 20,
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: onLogout,
        ),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
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
      ],
    );
  }
}
