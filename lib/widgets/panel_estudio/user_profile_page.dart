import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final String userName;
  final ValueNotifier<ThemeMode> themeNotifier;

  const UserProfilePage({
    super.key,
    required this.userName,
    required this.themeNotifier,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic> _userData = {};
  bool _loading = true;
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _streakDays = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('userName');
      
      if (userName != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('user_summaries')
            .doc(userName)
            .get();
        
        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>;
            _loading = false;
          });
          
          _loadStreakDays();
        } else {
          setState(() => _loading = false);
        }
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _loadStreakDays() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final examHistoryStr = prefs.getString('exam_history') ?? '[]';
      final List<dynamic> examHistory = json.decode(examHistoryStr);
      
      Set<DateTime> streakDays = {};
      for (var exam in examHistory) {
        if (exam['mode'] == 'streak' && exam['passed'] == true) {
          final date = DateTime.parse(exam['date'] as String);
          final chileanDate = DateTime(date.year, date.month, date.day);
          streakDays.add(chileanDate);
        }
      }
      
      setState(() {
        _streakDays = streakDays;
      });
    } catch (e) {
      print("Error loading streak days: $e");
    }
  }

  int _getCurrentStreak() {
    if (_userData.containsKey('globalStreak')) {
      final streakData = _userData['globalStreak'] as Map<String, dynamic>;
      return streakData['streakDays'] as int? ?? 0;
    }
    return 0;
  }

  int _getMaxStreak() {
    if (_userData.containsKey('globalStreak')) {
      final streakData = _userData['globalStreak'] as Map<String, dynamic>;
      return streakData['maxStreakDays'] as int? ?? 0;
    }
    return 0;
  }

  int _getTotalExams() {
    if (_userData.containsKey('examHistory')) {
      final examHistory = _userData['examHistory'] as List<dynamic>;
      return examHistory.length;
    }
    return 0;
  }

  int _getAvailableLives() {
    if (_userData.containsKey('livesData')) {
      final livesData = _userData['livesData'] as List<dynamic>;
      return livesData.where((life) {
        if (life is Map<String, dynamic>) {
          return life['isAvailable'] as bool? ?? false;
        }
        return false;
      }).length;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = esModoOscuro ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final Color secondaryTextColor = esModoOscuro ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final Color surfaceColor = esModoOscuro ? const Color(0xFF1E293B) : Colors.white;
    final Color backgroundColor = esModoOscuro ? const Color(0xFF0F172A) : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Perfil de Usuario"),
        backgroundColor: esModoOscuro ? const Color(0xFF1E293B) : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  _buildUserInfoCard(textColor, secondaryTextColor, surfaceColor),
                  const SizedBox(height: 20),
                  
                  // Study Metrics
                  _buildStudyMetrics(textColor, secondaryTextColor, surfaceColor),
                  const SizedBox(height: 20),
                  
                  // Streak Calendar
                  _buildStreakCalendar(textColor, secondaryTextColor, surfaceColor, esModoOscuro),
                  const SizedBox(height: 20),
                  
                  // Exam Statistics
                  _buildExamStatistics(textColor, secondaryTextColor, surfaceColor),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoCard(Color textColor, Color secondaryTextColor, Color surfaceColor) {
    return Card(
      elevation: 4,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.indigo,
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ENCARGADO DE OPERACIONES DE VUELO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyMetrics(Color textColor, Color secondaryTextColor, Color surfaceColor) {
    final currentStreak = _getCurrentStreak();
    final maxStreak = _getMaxStreak();
    final totalExams = _getTotalExams();
    final availableLives = _getAvailableLives();

    return Card(
      elevation: 4,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Métricas de Estudio",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    "Racha Actual",
                    "$currentStreak días",
                    Icons.local_fire_department,
                    Colors.orange,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricItem(
                    "Mejor Racha",
                    "$maxStreak días",
                    Icons.emoji_events,
                    Colors.amber,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    "Total Exámenes",
                    "$totalExams",
                    Icons.quiz,
                    Colors.blue,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricItem(
                    "Vidas Restantes",
                    "$availableLives/3",
                    Icons.favorite,
                    Colors.red,
                    textColor,
                    secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCalendar(Color textColor, Color secondaryTextColor, Color surfaceColor, bool esModoOscuro) {
    final months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
                    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    
    return Card(
      elevation: 4,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Calendario de Rachas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              eventLoader: (day) {
                final dayToCheck = DateTime(day.year, day.month, day.day);
                return _streakDays.contains(dayToCheck) ? ['streak'] : [];
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: textColor),
                defaultTextStyle: TextStyle(color: textColor),
                todayTextStyle: TextStyle(color: textColor),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
                titleTextFormatter: (date, locale) {
                  return '${months[date.month - 1]} ${date.year}';
                },
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 20,
                        height: 20,
                        child: Lottie.asset(
                          'assets/animations/streak_fire.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                  return null;
                },
                dowBuilder: (context, day) {
                  final weekdays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                  final text = weekdays[day.weekday - 1];
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              daysOfWeekHeight: 32,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  child: Lottie.asset(
                    'assets/animations/streak_fire.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Días con racha completada",
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamStatistics(Color textColor, Color secondaryTextColor, Color surfaceColor) {
    if (!_userData.containsKey('examHistory')) {
      return const SizedBox.shrink();
    }

    final examHistory = _userData['examHistory'] as List<dynamic>;
    if (examHistory.isEmpty) {
      return Card(
        elevation: 4,
        color: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              "No hay exámenes registrados",
              style: TextStyle(color: secondaryTextColor),
            ),
          ),
        ),
      );
    }

    Map<String, int> subjectStats = {};
    for (var exam in examHistory) {
      final subject = exam['subject'] as String;
      if (!subjectStats.containsKey(subject)) {
        subjectStats[subject] = 0;
      }
      subjectStats[subject] = (subjectStats[subject] ?? 0) + 1;
    }

    return Card(
      elevation: 4,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Estadísticas por Materia",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...subjectStats.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Text(
                        "${entry.value} exámenes",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}