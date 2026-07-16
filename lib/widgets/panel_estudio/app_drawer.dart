import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  static const Color instructivoColor = Color(0xFFEF5350);
  static const Color sugerenciasColor = Color(0xFFFFB300);
  static const Color historialColor = Color(0xFF0091D5);

  final String userName;
  final int materiasIniciadas;
  final int totalMaterias;
  final ValueNotifier<ThemeMode> themeNotifier;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onOpenInstructions;
  final VoidCallback onOpenSuggestions;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenAbout;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.materiasIniciadas,
    required this.totalMaterias,
    required this.themeNotifier,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onOpenInstructions,
    required this.onOpenSuggestions,
    required this.onOpenHistory,
    required this.onOpenAbout,
    required this.onLogout,
  });

  void _selectAndClose(BuildContext context, VoidCallback action) {
    Navigator.of(context).pop();
    action();
  }

  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth = (screenWidth * 0.83) > 320
        ? 320
        : (screenWidth * 0.83);
    final Color dividerColor = textColor.withValues(alpha: 0.08);
    final double progreso = totalMaterias > 0
        ? materiasIniciadas / totalMaterias
        : 0.0;

    return Drawer(
      width: drawerWidth,
      backgroundColor: surfaceColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.indigo,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'ENCARGADO DE OPERACIONES DE VUELO',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    label:
                        'Materias iniciadas: $materiasIniciadas de $totalMaterias',
                    excludeSemantics: true,
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progreso,
                              minHeight: 6,
                              backgroundColor: textColor.withValues(alpha: 0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                historialColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$materiasIniciadas/$totalMaterias',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Semantics(
                    button: true,
                    label: 'Ver Instructivo',
                    child: ListTile(
                      minVerticalPadding: 14,
                      leading: _iconBadge(
                        Icons.picture_as_pdf,
                        instructivoColor,
                      ),
                      title: Text(
                        'Ver Instructivo',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => _selectAndClose(context, onOpenInstructions),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Abrir Buzón de Sugerencias',
                    child: ListTile(
                      minVerticalPadding: 14,
                      leading: _iconBadge(
                        Icons.feedback_outlined,
                        sugerenciasColor,
                      ),
                      title: Text(
                        'Buzón de Sugerencias',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => _selectAndClose(context, onOpenSuggestions),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Abrir Historial de Exámenes',
                    child: ListTile(
                      minVerticalPadding: 14,
                      leading: _iconBadge(Icons.history, historialColor),
                      title: Text(
                        'Historial de Exámenes',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => _selectAndClose(context, onOpenHistory),
                    ),
                  ),
                  Divider(
                    height: 24,
                    indent: 20,
                    endIndent: 20,
                    color: dividerColor,
                  ),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, currentMode, child) {
                      final bool isDark =
                          currentMode == ThemeMode.dark ||
                          (currentMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark);
                      return Semantics(
                        button: true,
                        toggled: isDark,
                        label: isDark
                            ? 'Activar modo claro'
                            : 'Activar modo oscuro',
                        child: ListTile(
                          minVerticalPadding: 14,
                          leading: _iconBadge(
                            Icons.brightness_6_outlined,
                            secondaryTextColor,
                          ),
                          title: Text(
                            'Tema oscuro',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Switch(
                            value: isDark,
                            activeThumbColor: Colors.amber,
                            activeTrackColor: Colors.black45,
                            inactiveThumbColor: Colors.indigo,
                            onChanged: (value) {
                              themeNotifier.value = value
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                            },
                          ),
                          onTap: () {
                            themeNotifier.value = isDark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                          },
                        ),
                      );
                    },
                  ),
                  Semantics(
                    button: true,
                    label: 'Acerca de la aplicación',
                    child: ListTile(
                      minVerticalPadding: 14,
                      leading: _iconBadge(
                        Icons.info_outline,
                        secondaryTextColor,
                      ),
                      title: Text(
                        'Acerca de la aplicación',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () => _selectAndClose(context, onOpenAbout),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),
            Semantics(
              button: true,
              label: 'Cerrar sesión',
              child: ListTile(
                minVerticalPadding: 14,
                leading: _iconBadge(Icons.logout, Colors.red),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _selectAndClose(context, onLogout),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
