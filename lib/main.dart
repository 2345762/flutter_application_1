import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io' if (dart.library.io) 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

// =============================================================
// SECCIÓN DE DATOS: IMPORTAR PREGUNTAS
// =============================================================
import 'data/aerodinamica.dart';
import 'data/performance_y_motores.dart';
import 'data/operaciones_de_vuelo.dart';
import 'data/peso_y_balance.dart';
import 'data/meteorologia.dart';
import 'data/reglamentacion.dart';
import 'models/life_data.dart';  

// =============================================================
// WIDGETS DE PRESENTACIÓN DEL PANEL DE ESTUDIO
// =============================================================
import 'widgets/panel_estudio/app_header.dart';
import 'widgets/panel_estudio/subject_card.dart';
import 'widgets/panel_estudio/mode_selector_sheet.dart';
import 'widgets/panel_estudio/continue_studying_card.dart';
import 'widgets/panel_estudio/progress_summary.dart';
import 'widgets/panel_estudio/app_drawer.dart';

// =============================================================
// UTILIDADES DE ZONA HORARIA CHILENA
// =============================================================

/// Get current date in Chilean timezone (America/Santiago)
/// hellomynameisdaniel
DateTime _getChileanDate() {
  final now = tz.TZDateTime.now(tz.local);
  return DateTime(now.year, now.month, now.day);
}

/// Check if a given date is before today in Chilean timezone
bool _isBeforeTodayInChile(DateTime date) {
  final today = _getChileanDate();
  final dateToCheck = DateTime(date.year, date.month, date.day);
  return dateToCheck.isBefore(today);
}

/// Convert a DateTime to Chilean timezone
DateTime _toChileanTime(DateTime date) {
  if (date.isUtc) {
    return tz.TZDateTime.from(date, tz.local);
  }
  return tz.TZDateTime.from(date, tz.local);
}

/// Convert a DateTime to Chilean timezone and return as regular DateTime
DateTime _toChileanTimeAsDateTime(DateTime date) {
  final chileanTime = _toChileanTime(date);
  return DateTime(chileanTime.year, chileanTime.month, chileanTime.day, 
                 chileanTime.hour, chileanTime.minute, chileanTime.second);
}

/// Format date in Chilean timezone (DD/MM/YYYY HH:MM)
String _formatDate(DateTime date) {
  final chileanDate = _toChileanTime(date);
  return '${chileanDate.day.toString().padLeft(2, '0')}/${chileanDate.month.toString().padLeft(2, '0')}/${chileanDate.year} ${chileanDate.hour.toString().padLeft(2, '0')}:${chileanDate.minute.toString().padLeft(2, '0')}';
}

// =============================================================
// MODELOS DE DATOS PARA STREAK MODE E HISTORIAL
// =============================================================

class StreakData {
  final int streakDays;
  final DateTime lastExamDate;
  final int totalExams;
  final int maxStreakDays; // All-time maximum streak
  final int dailyExamsPassed; // Exams passed today
  final DateTime? lastDailyResetDate; // When daily count was last reset
  final DateTime? lastPassedExamDate; // When the last exam was passed (for daily reset logic)

  StreakData({
    required this.streakDays,
    required this.lastExamDate,
    required this.totalExams,
    this.maxStreakDays = 0,
    this.dailyExamsPassed = 0,
    this.lastDailyResetDate,
    this.lastPassedExamDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'streakDays': streakDays,
      'lastExamDate': lastExamDate.toIso8601String(),
      'totalExams': totalExams,
      'maxStreakDays': maxStreakDays,
      'dailyExamsPassed': dailyExamsPassed,
      'lastDailyResetDate': lastDailyResetDate?.toIso8601String(),
      'lastPassedExamDate': lastPassedExamDate?.toIso8601String(),
    };
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      streakDays: json['streakDays'] as int? ?? 0,
      lastExamDate: json['lastExamDate'] != null 
          ? _toChileanTimeAsDateTime(DateTime.parse(json['lastExamDate'] as String)) 
          : DateTime.now(),
      totalExams: json['totalExams'] as int? ?? 0,
      maxStreakDays: json['maxStreakDays'] as int? ?? 0,
      dailyExamsPassed: json['dailyExamsPassed'] as int? ?? 0,
      lastDailyResetDate: json['lastDailyResetDate'] != null 
          ? _toChileanTimeAsDateTime(DateTime.parse(json['lastDailyResetDate'] as String)) 
          : null,
      lastPassedExamDate: json['lastPassedExamDate'] != null 
          ? _toChileanTimeAsDateTime(DateTime.parse(json['lastPassedExamDate'] as String)) 
          : null,
    );
  }
}

class LifeData {
  final bool isAvailable;
  final DateTime? rechargeTime; // When this life will be available (8 hours after being lost)

  LifeData({
    required this.isAvailable,
    this.rechargeTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'rechargeTime': rechargeTime?.toIso8601String(),
    };
  }

  factory LifeData.fromJson(Map<String, dynamic> json) {
    return LifeData(
      isAvailable: json['isAvailable'] as bool? ?? true,
      rechargeTime: json['rechargeTime'] != null 
          ? _toChileanTimeAsDateTime(DateTime.parse(json['rechargeTime'] as String)) 
          : null,
    );
  }
}

class GlobalStreakData {
  final List<LifeData> lives; // Individual lives with their recharge times

  GlobalStreakData({
    required this.lives,
  });

  // Constructor for default 3 available lives
  factory GlobalStreakData.defaultLives() {
    return GlobalStreakData(
      lives: List.generate(3, (_) => LifeData(isAvailable: true)),
    );
  }

  // Get count of available lives
  int get availableLives => lives.where((life) => life.isAvailable).length;

  Map<String, dynamic> toJson() {
    return {
      'lives': lives.map((life) => life.toJson()).toList(),
    };
  }

  factory GlobalStreakData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> livesJson = json['lives'] as List? ?? [];
    final List<LifeData> lives = livesJson
        .map((lifeJson) => LifeData.fromJson(lifeJson as Map<String, dynamic>))
        .toList();
    
    // If no lives data or empty, create default 3 lives
    if (lives.isEmpty) {
      return GlobalStreakData.defaultLives();
    }
    
    // Safety check: ensure we never have more than 3 lives
    if (lives.length > 3) {
      return GlobalStreakData(lives: lives.sublist(0, 3));
    }
    
    // If we have fewer than 3 lives, fill with available lives
    if (lives.length < 3) {
      final filledLives = List<LifeData>.from(lives);
      while (filledLives.length < 3) {
        filledLives.add(LifeData(isAvailable: true));
      }
      return GlobalStreakData(lives: filledLives);
    }
    
    return GlobalStreakData(lives: lives);
  }
}

class ExamResult {
  final String id;
  final String subject;
  final DateTime date;
  final int score;
  final int totalQuestions;
  final String mode; // 'practice', 'test', or 'streak'
  final int timeSpentSeconds;
  final List<Map<String, dynamic>> incorrectAnswers;
  final List<String> weakTopics;
  final List<Map<String, dynamic>> allQuestions; // All questions with answers and explanations
  final bool passed; // Whether the exam was passed (for streak mode filtering)

  ExamResult({
    required this.id,
    required this.subject,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.mode,
    required this.timeSpentSeconds,
    required this.incorrectAnswers,
    required this.weakTopics,
    required this.allQuestions,
    this.passed = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'date': date.toIso8601String(),
      'score': score,
      'totalQuestions': totalQuestions,
      'mode': mode,
      'timeSpentSeconds': timeSpentSeconds,
      'incorrectAnswers': incorrectAnswers,
      'weakTopics': weakTopics,
      'allQuestions': allQuestions,
      'passed': passed,
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] as String,
      subject: json['subject'] as String,
      date: _toChileanTimeAsDateTime(DateTime.parse(json['date'] as String)),
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      mode: json['mode'] as String,
      timeSpentSeconds: json['timeSpentSeconds'] as int,
      incorrectAnswers: List<Map<String, dynamic>>.from(json['incorrectAnswers'] as List),
      weakTopics: List<String>.from(json['weakTopics'] as List),
      allQuestions: List<Map<String, dynamic>>.from(json['allQuestions'] as List),
      passed: json['passed'] as bool? ?? true,
    );
  }
}

class PartialExamProgress {
  final String id;
  final String subject;
  final DateTime date;
  final int totalQuestions;
  final int answeredQuestions;
  final String mode; // 'practice', 'test', or 'streak'
  final List<int?> userAnswers; // Index of user's answer for each question (null if not answered)
  final int timeSpentSeconds;
  final List<Map<String, dynamic>>? questionPool; // Store the actual questions to restore the quiz
  final int currentQuestionIndex; // Track which question the user was on
  final bool reachedFiftyPercent; // Flag for anti-cheat: reached 50% completion in streak mode

  PartialExamProgress({
    required this.id,
    required this.subject,
    required this.date,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.mode,
    required this.userAnswers,
    required this.timeSpentSeconds,
    this.questionPool, // Optional: can be null if we just want to show progress
    this.currentQuestionIndex = 0, // Default to first question
    this.reachedFiftyPercent = false, // Default to false
  });

  double get completionPercentage => totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'date': date.toIso8601String(),
      'totalQuestions': totalQuestions,
      'answeredQuestions': answeredQuestions,
      'mode': mode,
      'userAnswers': userAnswers,
      'timeSpentSeconds': timeSpentSeconds,
      'questionPool': questionPool, // Include question pool for restoring
      'currentQuestionIndex': currentQuestionIndex,
      'reachedFiftyPercent': reachedFiftyPercent,
    };
  }

  factory PartialExamProgress.fromJson(Map<String, dynamic> json) {
    return PartialExamProgress(
      id: json['id'] as String,
      subject: json['subject'] as String,
      date: _toChileanTimeAsDateTime(DateTime.parse(json['date'] as String)),
      totalQuestions: json['totalQuestions'] as int,
      answeredQuestions: json['answeredQuestions'] as int,
      mode: json['mode'] as String,
      userAnswers: List<int?>.from(json['userAnswers'] as List),
      timeSpentSeconds: json['timeSpentSeconds'] as int,
      questionPool: json['questionPool'] != null 
          ? List<Map<String, dynamic>>.from(json['questionPool'] as List)
          : null,
      currentQuestionIndex: json['currentQuestionIndex'] as int? ?? 0,
      reachedFiftyPercent: json['reachedFiftyPercent'] as bool? ?? false,
    );
  }
}

// =============================================================
// SERVICIOS DE ALMACENAMIENTO
// =============================================================

class StorageService {
  static const String _streakKey = 'streak_data';
  static const String _globalStreakKey = 'global_streak_data';

  /// Firebase sync with retry mechanism
  /// Attempts to sync data to Firebase with automatic retries on failure
  static Future<bool> _syncToFirebaseWithRetry(
    String userName,
    Map<String, dynamic> userData, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        await FirebaseFirestore.instance
            .collection('user_summaries')
            .doc(userName)
            .set(userData, SetOptions(merge: true));
        return true; // Success
      } catch (e) {
        attempt++;
        print("Firebase sync attempt $attempt failed: $e");
        
        if (attempt < maxRetries) {
          await Future.delayed(retryDelay);
        } else {
          print("Firebase sync failed after $maxRetries attempts");
          return false; // All retries failed
        }
      }
    }
    
    return false; // Should not reach here
  }

  /// Batch update Firebase with all user data in a single call
  /// Ensures data consistency by updating all related data together
  static Future<bool> _batchUpdateFirebase(String userName) async {
    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String userNameCheck = prefsUser.getString('userName') ?? "Unknown";
      if (userName != userNameCheck) {
        print("Username mismatch in batch update");
        return false;
      }
      
      // Get all current data
      final streakData = await getStreakData();
      final globalStreak = await getGlobalStreakData();
      final examHistory = await getExamHistory();
      final partialProgress = await getAllPartialProgress();
      
      // Get existing Firebase data
      var userDoc = await FirebaseFirestore.instance
          .collection('user_summaries')
          .doc(userName)
          .get();
      
      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      }
      
      // Batch update all data
      if (streakData != null) {
        userData['globalStreak'] = streakData.toJson();
        userData['current_streak'] = streakData.streakDays;
        userData['max_streak'] = streakData.maxStreakDays;
      }
      
      userData['globalLives'] = globalStreak.availableLives;
      userData['livesData'] = globalStreak.lives.map((life) => life.toJson()).toList();
      
      userData['examHistory'] = examHistory.map((exam) => exam.toJson()).toList();
      userData['totalExams'] = examHistory.length;
      
      Map<String, dynamic> studyProgress = {};
      for (var entry in partialProgress.entries) {
        studyProgress[entry.key] = entry.value.toJson();
      }
      userData['studyProgress'] = studyProgress;
      
      userData['lastUpdated'] = FieldValue.serverTimestamp();
      
      return await _syncToFirebaseWithRetry(userName, userData);
    } catch (e) {
      print("Error in batch Firebase update: $e");
      return false;
    }
  }

  /// Validate Firebase data before applying it locally
  /// Returns true if data is valid, false otherwise
  static bool _validateFirebaseData(Map<String, dynamic> userData) {
    try {
      // Validate streak data if present
      if (userData.containsKey('globalStreak')) {
        final streakData = userData['globalStreak'] as Map<String, dynamic>;
        
        // Check required fields
        if (!streakData.containsKey('streakDays') || 
            !streakData.containsKey('totalExams') ||
            !streakData.containsKey('maxStreakDays')) {
          print("Invalid streak data: missing required fields");
          return false;
        }
        
        // Validate data types
        if (streakData['streakDays'] is! int || 
            streakData['totalExams'] is! int ||
            streakData['maxStreakDays'] is! int) {
          print("Invalid streak data: wrong data types");
          return false;
        }
        
        // Validate ranges
        if (streakData['streakDays'] < 0 || 
            streakData['totalExams'] < 0 ||
            streakData['maxStreakDays'] < 0) {
          print("Invalid streak data: negative values");
          return false;
        }
      }
      
      // Validate lives data if present
      if (userData.containsKey('livesData')) {
        final livesData = userData['livesData'] as List<dynamic>;
        
        if (livesData.length != 3) {
          print("Invalid lives data: should have exactly 3 lives, found ${livesData.length}");
          return false;
        }
        
        for (var lifeJson in livesData) {
          final life = lifeJson as Map<String, dynamic>;
          if (!life.containsKey('isAvailable') || life['isAvailable'] is! bool) {
            print("Invalid life data: missing or invalid isAvailable field");
            return false;
          }
        }
      }
      
      // Validate exam history if present
      if (userData.containsKey('examHistory')) {
        final examHistory = userData['examHistory'] as List<dynamic>;
        
        for (var examJson in examHistory) {
          final exam = examJson as Map<String, dynamic>;
          if (!exam.containsKey('id') || 
              !exam.containsKey('subject') ||
              !exam.containsKey('score') ||
              !exam.containsKey('date')) {
            print("Invalid exam data: missing required fields");
            return false;
          }
        }
      }
      
      return true;
    } catch (e) {
      print("Error validating Firebase data: $e");
      return false;
    }
  }

  static const String _examHistoryKey = 'exam_history';
  static const String _streakOnboardingShown = 'streak_onboarding_shown';
  static const String _partialProgressKey = 'partial_exam_progress';

  static Future<void> saveStreakData(StreakData streakData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_streakKey, json.encode(streakData.toJson()));
  }

  static Future<void> saveGlobalStreakData(GlobalStreakData globalData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_globalStreakKey, json.encode(globalData.toJson()));
  }

  static Future<GlobalStreakData> getGlobalStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    final globalDataStr = prefs.getString(_globalStreakKey);
    
    if (globalDataStr != null) {
      return GlobalStreakData.fromJson(json.decode(globalDataStr));
    }
    
    // Return default if not exists
    return GlobalStreakData.defaultLives();
  }

  static Future<StreakData?> getStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    final streakDataStr = prefs.getString(_streakKey);
    
    if (streakDataStr != null) {
      return StreakData.fromJson(json.decode(streakDataStr));
    }
    return null;
  }

  static Future<int> getTotalStreakExams() async {
    final streakData = await getStreakData();
    return streakData?.totalExams ?? 0;
  }

  /// Check for streak reset based on date change (should be called on app startup)
  /// Resets streak to 0 if 24+ hours have passed since last passed exam (skipped 1 or more days)
  static Future<void> checkAndResetStreakIfNeeded() async {
    try {
      final currentStreak = await getStreakData();
      if (currentStreak == null || currentStreak.lastPassedExamDate == null) {
        return; // No streak data or no passed exams yet
      }

      final today = _getChileanDate();
      
      // Reset streak if 1 or more days have passed since last passed exam
      final lastPassedDate = DateTime(currentStreak.lastPassedExamDate!.year, currentStreak.lastPassedExamDate!.month, currentStreak.lastPassedExamDate!.day);
      final difference = today.difference(lastPassedDate).inDays;
      
      if (difference >= 1) {
        // User skipped 1 or more days - reset streak to 0
        final resetStreak = StreakData(
          streakDays: 0,
          lastExamDate: currentStreak.lastExamDate,
          totalExams: currentStreak.totalExams,
          maxStreakDays: currentStreak.maxStreakDays,
          dailyExamsPassed: 0,
          lastDailyResetDate: today,
          lastPassedExamDate: null,
        );
        
        await saveStreakData(resetStreak);
        print("Streak reset to 0 (skipped 1 or more days)");
        
        // Sync to Firebase
        try {
          SharedPreferences prefsUser = await SharedPreferences.getInstance();
          String userName = prefsUser.getString('userName') ?? "Unknown";
          await _batchUpdateFirebase(userName);
        } catch (e) {
          print("Error syncing streak reset to Firebase: $e");
        }
      }
    } catch (e) {
      print("Error checking streak reset: $e");
    }
  }

  /// Check and recharge lives based on elapsed time (should be called on app startup)
  /// Recharges lives that have completed their 8-hour recharge period
  static Future<void> checkAndRechargeLivesIfNeeded() async {
    try {
      final globalStreak = await getGlobalStreakData();
      final rechargedLives = await _rechargeGlobalLivesIfNeeded(globalStreak);
      
      // Check if any lives were actually recharged by comparing available counts
      bool livesChanged = rechargedLives.availableLives != globalStreak.availableLives;
      
      if (livesChanged) {
        await saveGlobalStreakData(rechargedLives);
        print("Lives recharged successfully. Available lives: ${rechargedLives.availableLives}/3");
        
        // Sync to Firebase
        try {
          SharedPreferences prefsUser = await SharedPreferences.getInstance();
          String userName = prefsUser.getString('userName') ?? "Unknown";
          await _batchUpdateFirebase(userName);
        } catch (e) {
          print("Error syncing recharged lives to Firebase: $e");
        }
      }
    } catch (e) {
      print("Error checking life recharge: $e");
    }
  }

  static Future<void> updateStreakAfterExam(String subject, bool passed, double scorePercentage) async {
    final currentStreak = await getStreakData();
    final globalStreak = await getGlobalStreakData();
    final now = tz.TZDateTime.now(tz.local);
    final today = _getChileanDate();

    // Recharge global lives based on individual life recharge times
    GlobalStreakData globalWithRechargedLives = await _rechargeGlobalLivesIfNeeded(globalStreak);

    // Check if we should use existing or create new
    var workingStreak = currentStreak ?? StreakData(
      streakDays: 0,
      lastExamDate: now,
      totalExams: 0,
      maxStreakDays: 0,
      dailyExamsPassed: 0,
      lastDailyResetDate: today,
      lastPassedExamDate: null,
    );

    // Check if it's been 1 or more days since last passed exam (streak reset condition)
    // Reset occurs if user skipped 1 or more days
    if (workingStreak.lastPassedExamDate != null) {
      final lastPassedDate = DateTime(workingStreak.lastPassedExamDate!.year, workingStreak.lastPassedExamDate!.month, workingStreak.lastPassedExamDate!.day);
      final difference = today.difference(lastPassedDate).inDays;
      
      if (difference >= 1) {
        // User skipped 1 or more days - reset streak to 0
        workingStreak = StreakData(
          streakDays: 0,
          lastExamDate: workingStreak.lastExamDate,
          totalExams: workingStreak.totalExams,
          maxStreakDays: workingStreak.maxStreakDays,
          dailyExamsPassed: 0,
          lastDailyResetDate: today,
          lastPassedExamDate: null,
        );
      }
    }

    // Reset daily count if it's a new day (Chilean timezone)
    if (workingStreak.lastDailyResetDate == null || 
        _isBeforeTodayInChile(workingStreak.lastDailyResetDate!)) {
      workingStreak = StreakData(
        streakDays: workingStreak.streakDays,
        lastExamDate: workingStreak.lastExamDate,
        totalExams: workingStreak.totalExams,
        maxStreakDays: workingStreak.maxStreakDays,
        dailyExamsPassed: 0,
        lastDailyResetDate: today,
        lastPassedExamDate: workingStreak.lastPassedExamDate,
      );
    }

    // Only count exam if passed (70% threshold)
    final passedThreshold = scorePercentage >= 0.7;
    int newDailyExamsPassed = workingStreak.dailyExamsPassed;
    int newStreakDays = workingStreak.streakDays;
    int newMaxStreak = workingStreak.maxStreakDays;
    DateTime? newLastPassedExamDate = workingStreak.lastPassedExamDate;
    
    // Deduct a life if failed the exam
    List<LifeData> updatedLives = List.from(globalWithRechargedLives.lives);
    if (!passedThreshold) {
      // Find first available life and mark it as unavailable with 8-hour recharge
      for (int i = 0; i < updatedLives.length; i++) {
        if (updatedLives[i].isAvailable) {
          final rechargeTime = _toChileanTimeAsDateTime(now.add(const Duration(hours: 8)));
          updatedLives[i] = LifeData(
            isAvailable: false,
            rechargeTime: rechargeTime,
          );
          break; // Only deduct one life per failed exam
        }
      }
    }

    if (passedThreshold) {
      newDailyExamsPassed++;
      newLastPassedExamDate = _toChileanTimeAsDateTime(now);
      
      // Increment streak if this exam is on a different day than the last passed exam
      // This allows building consecutive day streaks (Day 1 → Day 2 → Day 3, etc.)
      if (workingStreak.lastPassedExamDate != null) {
        final lastPassedDate = DateTime(workingStreak.lastPassedExamDate!.year, workingStreak.lastPassedExamDate!.month, workingStreak.lastPassedExamDate!.day);
        final currentDate = DateTime(now.year, now.month, now.day);
        
        if (currentDate.isAfter(lastPassedDate)) {
          // Passed exam on a new day - increment streak
          newStreakDays++;
          
          // Update max streak if needed
          if (newStreakDays > newMaxStreak) {
            newMaxStreak = newStreakDays;
          }
        }
        // If same day, streak doesn't increment (already counted for this day)
      } else {
        // First passed exam ever (or streak was reset) - start streak at 1
        newStreakDays = 1;
        if (newMaxStreak == 0) {
          newMaxStreak = 1;
        }
      }
    }

    final updatedStreak = StreakData(
      streakDays: newStreakDays,
      lastExamDate: _toChileanTimeAsDateTime(now),
      totalExams: workingStreak.totalExams + (passedThreshold ? 1 : 0), // Only count passed exams
      maxStreakDays: newMaxStreak,
      dailyExamsPassed: newDailyExamsPassed,
      lastDailyResetDate: workingStreak.lastDailyResetDate,
      lastPassedExamDate: newLastPassedExamDate,
    );

    final updatedGlobalStreak = GlobalStreakData(
      lives: updatedLives,
    );

    await saveStreakData(updatedStreak);
    await saveGlobalStreakData(updatedGlobalStreak);
    
    // Immediately sync to Firebase to prevent data loss on refresh
    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String userName = prefsUser.getString('userName') ?? "Unknown";
      
      // Use batch update for consistency
      await _batchUpdateFirebase(userName);
    } catch (e) {
      print("Error syncing streak update to Firebase: $e");
    }
  }

  static Future<GlobalStreakData> _rechargeGlobalLivesIfNeeded(GlobalStreakData globalStreak) async {
    final now = tz.TZDateTime.now(tz.local);
    final List<LifeData> updatedLives = [];
    
    // Ensure we always have exactly 3 lives total
    final livesToProcess = globalStreak.lives.length >= 3 
        ? globalStreak.lives.sublist(0, 3) 
        : [...globalStreak.lives, ...List.generate(3 - globalStreak.lives.length, (_) => LifeData(isAvailable: true))];
    
    for (final life in livesToProcess) {
      if (life.isAvailable) {
        // Life is already available, keep it as is
        updatedLives.add(life);
      } else if (life.rechargeTime != null) {
        // Check if recharge time has passed (8-hour recharge in Chilean time)
        final nowAsDateTime = _toChileanTimeAsDateTime(now);
        if (nowAsDateTime.isAfter(life.rechargeTime!) || nowAsDateTime.isAtSameMomentAs(life.rechargeTime!)) {
          // Recharge this life
          updatedLives.add(LifeData(isAvailable: true));
        } else {
          // Still recharging, keep current state
          updatedLives.add(life);
        }
      } else {
        // No recharge time set, make available
        updatedLives.add(LifeData(isAvailable: true));
      }
    }
    
    // Safety check: ensure we never have more than 3 lives
    if (updatedLives.length > 3) {
      updatedLives.removeRange(3, updatedLives.length);
    }
    
    return GlobalStreakData(lives: updatedLives);
  }

  static Future<void> saveExamResult(ExamResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final examHistoryList = prefs.getString(_examHistoryKey) ?? '[]';
    final List<dynamic> history = json.decode(examHistoryList);
    
    // Check for duplicate exam IDs to prevent duplicates
    final hasDuplicate = history.any((exam) => exam['id'] == result.id);
    if (!hasDuplicate) {
      history.add(result.toJson());
    }
    
    // Keep only last 50 exams to avoid storage issues
    if (history.length > 50) {
      history.removeAt(0);
    }
    
    await prefs.setString(_examHistoryKey, json.encode(history));

    // Save user summary to Firebase
    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String userName = prefsUser.getString('userName') ?? "Unknown";
      
      // Get or create user document
      var userDoc = await FirebaseFirestore.instance
          .collection('user_summaries')
          .doc(userName)
          .get();
      
      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      }
      
      // Save exam history to Firebase
      List<dynamic> firebaseHistory = userData['examHistory'] as List<dynamic>? ?? [];
      
      // Check for duplicate exam IDs to prevent duplicates in Firebase
      final hasFirebaseDuplicate = firebaseHistory.any((exam) => exam['id'] == result.id);
      if (!hasFirebaseDuplicate) {
        firebaseHistory.add(result.toJson());
        // Only increment exam count if it's not a duplicate
        userData['totalExams'] = (userData['totalExams'] as int? ?? 0) + 1;
      }
      
      // Keep only last 50 exams in Firebase as well
      if (firebaseHistory.length > 50) {
        firebaseHistory.removeAt(0);
      }
      
      userData['examHistory'] = firebaseHistory;
      
      // Sync global streak data for any exam mode to ensure Firebase consistency
      final streakData = await getStreakData();
      if (streakData != null) {
        userData['globalStreak'] = streakData.toJson();
        // Also store explicit current_streak and max_streak for direct access
        userData['current_streak'] = streakData.streakDays;
        userData['max_streak'] = streakData.maxStreakDays;
      }
      
      // Also sync global lives for any exam mode
      final globalStreak = await getGlobalStreakData();
      userData['globalLives'] = globalStreak.availableLives;
      userData['livesData'] = globalStreak.lives.map((life) => life.toJson()).toList();
      
      userData['lastUpdated'] = FieldValue.serverTimestamp();
      
      // Use batch update for consistency
      await _batchUpdateFirebase(userName);
    } catch (e) {
      // Firebase save failure shouldn't block local storage
      print("Error saving user summary to Firebase: $e");
    }
  }

  static Future<void> loadFromFirebase() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('userName');
      
      if (userName == null) return;
      
      var userDoc = await FirebaseFirestore.instance
          .collection('user_summaries')
          .doc(userName)
          .get();
      
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        
        // Validate Firebase data before applying
        if (!_validateFirebaseData(userData)) {
          print("Invalid Firebase data detected, skipping load");
          return;
        }
        
        // Load exam history from Firebase
        if (userData.containsKey('examHistory')) {
          final firebaseHistory = userData['examHistory'] as List<dynamic>;
          await prefs.setString(_examHistoryKey, json.encode(firebaseHistory));
        }
        
        // Load global lives
        if (userData.containsKey('livesData')) {
          final livesDataJson = userData['livesData'] as List<dynamic>;
          final List<LifeData> lives = livesDataJson
              .map((lifeJson) => LifeData.fromJson(lifeJson as Map<String, dynamic>))
              .toList();
          
          final globalStreak = GlobalStreakData(lives: lives);
          await saveGlobalStreakData(globalStreak);
        } else if (userData.containsKey('globalLives')) {
          // Legacy support for old format
          final globalLives = userData['globalLives'] as int;
          final List<LifeData> lives = List.generate(
            globalLives,
            (_) => LifeData(isAvailable: true),
          );
          // Fill remaining lives as unavailable if count < 3
          while (lives.length < 3) {
            lives.add(LifeData(isAvailable: false, rechargeTime: _toChileanTimeAsDateTime(DateTime.now().add(const Duration(hours: 8)))));
          }
          
          final globalStreak = GlobalStreakData(lives: lives);
          await saveGlobalStreakData(globalStreak);
        }
        
        // Load global streak data
        StreakData? loadedStreakData;
        if (userData.containsKey('globalStreak')) {
          final streakInfo = userData['globalStreak'] as Map<String, dynamic>;
          loadedStreakData = StreakData.fromJson(streakInfo);
          await saveStreakData(loadedStreakData);
        }
        
        // Also load explicit current_streak and max_streak if available (for direct access)
        if (userData.containsKey('current_streak') || userData.containsKey('max_streak')) {
          final currentStreak = userData['current_streak'] as int? ?? 0;
          final maxStreak = userData['max_streak'] as int? ?? 0;
          
          // Use the loaded streak data or get existing data
          final existingStreak = loadedStreakData ?? await getStreakData();
          if (existingStreak != null) {
            // Only use Firebase explicit values if they're different from existing values
            if (currentStreak != existingStreak.streakDays || maxStreak != existingStreak.maxStreakDays) {
              final updatedStreak = StreakData(
                streakDays: currentStreak > 0 ? currentStreak : existingStreak.streakDays,
                lastExamDate: existingStreak.lastExamDate,
                totalExams: existingStreak.totalExams,
                maxStreakDays: maxStreak > 0 ? maxStreak : existingStreak.maxStreakDays,
                dailyExamsPassed: existingStreak.dailyExamsPassed,
                lastDailyResetDate: existingStreak.lastDailyResetDate,
                lastPassedExamDate: existingStreak.lastPassedExamDate,
              );
              await saveStreakData(updatedStreak);
            }
          }
        }
        
        // Load study progress for each subject
        if (userData.containsKey('studyProgress')) {
          try {
            final studyProgress = userData['studyProgress'] as Map<String, dynamic>;
            final allProgressStr = prefs.getString(_partialProgressKey) ?? '{}';
            final Map<String, dynamic> allProgress = json.decode(allProgressStr);
            
            for (var entry in studyProgress.entries) {
              allProgress[entry.key] = entry.value;
            }
            
            await prefs.setString(_partialProgressKey, json.encode(allProgress));
          } catch (e) {
            print("Error loading study progress from Firebase: $e");
          }
        }
      }
    } catch (e) {
      print("Error loading from Firebase: $e");
    }
  }

  static Future<List<ExamResult>> getExamHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final examHistoryList = prefs.getString(_examHistoryKey) ?? '[]';
    final List<dynamic> history = json.decode(examHistoryList);
    
    return history.map((json) => ExamResult.fromJson(json as Map<String, dynamic>)).toList();
  }

  static Future<Map<String, int>> getMistakeFrequency() async {
    final history = await getExamHistory();
    Map<String, int> mistakeCount = {};
    
    for (var exam in history) {
      for (var answer in exam.incorrectAnswers) {
        final questionText = answer['question'] as String;
        mistakeCount[questionText] = (mistakeCount[questionText] ?? 0) + 1;
      }
    }
    
    return mistakeCount;
  }

  static Future<bool> hasShownStreakOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_streakOnboardingShown) ?? false;
  }

  static Future<void> setStreakOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_streakOnboardingShown, true);
  }

  static Future<void> savePartialProgress(PartialExamProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final allProgressStr = prefs.getString(_partialProgressKey) ?? '{}';
    final Map<String, dynamic> allProgress = json.decode(allProgressStr);
    
    // Save progress for this specific subject
    allProgress[progress.subject] = progress.toJson();
    
    await prefs.setString(_partialProgressKey, json.encode(allProgress));
    
    // Also sync to Firebase
    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String userName = prefsUser.getString('userName') ?? "Unknown";
      
      var userDoc = await FirebaseFirestore.instance
          .collection('user_summaries')
          .doc(userName)
          .get();
      
      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      }
      
      Map<String, dynamic> studyProgress = userData['studyProgress'] as Map<String, dynamic>? ?? {};
      studyProgress[progress.subject] = progress.toJson();
      userData['studyProgress'] = studyProgress;
      
      // Also sync current streak data
      final streakData = await getStreakData();
      if (streakData != null) {
        userData['current_streak'] = streakData.streakDays;
        userData['max_streak'] = streakData.maxStreakDays;
        userData['globalStreak'] = streakData.toJson();
      }
      
      userData['lastUpdated'] = FieldValue.serverTimestamp();
      
      // Use batch update for consistency
      await _batchUpdateFirebase(userName);
    } catch (e) {
      print("Error saving study progress to Firebase: $e");
    }
  }

  static Future<PartialExamProgress?> getPartialProgress(String subject) async {
    final prefs = await SharedPreferences.getInstance();
    final allProgressStr = prefs.getString(_partialProgressKey);
    
    if (allProgressStr != null) {
      final Map<String, dynamic> allProgress = json.decode(allProgressStr);
      if (allProgress.containsKey(subject)) {
        return PartialExamProgress.fromJson(allProgress[subject] as Map<String, dynamic>);
      }
    }
    return null;
  }

  static Future<Map<String, PartialExamProgress>> getAllPartialProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final allProgressStr = prefs.getString(_partialProgressKey) ?? '{}';
    final Map<String, dynamic> allProgress = json.decode(allProgressStr);
    
    Map<String, PartialExamProgress> result = {};
    for (var entry in allProgress.entries) {
      result[entry.key] = PartialExamProgress.fromJson(entry.value as Map<String, dynamic>);
    }
    return result;
  }

  static Future<Map<String, PartialExamProgress>> getPracticeModeProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final allProgressStr = prefs.getString(_partialProgressKey) ?? '{}';
    final Map<String, dynamic> allProgress = json.decode(allProgressStr);
    
    Map<String, PartialExamProgress> result = {};
    for (var entry in allProgress.entries) {
      final progress = PartialExamProgress.fromJson(entry.value as Map<String, dynamic>);
      // Only include practice mode progress
      if (progress.mode == 'practice') {
        result[entry.key] = progress;
      }
    }
    return result;
  }

  static Future<void> clearPartialProgress(String subject, {String? mode}) async {
    final prefs = await SharedPreferences.getInstance();
    final allProgressStr = prefs.getString(_partialProgressKey) ?? '{}';
    final Map<String, dynamic> allProgress = json.decode(allProgressStr);
    
    // Only clear progress if mode matches or if no mode specified (backward compatibility)
    if (mode != null) {
      if (allProgress.containsKey(subject)) {
        final progressData = allProgress[subject] as Map<String, dynamic>;
        final progressMode = progressData['mode'] as String?;
        // Only clear if the mode matches
        if (progressMode == mode) {
          allProgress.remove(subject);
        }
      }
    } else {
      // Backward compatibility: clear all progress for subject if no mode specified
      allProgress.remove(subject);
    }
    
    await prefs.setString(_partialProgressKey, json.encode(allProgress));
    
    // Also sync to Firebase
    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();
      String userName = prefsUser.getString('userName') ?? "Unknown";
      
      var userDoc = await FirebaseFirestore.instance
          .collection('user_summaries')
          .doc(userName)
          .get();
      
      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      }
      
      Map<String, dynamic> studyProgress = userData['studyProgress'] as Map<String, dynamic>? ?? {};
      
      // Only remove from Firebase if mode matches or if no mode specified
      if (mode != null) {
        if (studyProgress.containsKey(subject)) {
          final progressData = studyProgress[subject] as Map<String, dynamic>;
          final progressMode = progressData['mode'] as String?;
          if (progressMode == mode) {
            studyProgress.remove(subject);
          }
        }
      } else {
        studyProgress.remove(subject);
      }
      
      userData['studyProgress'] = studyProgress;
      
      // Also sync current streak data
      final streakData = await getStreakData();
      if (streakData != null) {
        userData['current_streak'] = streakData.streakDays;
        userData['max_streak'] = streakData.maxStreakDays;
        userData['globalStreak'] = streakData.toJson();
      }
      
      userData['lastUpdated'] = FieldValue.serverTimestamp();
      
      // Use batch update for consistency
      await _batchUpdateFirebase(userName);
    } catch (e) {
      print("Error clearing study progress from Firebase: $e");
    }
  }

  // Anti-cheat: Check for rage quit in Streak Mode
  static Future<void> checkForRageQuit() async {
    try {
      final allProgress = await getAllPartialProgress();
      
      for (var entry in allProgress.entries) {
        final progress = entry.value;
        
        // Only check streak mode progress
        if (progress.mode == 'streak' && progress.reachedFiftyPercent) {
          // User reached 50% but didn't finish - treat as failure
          print("Rage quit detected in Streak Mode for ${progress.subject}. Deducting a life.");
          
          // Deduct a life
          final globalStreak = await getGlobalStreakData();
          final now = tz.TZDateTime.now(tz.local);
          List<LifeData> updatedLives = List.from(globalStreak.lives);
          
          // Find first available life and mark it as unavailable
          for (int i = 0; i < updatedLives.length; i++) {
            if (updatedLives[i].isAvailable) {
              final rechargeTime = _toChileanTimeAsDateTime(now.add(const Duration(hours: 8)));
              updatedLives[i] = LifeData(
                isAvailable: false,
                rechargeTime: rechargeTime,
              );
              break;
            }
          }
          
          final updatedGlobalStreak = GlobalStreakData(lives: updatedLives);
          await saveGlobalStreakData(updatedGlobalStreak);
          
          // Clear the partial progress to prevent repeated deductions (only for streak mode)
          await clearPartialProgress(progress.subject, mode: 'streak');
          
          // Sync to Firebase with explicit streak values
          try {
            SharedPreferences prefsUser = await SharedPreferences.getInstance();
            String userName = prefsUser.getString('userName') ?? "Unknown";
            
            var userDoc = await FirebaseFirestore.instance
                .collection('user_summaries')
                .doc(userName)
                .get();
            
            Map<String, dynamic> userData = {};
            if (userDoc.exists) {
              userData = userDoc.data() as Map<String, dynamic>;
            }
            
            // Also sync current streak data
            final streakData = await getStreakData();
            if (streakData != null) {
              userData['current_streak'] = streakData.streakDays;
              userData['max_streak'] = streakData.maxStreakDays;
              userData['globalStreak'] = streakData.toJson();
            }
            
            userData['globalLives'] = updatedGlobalStreak.availableLives;
            userData['livesData'] = updatedGlobalStreak.lives.map((life) => life.toJson()).toList();
            userData['lastUpdated'] = FieldValue.serverTimestamp();
            
            // Use batch update for consistency
            await _batchUpdateFirebase(userName);
          } catch (e) {
            print("Error syncing rage quit penalty to Firebase: $e");
          }
        }
      }
    } catch (e) {
      print("Error checking for rage quit: $e");
    }
  }
}

// =============================================================
// CONFIGURACIÓN DE STREAK MODE
// =============================================================

class StreakConfig {
  static const Map<String, int> questionsPerSubject = {
    'AERODINÁMICA': 7,
    'PERFORMANCE Y MOTORES': 7,
    'OPERACIONES DE VUELO': 7,
    'PESO Y BALANCE': 7,
    'METEOROLOGÍA': 10,
    'REGLAMENTACIÓN': 7,
  };

  static const int timePerQuestionSeconds = 120; // 2 minutes per question

  static int getQuestionsForSubject(String subject) {
    return questionsPerSubject[subject] ?? 7;
  }

  static int getTotalTimeForSubject(String subject) {
    return getQuestionsForSubject(subject) * timePerQuestionSeconds;
  }
}

// =============================================================
// LÓGICA DE LA APLICACIÓN
// =============================================================

// Colores consistentes para modo oscuro
class AppColors {
  static const Color darkBackground = Color(0xFF0F172A); // Azul oscuro unificado
  static const Color darkAppBar = Color(0xFF1E293B); // Azul ligeramente más claro para AppBar
  static const Color darkCard = Color(0xFF1E293B); // Color consistente para tarjetas
  static const Color darkText = Color(0xFFE2E8F0); // Texto claro con buen contraste
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Texto secundario
  
  // Colores mejorados para modo claro
  static const Color lightBackground = Color(0xFFF8FAFC); // Gris azulado muy claro
  static const Color lightCard = Color(0xFFFFFFFF); // Blanco puro para tarjetas
  static const Color lightText = Color(0xFF0F172A); // Texto oscuro con alto contraste
  static const Color lightTextSecondary = Color(0xFF475569); // Texto secundario
}

// Notificador global para el tema. Inicia con la configuración del sistema.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .timeout(const Duration(seconds: 10));
    
    // Initialize timezone data
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Santiago'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userName = prefs.getString('userName') ?? "";
    
    // Check for streak reset and life recharge based on time (00:00 AM Chilean time)
    if (isLoggedIn) {
      await StorageService.checkAndResetStreakIfNeeded();
      await StorageService.checkAndRechargeLivesIfNeeded();
    }
    
    // --- NUEVA LÓGICA: ¿Es la primera vez que abre la app? ---
    bool esPrimeraVez = prefs.getBool('esPrimeraVez') ?? true;

    Widget pantallaInicial;
    if (esPrimeraVez) {
      pantallaInicial = const PantallaPrimeraVez();
    } else if (isLoggedIn) {
      pantallaInicial = WelcomeScreen(nombre: userName, themeNotifier: themeNotifier);
    } else {
      pantallaInicial = MiPantallaLogin(themeNotifier: themeNotifier);
    }

    runApp(QuizApp(startWidget: pantallaInicial));
  } catch (e) {
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error al iniciar: Verifica tu conexión")),
      ),
    ));
  }
}

class PantallaPrimeraVez extends StatefulWidget {
  const PantallaPrimeraVez({super.key});

  @override
  State<PantallaPrimeraVez> createState() => _PantallaPrimeraVezState();
}

class _PantallaPrimeraVezState extends State<PantallaPrimeraVez> {
  Future<void> _comenzar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('esPrimeraVez', false); // Marcamos que ya entró
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => MiPantallaLogin(themeNotifier: themeNotifier),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para que la imagen sea grande pero proporcional
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // CAPA 1: La imagen (Aumenta el 0.7 para hacerla más grande)
          Positioned(
            top: -300,
            left: 0,
            right: 0,
            height: screenHeight * 1.4, 
            child: Image.asset(
              'assets/imagen_bienvenida.png',
              filterQuality: FilterQuality.high, // Mantenemos tu asset
              fit: BoxFit.contain,
            ),
          ),

          // CAPA 2: El texto y botón (Fijos abajo)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                const Text(
                  "Bienvenido a la APP EOV", // Tu frase
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Una herramienta creada para acompañarte en cada etapa de tu formación como EOV.", // Tu frase motivadora
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _comenzar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0091D5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Comenzar", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
                      

class QuizApp extends StatelessWidget {
  final Widget startWidget;
  const QuizApp({super.key, required this.startWidget}); // 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: currentMode, // <--- Ahora usa el valor de nuestro Notifier
          
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppColors.lightBackground,
            cardColor: AppColors.lightCard,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: AppColors.lightText),
              bodyMedium: TextStyle(color: AppColors.lightText),
              bodySmall: TextStyle(color: AppColors.lightTextSecondary),
              titleLarge: TextStyle(color: AppColors.lightText),
              titleMedium: TextStyle(color: AppColors.lightText),
              titleSmall: TextStyle(color: AppColors.lightText),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: AppColors.darkBackground,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkAppBar,
              foregroundColor: AppColors.darkText,
              elevation: 2,
            ),
            cardColor: AppColors.darkCard,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: AppColors.darkText),
              bodyMedium: TextStyle(color: AppColors.darkText),
              bodySmall: TextStyle(color: AppColors.darkTextSecondary),
              titleLarge: TextStyle(color: AppColors.darkText),
              titleMedium: TextStyle(color: AppColors.darkText),
              titleSmall: TextStyle(color: AppColors.darkText),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          home: startWidget,
        );
      },
    );
  }
}
// 2. PANTALLA DE BIENVENIDA (ESTILO WINDOWS)

String formatearNombreDesdeCorreo(String correo) {
  // 1. Obtener la parte antes del primer punto o la arroba
  String partePrincipal = correo.split('.').first;
  
  // 2. Por si el correo no tiene punto (ej: usuario@gmail.com)
  if (!correo.contains('.')) {
    partePrincipal = correo.split('@').first;
  }

  // 3. Poner la primera letra en mayúscula y el resto en minúscula
  if (partePrincipal.isEmpty) return "Usuario";
  return partePrincipal[0].toUpperCase() + partePrincipal.substring(1).toLowerCase();
}

class WelcomeScreen extends StatefulWidget {
  final String nombre;
  final ValueNotifier<ThemeMode> themeNotifier;
  const WelcomeScreen({super.key, required this.nombre, required this.themeNotifier});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 seconds animation duration
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    
    _controller.forward();
    
    _validarYContinuar();
    StorageService.loadFromFirebase(); // Load streak data from Firebase
    StorageService.checkForRageQuit(); // Check for rage quit (anti-cheat)
    StorageService.checkAndRechargeLivesIfNeeded(); // Check and recharge lives based on time
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _validarYContinuar() async {
    // Wait for animation to complete (5 seconds + 5ms to give users time to read the disclaimer)
    await Future.delayed(const Duration(milliseconds: 5005));
    
    try {
      var query = await FirebaseFirestore.instance
          .collection('Códigos_válidos')
          .where('correo', isEqualTo: widget.nombre.toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        var userData = query.docs.first.data();
        bool estaHabilitado = userData['habilitado'] ?? true;

        if (!estaHabilitado) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
          await prefs.remove('userName');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tu acceso ha sido revocado. Comunícate con la administración."),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MiPantallaLogin(themeNotifier: widget.themeNotifier)),
            );
          }
          return; // Detenemos la función para que no avance al MainMenu
        }
      }
    } catch (e) {
      // Si no hay internet, ignoramos el error para no dejar la app pegada.
    }

    // Si está habilitado (o falló la red), lo dejamos pasar al menú principal
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu(themeNotifier: themeNotifier)), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombreUsuario = formatearNombreDesdeCorreo(widget.nombre);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated plane icon
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 0.2,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.flight,
                      color: Colors.lightBlue,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Animated greeting text
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      );
                    },
                    child: Text(
                      "¡Hola, $nombreUsuario!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Animated welcome text
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value * 0.8,
                        child: child,
                      );
                    },
                    child: const Text(
                      "Bienvenido de nuevo",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Disclaimer text
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value * 0.7,
                        child: child,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.lightBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Recuerda que el criterio de evaluacion de los examenes son en base al banco de preguntas directo de la DGAC - EOV (2021)",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Animated loading indicator
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(_fadeAnimation.value),
                          ),
                          strokeWidth: 3,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> cerrarSesion(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.remove('userName');

  // 2. Redirigir al Login
  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MiPantallaLogin(themeNotifier: themeNotifier)),
    );
  }
}

// 3. PANTALLA DE LOGIN
class MiPantallaLogin extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const MiPantallaLogin({super.key, required this.themeNotifier});

  @override
  State<MiPantallaLogin> createState() => _MiPantallaLoginState();
}

class _MiPantallaLoginState extends State<MiPantallaLogin> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  
  // Color azul del fondo de la imagen
  final Color azulFondo = const Color.fromARGB(255, 34, 70, 110);
  bool _cargando = false;
  bool _recordarme = false;
  
  Future<Map<String, String>> _obtenerInfoDispositivo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String idHardware = "desconocido";
  String nombre = "Dispositivo";

  if (kIsWeb) {
    var webInfo = await deviceInfo.webBrowserInfo;
    idHardware = "web_${webInfo.userAgent.hashCode}";
    nombre = "Web: ${webInfo.browserName.name} (${webInfo.platform})";
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    idHardware = androidInfo.id; // ID único permanente del hardware
    nombre = "${androidInfo.brand} ${androidInfo.model}";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    idHardware = iosInfo.identifierForVendor ?? "ios_unknown";
    nombre = iosInfo.name;
  }

  return {'id': idHardware, 'nombre': nombre};
}
  
  Future<void> ingresarApp() async {
  if (_cargando) return;
  String nombre = _nombreController.text.trim();
  String codigo = _codigoController.text.trim();

  if (nombre.isEmpty || codigo.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Debes poner correo y código")),
    );
    return;
  }

  setState(() => _cargando = true);

  try {
    Map<String, String> infoDisp = await _obtenerInfoDispositivo();
    String miIdDispositivo = infoDisp['id']!;
    String miNombreDispositivo = infoDisp['nombre']!;

    var docSnap = await FirebaseFirestore.instance
        .collection("Códigos_válidos")
        .doc(codigo)
        .get()
        .timeout(const Duration(seconds: 10));

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;

      // --- 1. VERIFICACIÓN DE REVOCACIÓN ---
      bool estaHabilitado = data['habilitado'] ?? true;
      if (!estaHabilitado) {
        throw ("Tu acceso ha sido revocado. Comunícate con la administración.");
      }

      bool enUso = data['en_uso'] ?? false;
      String? usuarioAsignado = data['quien entro'];
      List<dynamic> dispositivosActivos = List.from(data['dispositivos_activos'] ?? []);

      if (enUso && usuarioAsignado != nombre) {
        throw ("Este código ya está vinculado a otro usuario.");
      }

      // --- 2. LÍMITE DE DISPOSITIVOS ---
      if (!dispositivosActivos.contains(miIdDispositivo)) {
        // Si entra aquí, es porque es un dispositivo NUEVO que no está en la base de datos.
        
        if (dispositivosActivos.length >= 2) {
          // Si ya hay 2 dispositivos registrados y este es distinto, lo bloqueamos.
          throw ("Has iniciado sesión en demasiados dispositivos. Límite máximo: 2.");
        }
        
        // Si hay espacio (< 2), agregamos el nuevo dispositivo a la lista.
        dispositivosActivos.add(miIdDispositivo);
      }

      // --- 3. VERIFICACIÓN DE OTROS CÓDIGOS ---
      var usuarioQuery = await FirebaseFirestore.instance
          .collection("Códigos_válidos")
          .where("quien entro", isEqualTo: nombre)
          .get();

      if (usuarioQuery.docs.isNotEmpty) {
        if (usuarioQuery.docs.first.id != codigo) {
          throw ("Ya tienes un código asignado. Debes usar el código original.");
        }
      }

      // --- 4. ACTUALIZACIÓN EN FIREBASE ---
      await docSnap.reference.update({
        'en_uso': true,
        'quien entro': nombre,
        'fecha_uso': FieldValue.serverTimestamp(),
        'dispositivos_activos': dispositivosActivos,
        'ultimo_dispositivo_usado': miNombreDispositivo,
      });

      // --- 5. NAVEGACIÓN Y SESIÓN ---
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_recordarme) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userName', nombre);
      } else {
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('userName');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen(nombre: nombre, themeNotifier: widget.themeNotifier)),
        );
      }
    } else {
      throw ("El código no existe.");
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  } finally {
    if (mounted) setState(() => _cargando = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Responsive dimensions
    final logoWidth = screenWidth < 360 ? screenWidth * 0.85 : 360.0;
    final logoHeight = screenWidth < 360 ? 100.0 : 120.0;
    final logoTopPadding = screenHeight < 600 ? 40.0 : 70.0;
    final loginWidth = screenWidth < 400 ? screenWidth * 0.9 : 400.0;
    final loginPadding = screenWidth < 360 ? 20.0 : 35.0;
    final titleFontSize = screenWidth < 360 ? 24.0 : 32.0;
    final spacingBelowLogo = screenHeight < 600 ? 200.0 : 280.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A1128), // Fondo azul oscuro
      body: Stack(
        children: [
          // 1. LOGO: Independiente, sin empujar al login
          Positioned(
            top: logoTopPadding, // Ajusta este valor para subir/bajar el logo
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 2000), // 1 segundo para una entrada suave
              curve: Curves.easeOutQuad,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value, // Aparece de transparente a visible
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)), // Se desliza 20px hacia arriba mientras aparece
                    child: child,
                  ),
                );
              },
            child: Center( // Usamos Center para que el contenedor se ajuste al contenido
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25), // Bordes redondeados para el efecto
                child: BackdropFilter(
                  
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Desenfoca lo que está detrás
                  child: Container(
                    width: logoWidth, 
                    height: logoHeight,
                    
                    padding: EdgeInsets.all(screenWidth < 360 ? 15.0 : 20.0), // Espacio entre el logo y el borde
                    decoration: BoxDecoration(
  
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color.fromARGB(255, 219, 178, 42).withOpacity(0.2), // Luz brillante arriba a la izquierda
                          const Color.fromARGB(255, 40, 85, 87).withOpacity(0.05), // Sombra suave abajo a la derecha
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      // 2. Borde con un poco más de fuerza para que resalte
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4), 
                        width: 1.5,
                      ),
                      // 3. EFECTO DE LUZ NOCTURNA (Glow)
                      // Esto proyecta una luz difusa detrás del logo, creando el efecto de "luz en la noche"
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3), // Color azul para esa vibra nocturna
                          blurRadius: 30, // Qué tan extendida es la luz
                          spreadRadius: 5, // Qué tan lejos llega el resplandor
                          offset: const Offset(0, 0), // Centrado para que la luz sea uniforme
                        ),
                      ],
                    ),
            child: Image.asset(
              'assets/PRECADET_LOGO.png',
              height: screenWidth < 360 ? 80.0 : 100.0,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
                ),
                ),
                ),
                ),
                
          ),
          // 2. LOGIN: El bloque de cristal
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 50.0, end: 0.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: 1 - (value / 50),
                  child: child,
                ),
              );
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- AJUSTA ESTE VALOR PARA SUBIR O BAJAR ---
                    // Un valor más bajo (ej. 200) acercará el login al logo
                    SizedBox(height: spacingBelowLogo), 
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: loginWidth,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 15.0 : 20.0),
                          padding: EdgeInsets.all(loginPadding),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Iniciar sesión",
                                style: GoogleFonts.inter(
                                  fontSize: titleFontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: screenWidth < 360 ? 20.0 : 30.0),
                              _buildTextField(
                                controller: _nombreController,
                                hint: "Tu correo institucional",
                                icon: Icons.mail_outline,
                                isEmail: true,
                              ),
                              SizedBox(height: screenWidth < 360 ? 15.0 : 20.0),
                              _buildTextField(
                                controller: _codigoController,
                                hint: "Código",
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                              SizedBox(height: screenWidth < 360 ? 15.0 : 20.0),
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(unselectedWidgetColor: Colors.white70),
                                    child: Checkbox(
                                      value: _recordarme,
                                      activeColor: const Color(0xFF0091D5),
                                      onChanged: (val) {
                                        setState(() => _recordarme = val ?? false);
                                      },
                                    ),
                                  ),
                                  const Text("Recuérdame", style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                              SizedBox(height: screenWidth < 360 ? 20.0 : 30.0),
                              SizedBox(
                                width: double.infinity,
                                height: screenWidth < 360 ? 50.0 : 55.0,
                                child: ElevatedButton(
                                  onPressed: ingresarApp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0091D5),
                                    foregroundColor: Colors.white,
                                    elevation: 10,
                                    shadowColor: const Color(0xFF0091D5).withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _cargando
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para los campos de texto con iconos
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isEmail = false,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Fondo sutil del input
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(color: Colors.white), // Texto escrito en blanco
              keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
              textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.sentences,
              inputFormatters: isEmail 
              ? [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toLowerCase());
                  }),
                ] 
              : null,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white38),
              ),
            )
          )
        ],
      ),
    );
  }

}

// 4. PANTALLA INSTRUCTIVO
class PantallaInstructivo extends StatefulWidget {
  const PantallaInstructivo({super.key});

  @override
  State<PantallaInstructivo> createState() => _PantallaInstructivoState();
}

class _PantallaInstructivoState extends State<PantallaInstructivo> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    if (!kIsWeb) {
      try {
        final ByteData data = await rootBundle.load('assets/Instructivo.pdf');
        final bytes = data.buffer.asUint8List();
        final Directory tempDir = await getTemporaryDirectory();
        final File tempFile = File('${tempDir.path}/Instructivo.pdf');
        await tempFile.writeAsBytes(bytes);
        setState(() {
          _localPath = tempFile.path;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error cargando PDF: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // En web, usar el PDF del folder web
      return Scaffold(
        appBar: AppBar(title: const Text("Instructivo de Examen")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text("Instructivo de Examen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Haz clic para ver el PDF"),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await launchUrl(Uri.parse('/Instructivo.pdf'), mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text("Abrir PDF"),
              ),
            ],
          ),
        ),
      );
    } else {
      // En móvil, usar flutter_pdfview para mostrar preview
      if (_localPath == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("Instructivo de Examen")),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        appBar: AppBar(title: const Text("Instructivo de Examen")),
        body: PDFView(
          filePath: _localPath!,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al cargar PDF: $error"), backgroundColor: Colors.red),
            );
          },
          onPageError: (page, error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error en página $page: $error"), backgroundColor: Colors.red),
            );
          },
        ),
      );
    }
  }
}

// 4. MENÚ PRINCIPAL 
class MainMenu extends StatefulWidget {
  
  final List<Map<String, dynamic>> materias = [
    {'nombre': 'AERODINÁMICA', 'Imagen': "assets/AERODINAMICA_SIN_FONDO.png", 'pool': poolAerodinamica, 'limite': 16}, 
    {'nombre': 'PERFORMANCE Y MOTORES', 'Imagen': "assets/PERFORMANCE_Y_MOTORES_SIN_FONDO.png", 'pool': poolperformanceymotores, 'limite': 16},
    {'nombre': 'OPERACIONES DE VUELO', 'Imagen': "assets/OPERACIONES_DE_VUELO_SIN_FONDO.png", 'pool': pooloperacionesdevuelo, 'limite': 16},
    {'nombre': 'PESO Y BALANCE', 'Imagen': "assets/PESO_Y_BALANCE_SIN_FONDO.png", 'pool': poolpesoybalance, 'limite': 16},
    {'nombre': 'METEOROLOGÍA', 'Imagen': "assets/METEO_SIN_FONDO.png", 'pool': poolmeteorologia, 'limite': 25},
    {'nombre': 'REGLAMENTACIÓN', 'Imagen': "assets/REGLAMENTACION_SIN_FONDO.png", 'pool': poolreglamentacion, 'limite': 25},
  ];

  final ValueNotifier<ThemeMode> themeNotifier;

  MainMenu({super.key, required this.themeNotifier});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  StreakData? _globalStreakData;
  List<ExamResult> _examHistory = [];
  Map<String, PartialExamProgress> _allPartialProgress = {};
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change (e.g., when returning to this screen)
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    final streakData = await StorageService.getStreakData();
    final history = await StorageService.getExamHistory();
    final allPartialProgress = await StorageService.getPracticeModeProgress(); // Only load practice mode progress
    final prefs = await SharedPreferences.getInstance();
    final rawUserName = prefs.getString('userName') ?? '';

    if (mounted) {
      setState(() {
        _globalStreakData = streakData;
        _examHistory = history;
        _allPartialProgress = allPartialProgress;
        _userName = rawUserName.isNotEmpty ? formatearNombreDesdeCorreo(rawUserName) : 'Usuario';
      });
    }
  }

  // --- Datos derivados para "Continuar estudiando" y el resumen inferior. ---
  // Se calculan sobre _examHistory (ya cargado desde StorageService.getExamHistory,
  // sin persistencia nueva) y _streakData (ya cargado). No se inventa ningún dato.

  ExamResult? get _ultimoResultado {
    if (_examHistory.isEmpty) return null;
    return _examHistory.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }

  // Get the most recent partial progress from all subjects
  PartialExamProgress? get _mostRecentPartialProgress {
    if (_allPartialProgress.isEmpty) return null;
    
    PartialExamProgress? mostRecent;
    for (var progress in _allPartialProgress.values) {
      if (mostRecent == null || progress.date.isAfter(mostRecent.date)) {
        mostRecent = progress;
      }
    }
    return mostRecent;
  }

  // Get the most recent subject (from either completed exam or partial progress)
  String? get _ultimaMateria {
    final ultimoExamen = _ultimoResultado?.subject;
    final progresoParcial = _mostRecentPartialProgress?.subject;
    
    if (ultimoExamen == null && progresoParcial == null) return null;
    
    // Compare dates to determine which is more recent
    final ultimoExamenDate = _ultimoResultado?.date;
    final progresoParcialDate = _mostRecentPartialProgress?.date;
    
    if (ultimoExamenDate == null && progresoParcialDate == null) return ultimoExamen;
    if (ultimoExamenDate == null) return progresoParcial;
    if (progresoParcialDate == null) return ultimoExamen;
    
    return ultimoExamenDate.isAfter(progresoParcialDate) ? ultimoExamen : progresoParcial;
  }

  // Get the completion percentage for the most recent activity
  double? get _ultimoProgresoPct {
    final ultimoExamenDate = _ultimoResultado?.date;
    final progresoParcialDate = _mostRecentPartialProgress?.date;
    
    if (ultimoExamenDate == null && progresoParcialDate == null) return null;
    if (ultimoExamenDate == null) return _mostRecentPartialProgress?.completionPercentage ?? 0.0;
    if (progresoParcialDate == null) {
      // For completed exams, return the score percentage
      final ultimo = _ultimoResultado;
      if (ultimo != null && ultimo.totalQuestions > 0) {
        return (ultimo.score / ultimo.totalQuestions) * 100;
      }
      return null;
    }
    
    // Compare dates to determine which is more recent
    if (ultimoExamenDate.isAfter(progresoParcialDate)) {
      final ultimo = _ultimoResultado;
      if (ultimo != null && ultimo.totalQuestions > 0) {
        return (ultimo.score / ultimo.totalQuestions) * 100;
      }
      return null;
    } else {
      return _mostRecentPartialProgress?.completionPercentage ?? 0.0;
    }
  }

  // Get the mode of the most recent activity
  String? get _ultimoModo {
    final ultimoExamenDate = _ultimoResultado?.date;
    final progresoParcialDate = _mostRecentPartialProgress?.date;
    
    if (ultimoExamenDate == null && progresoParcialDate == null) return null;
    if (ultimoExamenDate == null) return _mostRecentPartialProgress?.mode;
    if (progresoParcialDate == null) return _ultimoResultado?.mode;
    
    return ultimoExamenDate.isAfter(progresoParcialDate) ? _ultimoResultado?.mode : _mostRecentPartialProgress?.mode;
  }

  int get _materiasIniciadas => _examHistory.map((e) => e.subject).toSet().length;

  int get _rachaActivaMax {
    return _globalStreakData?.streakDays ?? 0;
  }

  double? get _mejorResultadoPct {
    if (_examHistory.isEmpty) return null;
    double mejor = 0;
    for (final e in _examHistory) {
      if (e.totalQuestions <= 0) continue;
      final pct = (e.score / e.totalQuestions) * 100;
      if (pct > mejor) mejor = pct;
    }
    return mejor;
  }

  String _modoLabel(String modo) {
    switch (modo) {
      case 'test':
        return 'Test';
      case 'streak':
        return 'Racha';
      case 'practice':
      default:
        return 'Práctica';
    }
  }

  ({bool tieneIntentos, double? ultimoPct}) _statsMateria(String nombre) {
    final intentos = _examHistory.where((e) => e.subject == nombre).toList();
    if (intentos.isEmpty) {
      return (tieneIntentos: false, ultimoPct: null);
    }
    final ultimo = intentos.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
    final ultimoPct = ultimo.totalQuestions > 0 ? (ultimo.score / ultimo.totalQuestions) * 100 : 0.0;
    return (tieneIntentos: true, ultimoPct: ultimoPct);
  }

  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MiPantallaLogin(themeNotifier: widget.themeNotifier)),
        (route) => false,
      );
    }
  }

  Future<void> _continuarEstudio(BuildContext context, Map<String, dynamic> materia) async {
    // Check if there's partial progress for this subject
    final partialProgress = await StorageService.getPartialProgress(materia['nombre'].toString());
    
    if (!context.mounted) return;
    
    if (partialProgress != null && partialProgress.questionPool != null && partialProgress.mode == 'practice') {
      // Directly continue the quiz without showing mode selection (only for practice mode)
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            preguntasRecibidas: partialProgress.questionPool!,
            tituloMateria: materia['nombre'].toString(),
            isTestMode: false, // Always false for practice mode
            partialProgress: partialProgress,
          ),
        ),
      ).then((_) {
        // Refresh data when returning from quiz
        _loadStreakData();
      });
    } else {
      // If no partial progress or it doesn't match practice mode, show mode selection
      _mostrarSeleccionModo(context, materia);
    }
  }

  @override
  Widget build(BuildContext context) {
  final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
  final Color textColor = esModoOscuro ? AppColors.darkText : AppColors.lightText;
  final Color secondaryTextColor = esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  // Use the most recent activity (completed exam or partial progress)
  final String? ultimaMateria = _ultimaMateria;
  final String? ultimoModo = _ultimoModo;
  final double? ultimoProgresoPct = _ultimoProgresoPct;
  
  final Map<String, dynamic> materiaContinuar = ultimaMateria != null
      ? widget.materias.firstWhere(
          (m) => m['nombre'] == ultimaMateria,
          orElse: () => widget.materias.first,
        )
      : widget.materias.first;
  
  // Determine if we should show "Continuar estudiando" or "Empieza por aquí"
  // Restrict "Continue Studying" to ONLY be available in Study Mode (Modo Estudio)
  // Show "Continuar estudiando" only if the most recent activity is practice mode AND/OR if there's partial progress in practice mode
  final bool hasHistory = (ultimoModo == 'practice') || 
                         (_mostRecentPartialProgress != null && _mostRecentPartialProgress!.mode == 'practice');
  final String? modoLabel = ultimoModo != null ? _modoLabel(ultimoModo) : null;
  
  // If there's partial progress, update the label to show it's a continuation
  final String? displayLabel = _mostRecentPartialProgress != null 
      ? 'Continuar (${(_mostRecentPartialProgress!.completionPercentage * 100).toInt()}%)'
      : modoLabel;

  final Widget header = PanelEstudioHeader(
    userName: _userName,
    rachaActivaMax: _rachaActivaMax,
    textColor: textColor,
    secondaryTextColor: secondaryTextColor,
    onStreakTap: () => _mostrarResumenStreak(context),
  );

  final Widget drawer = AppDrawer(
    userName: _userName,
    materiasIniciadas: _materiasIniciadas,
    totalMaterias: widget.materias.length,
    themeNotifier: themeNotifier,
    surfaceColor: esModoOscuro ? AppColors.darkCard : Colors.white,
    textColor: textColor,
    secondaryTextColor: secondaryTextColor,
    onOpenInstructions: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PantallaInstructivo()),
      );
    },
    onOpenSuggestions: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PantallaSugerencias()),
      );
    },
    onOpenHistory: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PantallaHistorialExamenes()),
      );
    },
    onOpenAbout: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PantallaAcercaDe()),
      );
    },
    onLogout: () => _handleLogout(context),
  );

  final Widget continueCard = ContinueStudyingCard(
    hasHistory: hasHistory,
    materiaNombre: materiaContinuar['nombre'].toString(),
    imagenAsset: materiaContinuar['Imagen'].toString(),
    modoLabel: hasHistory ? displayLabel : null,
    resultadoPct: hasHistory ? ultimoProgresoPct : null,
    onTap: () => _continuarEstudio(context, materiaContinuar),
    darkGradientColor: AppColors.darkCard,
    darkTextColor: AppColors.darkText,
    lightTextColor: AppColors.lightText,
  );

  final Widget summary = ProgressSummary(
    materiasIniciadas: _materiasIniciadas,
    totalMaterias: widget.materias.length,
    rachaActivaMax: _rachaActivaMax,
    mejorResultadoLabel: _mejorResultadoPct != null ? '${_mejorResultadoPct!.round()}%' : '—',
    textColor: textColor,
    secondaryTextColor: secondaryTextColor,
    onStreakTap: () => _mostrarResumenStreak(context),
  );

  Widget buildSubjectCard(Map<String, dynamic> materia) {
    final streakDays = _globalStreakData?.streakDays ?? 0;
    final nombreMateria = materia['nombre'].toString();
    final stats = _statsMateria(nombreMateria);

    // Check if this subject has partial progress (only practice mode is loaded now)
    final subjectProgress = _allPartialProgress[nombreMateria];
    final progressPercentage = subjectProgress?.completionPercentage ?? 0.0;

    return SubjectCard(
      nombre: nombreMateria,
      imagenAsset: materia['Imagen'].toString(),
      streakDays: streakDays,
      tieneIntentos: stats.tieneIntentos,
      ultimoPct: stats.ultimoPct,
      esMateriaActual: ultimaMateria != null && nombreMateria == ultimaMateria,
      progressPercentage: progressPercentage,
      onTap: () => _mostrarSeleccionModo(context, materia),
      darkGradientColor: AppColors.darkCard,
      darkTextColor: AppColors.darkText,
      lightTextColor: AppColors.lightText,
    );
  }

  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final bool esEscritorioAncho = screenWidth >= 600;
  // Modo compacto: pantallas móviles de poca altura (p. ej. 320x568, 360x640)
  // reciben tarjetas aún más bajas y espacios más ajustados; el resto del
  // scroll queda como red de seguridad si aun así no entra todo.
  final bool esAltoReducido = screenHeight < 700;

  if (!esEscritorioAncho) {
    final double vGap = esAltoReducido ? 8.0 : 10.0;
    final double gridAspectRatio = esAltoReducido ? 1.34 : 1.22;
    // El contenido se envuelve en scroll (como en escritorio) en vez de
    // confinar la grilla a un Expanded: en móviles normales todo entra sin
    // desplazamiento visible; en móviles pequeños el scroll actúa como
    // respaldo seguro sin recortar nada.
    return Scaffold(
      drawer: drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              header,
              const SizedBox(height: 14),
              continueCard,
              SizedBox(height: vGap),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                  childAspectRatio: gridAspectRatio,
                ),
                itemCount: widget.materias.length,
                itemBuilder: (context, index) => buildSubjectCard(widget.materias[index]),
              ),
              SizedBox(height: vGap),
              summary,
            ],
          ),
        ),
      ),
    );
  }

  // Escritorio / web ancho (>= 600 px): contenido centrado, ancho máximo,
  // todo dentro de un único scroll (encabezado, continuar, materias y resumen).
  return Scaffold(
    drawer: drawer,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: 14),
                continueCard,
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.08,
                  ),
                  itemCount: widget.materias.length,
                  itemBuilder: (context, index) => buildSubjectCard(widget.materias[index]),
                ),
                const SizedBox(height: 16),
                summary,
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  void _mostrarResumenStreak(BuildContext context) async {
    final globalStreak = await StorageService.getGlobalStreakData();
    final streakData = await StorageService.getStreakData();
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: esModoOscuro ? AppColors.darkCard.withOpacity(0.95) : Colors.white.withOpacity(0.95),
          title: Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text(
                "Resumen de Rachas", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: esModoOscuro ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: streakData == null
              ? Text(
                  "Aún no has completado exámenes de racha.",
                  style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87),
                )
              : SingleChildScrollView(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Global streak display
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: esModoOscuro ? AppColors.darkCard.withOpacity(0.8) : Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  "Racha Global: ${streakData.streakDays} días",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16,
                                    color: esModoOscuro ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Racha Máxima: ${streakData.maxStreakDays} días",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: esModoOscuro ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "Total Exámenes Aprobados: ${streakData.totalExams}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: esModoOscuro ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Global lives display with improved design
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: esModoOscuro ? Colors.grey.shade800.withOpacity(0.6) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Vidas Disponibles", 
                            style: TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.bold,
                              color: esModoOscuro ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              final life = globalStreak.lives[index];
                              return _buildImprovedLifeDisplay(life, index, esModoOscuro);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cerrar",
                style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildImprovedLifeDisplay(LifeData life, int index, bool esModoOscuro) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: life.isAvailable 
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            border: Border.all(
              color: life.isAvailable 
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              life.isAvailable ? Icons.favorite : Icons.heart_broken,
              color: life.isAvailable 
                  ? Colors.red 
                  : Colors.grey,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!life.isAvailable && life.rechargeTime != null)
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
            builder: (context, snapshot) {
              final now = tz.TZDateTime.now(tz.local);
              final remaining = life.rechargeTime!.difference(now);
              if (remaining.isNegative) {
                return Text(
                  "Lista",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              }
              final hours = remaining.inHours;
              final minutes = remaining.inMinutes % 60;
              final seconds = remaining.inSeconds % 60;
              return Text(
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: esModoOscuro ? Colors.white70 : Colors.grey,
                ),
              );
            },
          )
        else
          Text(
            "Lista",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
      ],
    );
  }

  void _mostrarSeleccionModo(BuildContext context, Map<String, dynamic> materia) async {
    final globalStreak = await StorageService.getGlobalStreakData();

    final dynamic poolRaw = materia['pool'];
    final int totalPreguntasPool = poolRaw is List ? poolRaw.length : 0;
    final int limiteTest = (materia['limite'] as int?) ?? 16;
    final int preguntasTest = totalPreguntasPool > 0 && totalPreguntasPool < limiteTest
        ? totalPreguntasPool
        : limiteTest;

    // Check if there's partial progress for this subject
    final partialProgress = await StorageService.getPartialProgress(materia['nombre'].toString());

    if (!context.mounted) return;

    // Convert GlobalStreakData to simplified LifeDisplayData for UI
    final livesDisplay = globalStreak.lives.map((life) {
      return LifeDisplayData(
        isAvailable: life.isAvailable,
        rechargeTime: life.rechargeTime,
      );
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModeSelectorSheet(
        materiaNombre: materia['nombre'].toString(),
        preguntasPractica: totalPreguntasPool,
        preguntasTest: preguntasTest,
        lives: livesDisplay,
        rachaActiva: _rachaActivaMax,
        onContinue: partialProgress != null && partialProgress.mode == 'practice' ? () {
          Navigator.pop(context);
          _continuarEstudio(context, materia);
        } : null,
        currentQuestion: partialProgress?.currentQuestionIndex != null ? partialProgress!.currentQuestionIndex + 1 : null,
        totalQuestions: partialProgress?.totalQuestions,
        partialProgressMode: partialProgress?.mode, // Pass the mode of partial progress
        onPractice: () {
          Navigator.pop(context);
          _irAlQuiz(context, materia, false);
        },
        onTest: () {
          Navigator.pop(context);
          _irAlQuiz(context, materia, true);
        },
        onRacha: () async {
          Navigator.pop(context);
          await _irAlStreakMode(context, materia);
        },
      ),
    );
  }

  void _irAlQuiz(BuildContext context, Map<String, dynamic> materia, bool modoTest) async {
    // Check if there's partial progress for this subject and mode
    final partialProgress = await StorageService.getPartialProgress(materia['nombre'].toString());
    
    if (!context.mounted) return;
    
    // If there's partial progress that matches the subject and mode, restore it directly
    if (partialProgress != null && 
        partialProgress.mode == (modoTest ? 'test' : 'practice') &&
        partialProgress.questionPool != null) {
      
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            preguntasRecibidas: partialProgress.questionPool!,
            tituloMateria: materia['nombre'].toString(),
            isTestMode: modoTest,
            partialProgress: partialProgress, // Pass the partial progress to restore state
          ),
        ),
      ).then((_) {
        // Refresh data when returning from quiz
        _loadStreakData();
      });
      return;
    }
    
    // Otherwise, start a new quiz as before
    final dynamic poolRaw = materia['pool'];
    List<Map<String, dynamic>> poolAEnviar = [];

    if (poolRaw is List) {
      poolAEnviar = poolRaw.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
    }

    if (modoTest) {
      poolAEnviar.shuffle();
      int limite = materia['limite'] ?? 16;
      poolAEnviar = poolAEnviar.take(limite).toList();
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          preguntasRecibidas: poolAEnviar,
          tituloMateria: materia['nombre'].toString(),
          isTestMode: modoTest,
        ),
      ),
    ).then((_) {
      // Refresh data when returning from quiz (both completion and back button)
      _loadStreakData();
    });
  }

  Future<void> _irAlStreakMode(BuildContext context, Map<String, dynamic> materia) async {
    // Check if user has global lives
    final globalStreak = await StorageService.getGlobalStreakData();
    final availableLives = globalStreak.availableLives;
    
    if (availableLives <= 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No tienes vidas disponibles. Algunas están recargando. Revisa el tiempo restante en el selector de modo."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Check if onboarding has been shown
    final hasShownOnboarding = await StorageService.hasShownStreakOnboarding();
    
    if (!hasShownOnboarding) {
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PantallaOnboardingStreak(materia: materia)),
        ).then((_) {
          // Refresh data when returning from onboarding
          _loadStreakData();
        });
      }
      return;
    }

    // Proceed to streak exam
    final dynamic poolRaw = materia['pool'];
    List<Map<String, dynamic>> poolAEnviar = [];

    if (poolRaw is List) {
      poolAEnviar = poolRaw.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
    }

    poolAEnviar.shuffle();
    int limite = StreakConfig.getQuestionsForSubject(materia['nombre'].toString());
    poolAEnviar = poolAEnviar.take(limite).toList();

    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreakQuizPage(
            preguntasRecibidas: poolAEnviar,
            tituloMateria: materia['nombre'].toString(),
          ),
        ),
      ).then((result) {
        // Check for rage quit (anti-cheat) when returning from streak quiz
        StorageService.checkForRageQuit();
        // Refresh data when returning from streak quiz (always refresh)
        _loadStreakData();
      });
    }
  }
}

// 5. PÁGINA DEL QUIZ Y LÓGICA DE PREGUNTAS
class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> preguntasRecibidas;
  final String tituloMateria;
  final bool isTestMode;
  final PartialExamProgress? partialProgress; // Add partial progress parameter

  const QuizPage({
    super.key,
    required this.preguntasRecibidas,
    required this.tituloMateria,
    required this.isTestMode,
    this.partialProgress, // Make it optional
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int preguntaActual = 0;
  int puntaje = 0;
  bool respondido = false;
  int? indiceSeleccionado;
  late List<Map<String, dynamic>> preguntas;
  
  List<int?> respuestasUsuario = []; 
  late Stopwatch _cronometro;
  Duration _tiempoFinal = Duration.zero;

  // Controladores para el scroll horizontal superior y el cambio de pantallas
  late PageController _pageController;
  late ScrollController _menuScrollController;
  bool _isQuizFinished = false;

  @override
  void initState() {
    super.initState();
    preguntas = List<Map<String, dynamic>>.from(widget.preguntasRecibidas);
    _pageController = PageController(initialPage: 0);
    _menuScrollController = ScrollController();
    
    // Restore partial progress if available
    if (widget.partialProgress != null) {
      final progress = widget.partialProgress!;
      respuestasUsuario = List<int?>.from(progress.userAnswers);
      
      // Restore the saved question position
      preguntaActual = progress.currentQuestionIndex;
      
      // Restore time spent
      _cronometro = Stopwatch();
      _cronometro.start();
      // We can't restore exact elapsed time in a stopwatch, but we can track it separately
      _tiempoFinal = Duration(seconds: progress.timeSpentSeconds);
      
      // Update page controller to the current question
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(preguntaActual);
      });
    } else {
      // Initialize normally for new quiz
      respuestasUsuario = List<int?>.filled(preguntas.length, null);
      _cronometro = Stopwatch()..start();
      _tiempoFinal = Duration.zero;
    }
  }

  @override
  void dispose() {
    _cronometro.stop();
    _pageController.dispose();
    _menuScrollController.dispose();
    
    // Save partial progress if quiz is not finished
    if (!_isQuizFinished) {
      _savePartialProgress();
    }
    
    super.dispose();
  }

  void _savePartialProgress() {
    final answeredCount = respuestasUsuario.where((r) => r != null).length;
    if (answeredCount > 0) {
      // Calculate total time spent (existing time + current session time)
      final totalTimeSpent = _tiempoFinal.inSeconds + _cronometro.elapsed.inSeconds;
      
      final progress = PartialExamProgress(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: widget.tituloMateria,
        date: DateTime.now(),
        totalQuestions: preguntas.length,
        answeredQuestions: answeredCount,
        mode: widget.isTestMode ? 'test' : 'practice',
        userAnswers: respuestasUsuario,
        timeSpentSeconds: totalTimeSpent,
        questionPool: preguntas, // Include the question pool for restoration
        currentQuestionIndex: preguntaActual, // Save current question position
        reachedFiftyPercent: false, // Not applicable for practice/test modes
      );
      StorageService.savePartialProgress(progress);
    }
  }

  String _formatearTextoPregunta(String textoOriginal, int indice) {
    String limpio = textoOriginal.replaceFirst(RegExp(r'^\d+[\.\s\-]*'), '').trim();
    if (widget.isTestMode){
      return limpio;
    }
    return "Pregunta ${indice + 1}: $limpio";
  }

  Color _getColorPuntaje(double porcentaje) {
    if (porcentaje >= 0.75) return Colors.green;
    if (porcentaje >= 0.65) return Colors.orange;
    return Colors.red;
  }
  void _mostrarDialogoReporte(BuildContext context, int indexPregunta, String textoPregunta) {
    final TextEditingController reporteController = TextEditingController();
    bool enviandoReporte = false;
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Reportar Pregunta", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pregunta ${indexPregunta + 1}", style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reporteController,
                    style: TextStyle(
                      color: esModoOscuro ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: "¿Qué problema encontraste? (Ej. Respuesta incorrecta, mal redactada...)",
                      hintStyle: TextStyle(
                        color: esModoOscuro ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: esModoOscuro ? Colors.grey.shade800 : Colors.grey.shade100,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: enviandoReporte ? null : () async {
                    if (reporteController.text.trim().isEmpty) return;
                    
                    setStateDialog(() => enviandoReporte = true);
                    
                    try {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String userName = prefs.getString('userName') ?? "Desconocido";

                      await FirebaseFirestore.instance.collection('Reportes_Preguntas').add({
                        'usuario': userName,
                        'materia': widget.tituloMateria,
                        'modo_test': widget.isTestMode,
                        'pregunta_index': indexPregunta,
                        'pregunta_texto': textoPregunta,
                        'mensaje': reporteController.text.trim(),
                        'fecha': FieldValue.serverTimestamp(),
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Reporte enviado. ¡Gracias!"), backgroundColor: Colors.green),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error al reportar: $e"), backgroundColor: Colors.red),
                        );
                        setStateDialog(() => enviandoReporte = false);
                      }
                    }
                  },
                  child: enviandoReporte 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Enviar Reporte"),
                ),
              ],
            );
          }
        );
      }
    );
  }
  void validarRespuesta(int indice, int puntos) {
    if (respondido && !widget.isTestMode) return;
    
    setState(() {
      int? respuestaAnterior = respuestasUsuario[preguntaActual];
      indiceSeleccionado = indice;
      respuestasUsuario[preguntaActual] = indice;
      
      if (!widget.isTestMode) {
        respondido = true;
        // Calculamos puntaje incremental en modo práctica
        if (respuestaAnterior != null) {
          final resps = preguntas[preguntaActual]['respuestas'] as List;
          if (resps[respuestaAnterior]['puntos'] == 1) puntaje--;
        }
        if (puntos == 1) puntaje++;
      }
    });
    
    // Save progress after answering a question
    _savePartialProgress();
  }

  // Método unificado para saltar de pregunta fluidamente
  void _saltarAPregunta(int index) {
    if (index >= 0 && index < preguntas.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      preguntaActual = index;
      if (widget.isTestMode) {
        indiceSeleccionado = respuestasUsuario[preguntaActual];
        respondido = false;
      } else {
        // En modo práctica, verificamos si la página a la que vamos ya fue respondida
        indiceSeleccionado = respuestasUsuario[preguntaActual];
        respondido = indiceSeleccionado != null;
      }
    });
    
    // Save progress when changing questions (for accidental back navigation)
    _savePartialProgress();
    
    _animarMenuSuperior(index);
  }

  // Desplaza el menú numérico de arriba automáticamente para mantener visible la pregunta activa
  void _animarMenuSuperior(int index) {
    if (mounted && _menuScrollController.hasClients) {
      double posicionDestino = (index * 55.0) - (MediaQuery.of(context).size.width / 2) + 27.5;
      if (posicionDestino < 0) posicionDestino = 0;
      _menuScrollController.animateTo(
        posicionDestino,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
  }

  void _finalizarQuiz() {
    setState(() {
      if (widget.isTestMode) {
        puntaje = 0;
        for (int i = 0; i < preguntas.length; i++) {
          if (respuestasUsuario[i] != null) {
            final resps = preguntas[i]['respuestas'] as List;
            if (resps[respuestasUsuario[i]!]['puntos'] == 1) puntaje++;
          }
        }
      }
      _cronometro.stop();
      _tiempoFinal = _cronometro.elapsed;
      _isQuizFinished = true;
    });

    // Save exam result to history
    final examResult = ExamResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: widget.tituloMateria,
      date: tz.TZDateTime.now(tz.local),
      score: puntaje,
      totalQuestions: preguntas.length,
      mode: widget.isTestMode ? 'test' : 'practice',
      timeSpentSeconds: _tiempoFinal.inSeconds,
      incorrectAnswers: _getIncorrectAnswers(),
      weakTopics: _getWeakTopics(),
      allQuestions: _getAllQuestionsWithAnswers(),
      passed: true, // Practice/test modes always count as passed
    );
    
    StorageService.saveExamResult(examResult);
    
    // Clear partial progress only for this mode since exam is now complete
    StorageService.clearPartialProgress(widget.tituloMateria, mode: widget.isTestMode ? 'test' : 'practice');
  }

  List<Map<String, dynamic>> _getAllQuestionsWithAnswers() {
    List<Map<String, dynamic>> allQuestions = [];
    for (int i = 0; i < preguntas.length; i++) {
      int? userAnswerIndex = respuestasUsuario[i];
      final resps = preguntas[i]['respuestas'] as List;
      
      // Find correct answer
      int correctIndex = -1;
      for (int j = 0; j < resps.length; j++) {
        if (resps[j]['puntos'] == 1) {
          correctIndex = j;
          break;
        }
      }
      
      allQuestions.add({
        'question': preguntas[i]['texto'],
        'explanation': preguntas[i]['explicacion'] ?? '',
        'userAnswer': userAnswerIndex != null ? resps[userAnswerIndex]['texto'] : 'Sin respuesta',
        'correctAnswer': correctIndex >= 0 ? resps[correctIndex]['texto'] : '',
        'isCorrect': userAnswerIndex != null && resps[userAnswerIndex]['puntos'] == 1,
      });
    }
    return allQuestions;
  }

  List<Map<String, dynamic>> _getIncorrectAnswers() {
    List<Map<String, dynamic>> incorrect = [];
    for (int i = 0; i < preguntas.length; i++) {
      if (respuestasUsuario[i] != null) {
        final resps = preguntas[i]['respuestas'] as List;
        if (resps[respuestasUsuario[i]!]['puntos'] != 1) {
          incorrect.add({
            'question': preguntas[i]['texto'],
            'userAnswer': resps[respuestasUsuario[i]!]['texto'],
            'correctAnswer': resps.firstWhere((r) => r['puntos'] == 1)['texto'],
          });
        }
      }
    }
    return incorrect;
  }

  List<String> _getWeakTopics() {
    List<String> topics = [];
    final incorrect = _getIncorrectAnswers();
    if (incorrect.length > 2) {
      topics.add("Revisar conceptos fundamentales");
    }
    return topics;
  }

  @override
  Widget build(BuildContext context) {
    // Detectamos si estamos en modo oscuro
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // AQUÍ ESTÁ LA MAGIA: Cambiamos el fondo gris claro por un azul oscuro elegante
      backgroundColor: esModoOscuro ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.isTestMode ? 'Test: ${widget.tituloMateria}' : 'Estudio: ${widget.tituloMateria}'),
        backgroundColor: esModoOscuro ? AppColors.darkAppBar : Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isQuizFinished 
          ? buildSolucionario() 
          : Column(
              children: [
                _buildMenuDesplazableNumeros(),
                Expanded(
                  child: PageView.builder(
                    physics: _scrollBloqueado 
                    ? const NeverScrollableScrollPhysics() 
                    : const AlwaysScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: preguntas.length,
                    itemBuilder: (context, index) => buildQuizPageContent(index),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _isQuizFinished ? null : _buildBarraNavegacionAtractiva(),
    );
  }

  // Menú horizontal superior deslizable de números
  Widget _buildMenuDesplazableNumeros() {
    return Container(
      height: 65,
      color: Colors.transparent,
      child: ListView.builder(
        controller: _menuScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          
          bool esActual = index == preguntaActual;
          bool estaRespondida = respuestasUsuario[index] != null;

          bool esCorrecta = false;
          if (estaRespondida) {
            final resps = preguntas[index]['respuestas'] as List;
            esCorrecta = resps[respuestasUsuario[index]!]['puntos'] == 1;
          }

          Color colorFondo = Colors.indigo.shade700.withOpacity(0.4);
          Color colorTexto = Colors.white60;

          if (esActual) {
            colorFondo = Colors.white;
            colorTexto = Colors.indigo.shade900;
          } else if (estaRespondida) {
            if (widget.isTestMode) {
              colorFondo = Colors.orange.shade400;
            } else {
              colorFondo = esCorrecta ? Colors.green.shade400 : Colors.red.shade400;
            }
            colorTexto = Colors.white;
          }

          return GestureDetector(
            onTap: () => _saltarAPregunta(index),
            child: Container(
              width: 45,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: colorFondo,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: esActual ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))] : null,
              ),
              child: Center(
                 child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: esActual ? FontWeight.bold : FontWeight.w500, 
                    color: colorTexto
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  bool _scrollBloqueado = false;  
  // Renderiza el contenido específico de cada pregunta dentro del PageView
  // Renderiza el contenido específico de cada pregunta dentro del PageView
  Widget buildQuizPageContent(int index) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    
    final pregunta = preguntas[index];
    final respuestas = List<Map<String, dynamic>>.from(pregunta['respuestas'] as List);
    final bool haRespondidoEstaPagina = respuestasUsuario[index] != null;
    final bool mostrarSolucion = haRespondidoEstaPagina && !widget.isTestMode;
    
    return SingleChildScrollView(
      // ¡AQUÍ ESTÁ EL CAMBIO! Bloquea el scroll vertical (arriba/abajo) cuando el zoom está activo
      physics: _scrollBloqueado 
          ? const NeverScrollableScrollPhysics() 
          : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 90.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (index + 1) / preguntas.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.orange,
            minHeight: 6,
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  // Texto de la pregunta centrado
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 30.0), // Margen para que el texto no pise el botón
                      child: Text(
                        _formatearTextoPregunta(pregunta['texto'], index),
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.report_problem_outlined, color: Colors.red.shade400),
                      tooltip: "Reportar un problema con esta pregunta",
                      onPressed: () => _mostrarDialogoReporte(context, index, pregunta['texto']),
                    ),
                  ),
                ],
              ),
            ),
          ),
            
          
          const SizedBox(height: 20),
          
          // Carga de imágenes corregida con su ZoomableImage
          // ✅ Carga de imágenes corregida
        if (pregunta.containsKey('imagenes') && pregunta['imagenes'] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              // Usamos List<String>.from(...) para convertir dinámicamente cada elemento
              children: List<String>.from(pregunta['imagenes'] as List).map((ruta) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ZoomableImage(
                    imagePath: ruta,
                    onZoomChanged: (estaHabilitado) {
                      setState(() {
                        _scrollBloqueado = estaHabilitado;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Opciones de respuesta
          ...respuestas.asMap().entries.map((entry) {
            int idx = entry.key;
            var respuesta = entry.value;
            bool esSeleccionada = idx == indiceSeleccionado;
            bool esCorrecta = respuesta['puntos'] == 1;
            
            Color? colorFondo;
            Color colorTexto = esModoOscuro ? AppColors.darkText : Colors.black87;
            Color colorBorde = esModoOscuro ? Colors.grey.shade600 : Colors.grey.shade300;
            
            if (mostrarSolucion) {
              if (esSeleccionada) {
                colorFondo = esCorrecta 
                    ? (esModoOscuro ? Colors.green.shade800 : Colors.green.shade100)
                    : (esModoOscuro ? Colors.red.shade800 : Colors.red.shade100);
                colorBorde = esCorrecta ? Colors.green : Colors.red;
              } else if (esCorrecta) {
                colorFondo = esModoOscuro ? Colors.green.shade900 : Colors.green.shade50;
                colorBorde = Colors.green.shade300;
              }
            } else if (esSeleccionada) {
              colorFondo = esModoOscuro ? Colors.indigo.shade800 : Colors.indigo.shade100;
              colorBorde = Colors.indigo;
            } else {
              colorFondo = esModoOscuro ? AppColors.darkCard : Colors.white;
            }
            
            return GestureDetector(
              onTap: () => validarRespuesta(idx, respuesta['puntos']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorFondo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorBorde, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: esSeleccionada 
                            ? (mostrarSolucion 
                                ? (esCorrecta ? Colors.green : Colors.red)
                                : Colors.indigo)
                            : Colors.grey.shade300,
                        border: Border.all(color: colorBorde, width: 2),
                      ),
                      child: esSeleccionada
                          ? Icon(
                              mostrarSolucion 
                                  ? (esCorrecta ? Icons.check : Icons.close)
                                  : Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        respuesta['texto'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: esSeleccionada ? FontWeight.bold : FontWeight.normal,
                          color: colorTexto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          
          // Explicación (solo en modo práctica y después de responder)
          if (mostrarSolucion && pregunta.containsKey('explicacion'))
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: esModoOscuro ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: esModoOscuro ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Explicación:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: esModoOscuro ? Colors.blue.shade300 : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pregunta['explicacion'],
                    style: TextStyle(
                      color: esModoOscuro ? AppColors.darkTextSecondary : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Barra de navegación inferior con botones atractivos
  Widget _buildBarraNavegacionAtractiva() {
    bool esPrimeraPregunta = preguntaActual == 0;
    bool esUltimaPregunta = preguntaActual == preguntas.length - 1;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón anterior
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: esPrimeraPregunta 
                      ? Colors.transparent 
                      : Colors.indigo.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: esPrimeraPregunta 
                  ? null 
                  : () => _saltarAPregunta(preguntaActual - 1),
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text("Anterior"),
              style: ElevatedButton.styleFrom(
                backgroundColor: esPrimeraPregunta 
                    ? Colors.grey.shade300 
                    : Colors.indigo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // Botón de finalizar (solo en última pregunta)
          if (esUltimaPregunta)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _finalizarQuiz,
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text("Finalizar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            // Botón siguiente
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _saltarAPregunta(preguntaActual + 1),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: const Text("Siguiente"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSolucionario() {
    int puntajeFinal = puntaje;
    double porcentaje = preguntas.isNotEmpty ? puntajeFinal / preguntas.length : 0.0;
    Color colorDinamico = _getColorPuntaje(porcentaje);
    String minutos = _tiempoFinal.inMinutes.toString().padLeft(2, '0');
    String segundos = (_tiempoFinal.inSeconds % 60).toString().padLeft(2, '0');
    
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Icon(Icons.analytics, size: 80, color: colorDinamico),
          Text(
            "${(porcentaje * 100).toStringAsFixed(0)}%",
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: colorDinamico),
          ),
          Text(
            "$puntajeFinal de ${preguntas.length} correctas",
            style: TextStyle(fontSize: 18, color: esModoOscuro ? AppColors.darkTextSecondary : Colors.grey),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            color: esModoOscuro ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.timer, color: Colors.indigo, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            "$minutos:$segundos",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: esModoOscuro ? AppColors.darkText : Colors.black87),
                          ),
                          Text("Tiempo", style: TextStyle(color: esModoOscuro ? AppColors.darkTextSecondary : Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.school, color: colorDinamico, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            widget.tituloMateria,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: esModoOscuro ? AppColors.darkText : Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          Text("Materia", style: TextStyle(color: esModoOscuro ? AppColors.darkTextSecondary : Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Summary of all questions
          Card(
            elevation: 4,
            color: esModoOscuro ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt, color: colorDinamico, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Resumen de preguntas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorDinamico,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(preguntas.length, (index) {
                    final pregunta = preguntas[index];
                    final respuestas = List<Map<String, dynamic>>.from(pregunta['respuestas'] as List);
                    final int? userAnswerIndex = respuestasUsuario[index];
                    
                    // Find correct answer
                    int correctIndex = -1;
                    for (int j = 0; j < respuestas.length; j++) {
                      if (respuestas[j]['puntos'] == 1) {
                        correctIndex = j;
                        break;
                      }
                    }
                    
                    final bool isCorrect = userAnswerIndex != null && respuestas[userAnswerIndex]['puntos'] == 1;
                    final bool wasAnswered = userAnswerIndex != null;
                    
                    // Dark mode colors
                    final Color answeredCorrectColor = esModoOscuro ? Colors.green.shade800 : Colors.green.shade50;
                    final Color answeredIncorrectColor = esModoOscuro ? Colors.red.shade800 : Colors.red.shade50;
                    final Color unansweredColor = esModoOscuro ? AppColors.darkCard.withOpacity(0.5) : Colors.grey.shade100;
                    final Color answeredCorrectBorder = esModoOscuro ? Colors.green.shade600 : Colors.green.shade300;
                    final Color answeredIncorrectBorder = esModoOscuro ? Colors.red.shade600 : Colors.red.shade300;
                    final Color unansweredBorder = esModoOscuro ? Colors.grey.shade600 : Colors.grey.shade300;
                    final Color textColor = esModoOscuro ? AppColors.darkText : Colors.black87;
                    final Color explanationBg = esModoOscuro ? Colors.blue.shade800 : Colors.blue.shade50;
                    final Color explanationText = esModoOscuro ? Colors.blue.shade100 : Colors.blue.shade900;
                    final Color answerContainerBg = esModoOscuro ? AppColors.darkCard : Colors.white;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: wasAnswered 
                            ? (isCorrect ? answeredCorrectColor : answeredIncorrectColor)
                            : unansweredColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: wasAnswered 
                              ? (isCorrect ? answeredCorrectBorder : answeredIncorrectBorder)
                              : unansweredBorder,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: wasAnswered 
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  pregunta['texto'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (wasAnswered)
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                  size: 20,
                                )
                              else
                                Icon(
                                  Icons.help_outline,
                                  color: esModoOscuro ? Colors.grey.shade400 : Colors.grey,
                                  size: 20,
                                ),
                            ],
                          ),
                          if (wasAnswered) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: answerContainerBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline, size: 16, color: esModoOscuro ? Colors.blue.shade300 : Colors.blue),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Tu respuesta:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: esModoOscuro ? Colors.blue.shade300 : Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          respuestas[userAnswerIndex]['texto'],
                                          style: TextStyle(fontSize: 12, color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, size: 16, color: esModoOscuro ? Colors.green.shade300 : Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Respuesta correcta:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: esModoOscuro ? Colors.green.shade300 : Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          correctIndex >= 0 ? respuestas[correctIndex]['texto'] : 'N/A',
                                          style: TextStyle(fontSize: 12, color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (pregunta.containsKey('explicacion') && pregunta['explicacion'] != null && pregunta['explicacion'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: explanationBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb_outline, size: 16, color: esModoOscuro ? Colors.blue.shade200 : Colors.blue),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pregunta['explicacion'],
                                      style: TextStyle(fontSize: 11, color: explanationText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text("Volver al Inicio"),
            onPressed: () {
              // Refresh the parent screen's data when returning
              Navigator.pop(context, true); // Pass true to indicate data should be refreshed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}


class ZoomableImage extends StatefulWidget {
  final String imagePath;
  final Function(bool) onZoomChanged;

  const ZoomableImage({
    super.key, 
    required this.imagePath, 
    required this.onZoomChanged
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _transformationController = TransformationController();
  bool _zoomHabilitado = false;
  

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Al quitar el Container de altura fija, el Stack se adapta al tamaño de la imagen
    return Stack(
      alignment: Alignment.topRight, // Esto ancla el botón a la esquina superior derecha
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              _zoomHabilitado = !_zoomHabilitado;
              widget.onZoomChanged(_zoomHabilitado);
              
              if (!_zoomHabilitado) {
                _transformationController.value = Matrix4.identity();
              }
            });
          },
          child: InteractiveViewer(
            transformationController: _zoomHabilitado ? _transformationController : null,
            // AQUÍ ESTÁ LA MAGIA: Solo se mueve y hace zoom si está habilitado
            panEnabled: _zoomHabilitado, 
            scaleEnabled: _zoomHabilitado,
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),
        ),
        
        // Etiqueta informativa pegada a la imagen
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () { 
              setState(() {
                _zoomHabilitado = false;
                widget.onZoomChanged(false);
                _transformationController.value = Matrix4.identity();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _zoomHabilitado ? Colors.red.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _zoomHabilitado ? "Presione para desactivar" : "Doble click para zoom",
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PantallaSugerencias extends StatefulWidget {
  const PantallaSugerencias({super.key});

  @override
  State<PantallaSugerencias> createState() => _PantallaSugerenciasState();
}

class _PantallaSugerenciasState extends State<PantallaSugerencias> {
  String? _tipoSeleccionado;
  String? _materiaSeleccionada;
  final TextEditingController _mensajeController = TextEditingController();
  bool _enviando = false;

  // Opciones para los menús desplegables
  final List<String> _tipos = ['Observación', 'Duda', 'Otro'];
  final List<String> _materias = [
    'AERODINÁMICA',
    'PERFORMANCE Y MOTORES',
    'OPERACIONES DE VUELO',
    'PESO Y BALANCE',
    'METEOROLOGÍA',
    'REGLAMENTACIÓN',
    'Aplicación / General' // Opción por si es un fallo de la app
  ];

  Future<void> _enviarSugerencia() async {
    // 1. Validación de campos vacíos
    if (_tipoSeleccionado == null || _materiaSeleccionada == null || _mensajeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      // 2. Obtener la identidad del usuario activo desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName = prefs.getString('userName') ?? "Usuario Desconocido";

      // 3. Enviar los datos a la colección "Sugerencias" en Firebase
      await FirebaseFirestore.instance.collection('Sugerencias').add({
        'usuario': userName,
        'tipo': _tipoSeleccionado,
        'materia': _materiaSeleccionada,
        'mensaje': _mensajeController.text.trim(),
        'fecha': FieldValue.serverTimestamp(),
      });

      // 4. Mostrar éxito y limpiar campos
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Mensaje enviado con éxito! Gracias por tu aporte."),
            backgroundColor: Colors.green
          ),
        );
        Navigator.pop(context); // Cierra la pantalla tras enviar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar: $e"), backgroundColor: Colors.red),
        );
        setState(() => _enviando = false);
      }
    }
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buzón de Sugerencias"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Qué tipo de mensaje es?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _tipoSeleccionado,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: esModoOscuro ? Colors.grey.shade800 : Colors.grey.shade100,
                hintStyle: TextStyle(color: esModoOscuro ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              hint: const Text("Selecciona una opción"),
              style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
              items: _tipos.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _tipoSeleccionado = newValue);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "¿A qué materia se refiere?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _materiaSeleccionada,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: esModoOscuro ? Colors.grey.shade800 : Colors.grey.shade100,
                hintStyle: TextStyle(color: esModoOscuro ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              hint: const Text("Selecciona una materia"),
              style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
              items: _materias.map((String materia) {
                return DropdownMenuItem<String>(
                  value: materia,
                  child: Text(materia),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _materiaSeleccionada = newValue);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Tu mensaje:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mensajeController,
              maxLines: 5,
              style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: esModoOscuro ? Colors.grey.shade800 : Colors.grey.shade100,
                hintText: "Escribe tu sugerencia, duda u observación aquí...",
                hintStyle: TextStyle(color: esModoOscuro ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _enviando ? null : _enviarSugerencia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _enviando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Enviar Mensaje",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. PANTALLA ONBOARDING STREAK MODE
class PantallaOnboardingStreak extends StatelessWidget {
  final Map<String, dynamic>? materia;

  const PantallaOnboardingStreak({super.key, this.materia});

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Responsive padding based on screen size
    final horizontalPadding = screenWidth < 360 ? 12.0 : 24.0;
    final verticalPadding = screenHeight < 600 ? 8.0 : 16.0;
    
    // Responsive font sizes
    final titleFontSize = screenWidth < 360 ? 24.0 : 32.0;
    final subtitleFontSize = screenWidth < 360 ? 14.0 : 18.0;
    final cardTitleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final cardDescFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final buttonFontSize = screenWidth < 360 ? 16.0 : 18.0;
    
    // Responsive spacing
    final spacing = screenHeight < 600 ? 6.0 : 12.0;
    final largeSpacing = screenHeight < 600 ? 12.0 : 20.0;
    final buttonSpacing = screenHeight < 600 ? 8.0 : 16.0;
    
    // Responsive icon size
    final iconSize = screenWidth < 360 ? 20.0 : 28.0;
    final fireSize = screenWidth < 360 ? 45.0 : 70.0;
    
    // Responsive button padding
    final buttonHorizontalPadding = screenWidth < 360 ? 20.0 : 32.0;
    final buttonVerticalPadding = screenHeight < 600 ? 10.0 : 14.0;
    
    return Scaffold(
      backgroundColor: esModoOscuro ? const Color(0xFF0F172A) : const Color(0xFF1E3A5F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              FireAnimation(size: fireSize),
              SizedBox(height: largeSpacing),
              Text(
                "Modo Streak",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing),
              Text(
                "Mantén tu racha diaria de estudio",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: subtitleFontSize,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: largeSpacing),
              _buildFeatureCard(
                icon: Icons.timer,
                title: "Tiempo Limitado",
                description: "2 minutos por pregunta para simular condiciones reales de examen",
                esModoOscuro: esModoOscuro,
                titleFontSize: cardTitleFontSize,
                descFontSize: cardDescFontSize,
                iconSize: iconSize,
              ),
              SizedBox(height: spacing),
              _buildFeatureCard(
                icon: Icons.calendar_today,
                title: "Racha Diaria",
                description: "Completa un examen por día (≥60% de aciertos) para mantener tu racha activa",
                esModoOscuro: esModoOscuro,
                titleFontSize: cardTitleFontSize,
                descFontSize: cardDescFontSize,
                iconSize: iconSize,
              ),
              SizedBox(height: spacing),
              _buildFeatureCard(
                icon: Icons.favorite,
                title: "Sistema de Vidas",
                description: "Tienes 3 vidas. Cada vida se recarga en 8 horas cuando la pierdes. Si fallas un examen (<60%), pierdes una vida. Sin vidas, no puedes hacer más exámenes de racha.",
                esModoOscuro: esModoOscuro,
                titleFontSize: cardTitleFontSize,
                descFontSize: cardDescFontSize,
                iconSize: iconSize,
              ),
              SizedBox(height: spacing),
              _buildFeatureCard(
                icon: Icons.emoji_events,
                title: "Preguntas Aleatorias",
                description: "Cada examen presenta preguntas diferentes para mantener el desafío",
                esModoOscuro: esModoOscuro,
                titleFontSize: cardTitleFontSize,
                descFontSize: cardDescFontSize,
                iconSize: iconSize,
              ),
              SizedBox(height: buttonSpacing),
              ElevatedButton(
                onPressed: () async {
                  await StorageService.setStreakOnboardingShown();
                  if (context.mounted) {
                    if (materia != null) {
                      // Start streak mode directly
                      final dynamic poolRaw = materia!['pool'];
                      List<Map<String, dynamic>> poolAEnviar = [];

                      if (poolRaw is List) {
                        poolAEnviar = poolRaw.map((item) {
                          return Map<String, dynamic>.from(item as Map);
                        }).toList();
                      }

                      poolAEnviar.shuffle();
                      int limite = StreakConfig.getQuestionsForSubject(materia!['nombre'].toString());
                      poolAEnviar = poolAEnviar.take(limite).toList();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StreakQuizPage(
                            preguntasRecibidas: poolAEnviar,
                            tituloMateria: materia!['nombre'].toString(),
                          ),
                        ),
                      );
                    } else {
                      // Just go back to main menu
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonHorizontalPadding,
                    vertical: buttonVerticalPadding,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text("¡Entendido!", style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8.0), // Add minimal bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required bool esModoOscuro,
    double titleFontSize = 16.0,
    double descFontSize = 14.0,
    double iconSize = 32.0,
  }) {
    return Container(
      padding: EdgeInsets.all(iconSize < 28 ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: esModoOscuro ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: esModoOscuro ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: iconSize),
          SizedBox(width: iconSize < 28 ? 12.0 : 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: esModoOscuro ? Colors.white : Colors.black87,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: iconSize < 28 ? 2.0 : 4.0),
                Text(
                  description,
                  style: TextStyle(
                    color: esModoOscuro ? Colors.white70 : Colors.black54,
                    fontSize: descFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Fire Animation Widget
class FireAnimation extends StatefulWidget {
  final double size;

  const FireAnimation({super.key, this.size = 50});

  @override
  State<FireAnimation> createState() => _FireAnimationState();
}

class _FireAnimationState extends State<FireAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: widget.size,
              shadows: [
                Shadow(
                  color: Colors.orange.withOpacity(0.5),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 7. PÁGINA DE EXAMEN STREAK MODE
class StreakQuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> preguntasRecibidas;
  final String tituloMateria;

  const StreakQuizPage({
    super.key,
    required this.preguntasRecibidas,
    required this.tituloMateria,
  });

  @override
  State<StreakQuizPage> createState() => _StreakQuizPageState();
}

class _StreakQuizPageState extends State<StreakQuizPage> {
  int preguntaActual = 0;
  int puntaje = 0;
  bool respondido = false;
  int? indiceSeleccionado;
  late List<Map<String, dynamic>> preguntas;
  
  List<int?> respuestasUsuario = []; 
  late Timer _timer;
  int _tiempoRestante = 0;
  bool _tiempoAgotado = false;
  bool _reachedFiftyPercent = false; // Anti-cheat flag

  @override
  void initState() {
    super.initState();
    preguntas = List<Map<String, dynamic>>.from(widget.preguntasRecibidas);
    respuestasUsuario = List<int?>.filled(preguntas.length, null);
    _iniciarTempor();
  }

  void _iniciarTempor() {
    int tiempoTotal = StreakConfig.getTotalTimeForSubject(widget.tituloMateria);
    _tiempoRestante = tiempoTotal;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _tiempoAgotado = true;
          timer.cancel();
          _finalizarQuiz();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    
    // Save partial progress with anti-cheat flag if not finished
    if (!_tiempoAgotado) {
      _savePartialProgress();
    }
    
    super.dispose();
  }

  void _savePartialProgress() {
    final answeredCount = respuestasUsuario.where((r) => r != null).length;
    if (answeredCount > 0) {
      // Check if reached 50% threshold
      final completionPercentage = answeredCount / preguntas.length;
      if (completionPercentage >= 0.5) {
        _reachedFiftyPercent = true;
      }
      
      final progress = PartialExamProgress(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: widget.tituloMateria,
        date: DateTime.now(),
        totalQuestions: preguntas.length,
        answeredQuestions: answeredCount,
        mode: 'streak',
        userAnswers: respuestasUsuario,
        timeSpentSeconds: StreakConfig.getTotalTimeForSubject(widget.tituloMateria) - _tiempoRestante,
        questionPool: preguntas,
        currentQuestionIndex: preguntaActual,
        reachedFiftyPercent: _reachedFiftyPercent,
      );
      StorageService.savePartialProgress(progress);
    }
  }

  String _formatearTiempo(int segundos) {
    int minutos = segundos ~/ 60;
    int segs = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  Color _getColorTiempo() {
    double porcentaje = _tiempoRestante / StreakConfig.getTotalTimeForSubject(widget.tituloMateria);
    if (porcentaje > 0.5) return Colors.green;
    if (porcentaje > 0.25) return Colors.orange;
    return Colors.red;
  }

  void validarRespuesta(int indice, int puntos) {
    if (respondido || _tiempoAgotado) return;
    
    setState(() {
      indiceSeleccionado = indice;
      respuestasUsuario[preguntaActual] = indice;
      respondido = true;
      
      if (puntos == 1) puntaje++;
    });
  }

  void _siguientePregunta() {
    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
        respondido = false;
        indiceSeleccionado = respuestasUsuario[preguntaActual];
      });
    } else {
      _finalizarQuiz();
    }
  }

  void _finalizarQuiz() {
    _timer.cancel();
    
    // Calculate pass/fail (70% to pass)
    double porcentaje = preguntas.isNotEmpty ? puntaje / preguntas.length : 0.0;
    bool passed = porcentaje >= 0.7;
    
    // Update streak data (using 70% threshold for streak logic)
    StorageService.updateStreakAfterExam(widget.tituloMateria, passed, porcentaje);
    
    // Save exam result
    final examResult = ExamResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: widget.tituloMateria,
      date: tz.TZDateTime.now(tz.local),
      score: puntaje,
      totalQuestions: preguntas.length,
      mode: 'streak',
      timeSpentSeconds: StreakConfig.getTotalTimeForSubject(widget.tituloMateria) - _tiempoRestante,
      incorrectAnswers: _getIncorrectAnswers(),
      weakTopics: _getWeakTopics(),
      allQuestions: _getAllQuestionsWithAnswers(),
      passed: porcentaje >= 0.7, // Only count if 70% or higher
    );
    
    StorageService.saveExamResult(examResult);
    
    // Clear partial progress only for streak mode since exam is now complete
    StorageService.clearPartialProgress(widget.tituloMateria, mode: 'streak');
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreakResultPage(
            puntaje: puntaje,
            totalPreguntas: preguntas.length,
            materia: widget.tituloMateria,
            passed: passed,
            tiempoAgotado: _tiempoAgotado,
            incorrectAnswers: _getIncorrectAnswersWithExplanations(),
          ),
        ),
      ).then((_) {
        // This won't normally execute due to pushReplacement, but kept for safety
        // The main refresh happens via didChangeDependencies in MainMenu
      });
    }
  }

  List<Map<String, dynamic>> _getIncorrectAnswersWithExplanations() {
    List<Map<String, dynamic>> incorrect = [];
    for (int i = 0; i < preguntas.length; i++) {
      if (respuestasUsuario[i] != null) {
        final resps = preguntas[i]['respuestas'] as List;
        if (resps[respuestasUsuario[i]!]['puntos'] != 1) {
          incorrect.add({
            'question': preguntas[i]['texto'],
            'explanation': preguntas[i]['explicacion'] ?? '',
            'userAnswer': resps[respuestasUsuario[i]!]['texto'],
            'correctAnswer': resps.firstWhere((r) => r['puntos'] == 1)['texto'],
          });
        }
      }
    }
    return incorrect;
  }

  List<Map<String, dynamic>> _getIncorrectAnswers() {
    List<Map<String, dynamic>> incorrect = [];
    for (int i = 0; i < preguntas.length; i++) {
      if (respuestasUsuario[i] != null) {
        final resps = preguntas[i]['respuestas'] as List;
        if (resps[respuestasUsuario[i]!]['puntos'] != 1) {
          incorrect.add({
            'question': preguntas[i]['texto'],
            'userAnswer': resps[respuestasUsuario[i]!]['texto'],
            'correctAnswer': resps.firstWhere((r) => r['puntos'] == 1)['texto'],
          });
        }
      }
    }
    return incorrect;
  }

  List<Map<String, dynamic>> _getAllQuestionsWithAnswers() {
    List<Map<String, dynamic>> allQuestions = [];
    for (int i = 0; i < preguntas.length; i++) {
      int? userAnswerIndex = respuestasUsuario[i];
      final resps = preguntas[i]['respuestas'] as List;
      
      // Find correct answer
      int correctIndex = -1;
      for (int j = 0; j < resps.length; j++) {
        if (resps[j]['puntos'] == 1) {
          correctIndex = j;
          break;
        }
      }
      
      allQuestions.add({
        'question': preguntas[i]['texto'],
        'explanation': preguntas[i]['explicacion'] ?? '',
        'userAnswer': userAnswerIndex != null ? resps[userAnswerIndex]['texto'] : 'Sin respuesta',
        'correctAnswer': correctIndex >= 0 ? resps[correctIndex]['texto'] : '',
        'isCorrect': userAnswerIndex != null && resps[userAnswerIndex]['puntos'] == 1,
      });
    }
    return allQuestions;
  }

  List<String> _getWeakTopics() {
    // This could be enhanced with actual topic analysis
    List<String> topics = [];
    final incorrect = _getIncorrectAnswers();
    if (incorrect.length > 2) {
      topics.add("Revisar conceptos fundamentales");
    }
    return topics;
  }

  String _formatearTextoPregunta(String textoOriginal) {
    String limpio = textoOriginal.replaceFirst(RegExp(r'^\d+[\.\s\-]*'), '').trim();
    return limpio;
  }

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esModoOscuro ? const Color(0xFF0F172A) : const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: Text('Streak: ${widget.tituloMateria}'),
        backgroundColor: esModoOscuro ? AppColors.darkAppBar : const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getColorTiempo().withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getColorTiempo(), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: _getColorTiempo(), size: 18),
                const SizedBox(width: 6),
                Text(
                  _formatearTiempo(_tiempoRestante),
                  style: TextStyle(
                    color: _getColorTiempo(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _tiempoAgotado 
          ? _buildTiempoAgotadoScreen()
          : Column(
              children: [
                LinearProgressIndicator(
                  value: (preguntaActual + 1) / preguntas.length,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.red,
                  minHeight: 6,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _formatearTextoPregunta(preguntas[preguntaActual]['texto']),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (preguntas[preguntaActual].containsKey('imagenes'))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: (preguntas[preguntaActual]['imagenes'] as List<String>).map((ruta) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: ZoomableImage(
                                    imagePath: ruta,
                                    onZoomChanged: (estaHabilitado) {},
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ...List<Map<String, dynamic>>.from(preguntas[preguntaActual]['respuestas'] as List).asMap().entries.map((entry) {
                          int idx = entry.key;
                          var respuesta = entry.value;
                          bool esSeleccionada = idx == indiceSeleccionado;
                          bool esCorrecta = respuesta['puntos'] == 1;
                          
                          Color? colorFondo;
                          Color colorTexto = esModoOscuro ? AppColors.darkText : Colors.black87;
                          Color colorBorde = esModoOscuro ? Colors.grey.shade600 : Colors.grey.shade300;
                          
                          if (respondido) {
                            if (esSeleccionada) {
                              colorFondo = esCorrecta 
                                  ? (esModoOscuro ? Colors.green.shade800 : Colors.green.shade100)
                                  : (esModoOscuro ? Colors.red.shade800 : Colors.red.shade100);
                              colorBorde = esCorrecta ? Colors.green : Colors.red;
                            } else if (esCorrecta) {
                              colorFondo = esModoOscuro ? Colors.green.shade900 : Colors.green.shade50;
                              colorBorde = Colors.green.shade300;
                            }
                          } else if (esSeleccionada) {
                            colorFondo = esModoOscuro ? Colors.red.shade800 : Colors.red.shade100;
                            colorBorde = Colors.red;
                          } else {
                            colorFondo = esModoOscuro ? AppColors.darkCard : Colors.white;
                          }
                          
                          return GestureDetector(
                            onTap: () => validarRespuesta(idx, respuesta['puntos']),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorFondo,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colorBorde, width: 2),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: esSeleccionada 
                                          ? (respondido 
                                              ? (esCorrecta ? Colors.green : Colors.red)
                                              : Colors.red)
                                          : Colors.grey.shade300,
                                      border: Border.all(color: colorBorde, width: 2),
                                    ),
                                    child: esSeleccionada
                                        ? Icon(
                                            respondido 
                                                ? (esCorrecta ? Icons.check : Icons.close)
                                                : Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      respuesta['texto'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: esSeleccionada ? FontWeight.bold : FontWeight.normal,
                                        color: colorTexto,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _tiempoAgotado 
          ? null 
          : Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: respondido ? _siguientePregunta : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: respondido ? Colors.red : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  respondido 
                      ? (preguntaActual < preguntas.length - 1 ? "Siguiente Pregunta" : "Ver Resultados")
                      : "Selecciona una respuesta",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Widget _buildTiempoAgotadoScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_off, color: Colors.red, size: 80),
          const SizedBox(height: 24),
          const Text(
            "¡Tiempo Agotado!",
            style: TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "El examen ha finalizado automáticamente",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// 8. PANTALLA DE RESULTADOS STREAK
class StreakResultPage extends StatelessWidget {
  final int puntaje;
  final int totalPreguntas;
  final String materia;
  final bool passed;
  final bool tiempoAgotado;
  final List<Map<String, dynamic>> incorrectAnswers;

  const StreakResultPage({
    super.key,
    required this.puntaje,
    required this.totalPreguntas,
    required this.materia,
    required this.passed,
    required this.tiempoAgotado,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    double porcentaje = puntaje / totalPreguntas;
    Color colorDinamico = passed ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.heart_broken,
                color: colorDinamico,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                passed ? "¡Sigue asi!" : "¡Ups!",
                style: TextStyle(
                  color: colorDinamico,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${(porcentaje * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$puntaje de $totalPreguntas correctas",
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 32),
              if (tiempoAgotado)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text(
                    "Tiempo agotado - finalizado automáticamente",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              const SizedBox(height: 32),
              if (incorrectAnswers.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Preguntas Incorrectas:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...incorrectAnswers.take(5).map((answer) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            answer['question'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (answer['explanation'] != null && answer['explanation'].toString().isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb, color: Colors.blue, size: 14),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      answer['explanation'],
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                "Tu respuesta: ",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              Expanded(
                                child: Text(
                                  answer['userAnswer'],
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                "Correcta: ",
                                style: TextStyle(color: Colors.green, fontSize: 12),
                              ),
                              Expanded(
                                child: Text(
                                  answer['correctAnswer'],
                                  style: const TextStyle(color: Colors.green, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Volver al Panel"),
                onPressed: () {
                  // Refresh the parent screen's data when returning
                  Navigator.pop(context, true); // Pass true to indicate data should be refreshed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 9. PANTALLA HISTORIAL DE EXÁMENES
class PantallaHistorialExamenes extends StatefulWidget {
  const PantallaHistorialExamenes({super.key});

  @override
  State<PantallaHistorialExamenes> createState() => _PantallaHistorialExamenesState();
}

class _PantallaHistorialExamenesState extends State<PantallaHistorialExamenes> {
  List<ExamResult> _examHistory = [];
  Map<String, Map<String, int>> _subjectStats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExamHistory();
  }

  Future<void> _loadExamHistory() async {
    final history = await StorageService.getExamHistory();
    
    // Calculate subject-level statistics
    Map<String, Map<String, int>> subjectStats = {};
    for (var exam in history) {
      if (!subjectStats.containsKey(exam.subject)) {
        subjectStats[exam.subject] = {'correct': 0, 'total': 0};
      }
      subjectStats[exam.subject]!['correct'] = (subjectStats[exam.subject]!['correct'] ?? 0) + exam.score;
      subjectStats[exam.subject]!['total'] = (subjectStats[exam.subject]!['total'] ?? 0) + exam.totalQuestions;
    }
    
    if (mounted) {
      setState(() {
        _examHistory = history;
        _subjectStats = subjectStats;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esModoOscuro ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Historial de Exámenes"),
        backgroundColor: esModoOscuro ? AppColors.darkAppBar : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_subjectStats.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: esModoOscuro ? Colors.red.withOpacity(0.2) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text(
                              "Efectividad por materia",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._subjectStats.entries.map((entry) {
                          final stats = entry.value;
                          final correct = stats['correct'] ?? 0;
                          final total = stats['total'] ?? 0;
                          final percentage = total > 0 ? (correct / total * 100).round() : 0;
                          final failureRate = 100 - percentage;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: percentage >= 70 ? Colors.green : (percentage >= 50 ? Colors.orange : Colors.red),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "✓ $percentage%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: percentage >= 70 ? Colors.green : (percentage >= 50 ? Colors.orange : Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "✗ $failureRate%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                Expanded(
                  child: _examHistory.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "No hay exámenes registrados",
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _examHistory.length,
                          itemBuilder: (context, index) {
                            final exam = _examHistory[index];
                            double porcentaje = exam.score / exam.totalQuestions;
                            Color colorScore = porcentaje >= 0.7 ? Colors.green : (porcentaje >= 0.5 ? Colors.orange : Colors.red);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              color: esModoOscuro ? AppColors.darkCard : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExamDetailScreen(exam: exam),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: colorScore,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${(porcentaje * 100).toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exam.subject,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: esModoOscuro ? AppColors.darkText : Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              "${exam.mode.toUpperCase()} • ${_formatDate(exam.date)}",
                                              style: TextStyle(
                                                color: esModoOscuro ? AppColors.darkTextSecondary : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${exam.score}/${exam.totalQuestions}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: esModoOscuro ? AppColors.darkText : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
          );
  }
}

// 10. PANTALLA DE DETALLE DE EXAMEN
class ExamDetailScreen extends StatelessWidget {
  final ExamResult exam;

  const ExamDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: esModoOscuro ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Detalle: ${exam.subject}"),
        backgroundColor: esModoOscuro ? AppColors.darkAppBar : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exam.allQuestions.length,
        itemBuilder: (context, index) {
          final questionData = exam.allQuestions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: esModoOscuro ? AppColors.darkCard : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        questionData['isCorrect'] ? Icons.check_circle : Icons.cancel,
                        color: questionData['isCorrect'] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          questionData['question'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: esModoOscuro ? AppColors.darkText : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (questionData['explanation'] != null && questionData['explanation'].toString().isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: esModoOscuro ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb, color: Colors.blue, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "Explicación:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: esModoOscuro ? Colors.blue.shade300 : Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            questionData['explanation'],
                            style: TextStyle(
                              fontSize: 13,
                              color: esModoOscuro ? AppColors.darkTextSecondary : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnswerRow(
                          "Tu respuesta",
                          questionData['userAnswer'],
                          Colors.red,
                          esModoOscuro,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAnswerRow(
                          "Correcta",
                          questionData['correctAnswer'],
                          Colors.green,
                          esModoOscuro,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color color, bool esModoOscuro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: TextStyle(
            fontSize: 12,
            color: esModoOscuro ? AppColors.darkTextSecondary : Colors.black54,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// PANTALLA "ACERCA DE LA APLICACIÓN"
// =============================================================

class PantallaAcercaDe extends StatelessWidget {
  const PantallaAcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: esModoOscuro ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Acerca de la aplicación'),
        backgroundColor: esModoOscuro ? AppColors.darkAppBar : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.flight,
                    size: 80,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ' EOV  -  Quiz App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: esModoOscuro ? AppColors.darkText : AppColors.lightText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sistema integral de estudio',
                    style: TextStyle(
                      fontSize: 14,
                      color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // App Overview
            _buildSection(
              esModoOscuro,
              '📱 Sobre la Aplicación',
              'Esta aplicación está diseñada para ayudar a los estudiantes a preparar sus exámenes teóricos de manera interactiva y efectiva. Cuenta con múltiples modos de estudio, seguimiento de progreso, y un sistema de racha para mantener la constancia en el aprendizaje.',
            ),
            
            const SizedBox(height: 16),
            
            // Evaluation Criteria Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: esModoOscuro ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: esModoOscuro ? Colors.blue.withOpacity(0.3) : Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Recuerda que el criterio de evaluacion de los examenes son en base al banco de preguntas directo de la DGAC - EOV (2021)",
                      style: TextStyle(
                        fontSize: 13,
                        color: esModoOscuro ? Colors.white70 : Colors.black87,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Subjects Section
            _buildSection(
              esModoOscuro,
              '📚 Materias Disponibles',
              'La aplicación cubre las siguientes materias esenciales para la formación de nuestros estudiantes:',
            ),
            const SizedBox(height: 12),
            _buildSubjectCard(esModoOscuro, 'Aerodinámica', 'Principios de vuelo, fuerzas aerodinámicas, performance de la aeronave'),
            _buildSubjectCard(esModoOscuro, 'Performance y Motores', 'Operación de motores, sistemas de propulsión, limitaciones de performance'),
            _buildSubjectCard(esModoOscuro, 'Operaciones de Vuelo', 'Procedimientos de vuelo, navegación, comunicaciones'),
            _buildSubjectCard(esModoOscuro, 'Peso y Balance', 'Cálculo de peso, balanceo de la aeronave, limitaciones de carga'),
            _buildSubjectCard(esModoOscuro, 'Meteorología', 'Fenómenos meteorológicos, interpretación de cartas, seguridad meteorológica'),
            _buildSubjectCard(esModoOscuro, 'Reglamentación', 'Normativas aéreas, regulaciones de vuelo, procedimientos regulatorios'),
            
            const SizedBox(height: 24),
            
            // Study Modes Section
            _buildSection(
              esModoOscuro,
              '🎯 Modos de Estudio',
              'La aplicación ofrece tres modos de estudio adaptados a diferentes necesidades:',
            ),
            const SizedBox(height: 12),
            _buildModeCard(
              esModoOscuro,
              'Modo Práctica',
              Icons.school,
              Colors.blue,
              'Retroalimentación inmediata en cada pregunta. Ideal para aprender y reforzar conocimientos. Puedes ver la respuesta correcta y explicación al instante.',
            ),
            _buildModeCard(
              esModoOscuro,
              'Modo Test (Examen)',
              Icons.timer_outlined,
              Colors.orange,
              'Simula un examen real. El solucionario solo se muestra al finalizar. Perfecto para evaluar tu nivel de preparación.',
            ),
            _buildModeCard(
              esModoOscuro,
              'Modo Racha',
              Icons.local_fire_department,
              Colors.red,
              'Examen cronometrado de racha diaria. Completa 1 examen por día (≥60% de aciertos) para mantener tu racha activa. Sistema de vidas y desafío constante.',
            ),
            
            const SizedBox(height: 24),
            
            // Streak System
            _buildSection(
              esModoOscuro,
              '🔥 Sistema de Racha',
              'El sistema de racha te motiva a estudiar diariamente:',
            ),
            const SizedBox(height: 12),
            _buildStreakFeature(esModoOscuro, '1 examen diario', 'Completa 1 examen con ≥60% de aciertos por día'),
            _buildStreakFeature(esModoOscuro, '3 vidas con recarga individual', 'Tienes 3 vidas. Cada vida se recarga en 8 horas cuando la pierdes'),
            _buildStreakFeature(esModoOscuro, 'Pérdida de vida', 'Si fallas un examen (<60%), pierdes una vida. Puedes ver el tiempo de recarga de cada vida'),
            _buildStreakFeature(esModoOscuro, 'Preguntas aleatorias', 'Cada examen presenta preguntas diferentes para mantener el desafío'),
            _buildStreakFeature(esModoOscuro, 'Tiempo limitado', '2 minutos por pregunta para simular condiciones reales de examen'),
            
            const SizedBox(height: 24),
            
            // Progress System
            _buildSection(
              esModoOscuro,
              '📊 Sistema de Progreso',
              'La aplicación guarda tu progreso de estudio individualmente por materia:',
            ),
            const SizedBox(height: 12),
            _buildProgressFeature(esModoOscuro, 'Progreso por materia', 'Cada materia guarda su propio progreso de estudio'),
            _buildProgressFeature(esModoOscuro, 'Indicadores visuales', 'Barras de progreso circulares en cada tarjeta de materia'),
            _buildProgressFeature(esModoOscuro, 'Continuar estudiando', 'Reanuda desde donde lo dejaste en cada materia'),
            _buildProgressFeature(esModoOscuro, 'Sincronización en múltplies dispositivos', 'Tu progreso se guarda en la nube y se recupera al iniciar sesión'),
            _buildProgressFeature(esModoOscuro, 'Historial de exámenes', 'Registro completo de todos tus exámenes realizados'),
            
            const SizedBox(height: 24),
            
            // Features
            
            
            // How to Use
            _buildSection(
              esModoOscuro,
              '🚀 Cómo Usar la Aplicación',
              'Pasos para comenzar tu estudio:',
            ),
            const SizedBox(height: 12),
            _buildStep(esModoOscuro, '1', 'Selecciona una materia del panel principal'),
            _buildStep(esModoOscuro, '2', 'Elige tu modo de estudio (Práctica, Test o Racha)'),
            _buildStep(esModoOscuro, '3', 'Responde las preguntas dentro del tiempo límite'),
            _buildStep(esModoOscuro, '4', 'Revisa tus resultados y explicaciones al finalizar'),
            _buildStep(esModoOscuro, '5', 'Sigue tu progreso y mantén tu racha diaria'),
            
            const SizedBox(height: 32),
            
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 12,
                      color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 12,
                      color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(bool esModoOscuro, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: esModoOscuro ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(bool esModoOscuro, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: esModoOscuro ? AppColors.darkCard : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: esModoOscuro ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(bool esModoOscuro, String title, IconData icon, Color color, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: esModoOscuro ? AppColors.darkCard : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: esModoOscuro ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

  Widget _buildStreakFeature(bool esModoOscuro, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              '$title: $description',
              style: TextStyle(
                fontSize: 13,
                color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressFeature(bool esModoOscuro, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              '$title: $description',
              style: TextStyle(
                fontSize: 13,
                color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStep(bool esModoOscuro, String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: esModoOscuro ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
