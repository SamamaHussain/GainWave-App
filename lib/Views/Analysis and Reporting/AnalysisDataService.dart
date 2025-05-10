import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get daily workout data for the last 7 days
  Future<List<Map<String, dynamic>>> getDailyWorkoutData() async {
    if (currentUserId == null) return [];

    try {
      // Calculate date range (last 7 days)
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Query Firebase to get main workout date documents
      final dateDocsSnapshot = await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .get();

      // Organize data by date
      final Map<String, Map<String, dynamic>> workoutsByDate = {};
      
      // Process each date document
      for (var dateDoc in dateDocsSnapshot.docs) {
        final dateId = dateDoc.id;
        
        // Get the workouts subcollection for this date
        final workoutsSnapshot = await _firestore
            .collection('user')
            .doc(currentUserId)
            .collection('dailyWorkoutData')
            .doc(dateId)
            .collection('workouts')
            .get();
            
        // Skip if no workouts for this date or if outside our 7-day window
        if (workoutsSnapshot.docs.isEmpty) continue;
        
        // Initialize date entry
        workoutsByDate[dateId] = {
          'date': dateId,
          'totalSets': 0,
          'totalReps': 0,
          'totalWorkoutDuration': 0,
          'workouts': [],
        };
        
        // Process each workout in this date
        for (var workoutDoc in workoutsSnapshot.docs) {
          final workoutData = workoutDoc.data();
          final timestamp = workoutData['createdAt'] as Timestamp;
          final workoutDate = timestamp.toDate();
          
          // Skip workouts older than 7 days
          if (workoutDate.isBefore(sevenDaysAgo)) continue;
          
          // Add workout data to totals
          workoutsByDate[dateId]!['totalSets'] += workoutData['sets'] ?? 0;
          workoutsByDate[dateId]!['totalReps'] += workoutData['reps'] ?? 0;
          
          // Parse workout duration (assuming it's stored as string)
          int duration = 0;
          try {
            duration = int.parse(workoutData['workoutDuration'] ?? '0');
          } catch (e) {
            // Handle parsing error
            debugPrint('Error parsing workout duration: $e');
          }
          workoutsByDate[dateId]!['totalWorkoutDuration'] += duration;
          
          // Add individual workout data
          workoutsByDate[dateId]!['workouts'].add(workoutData);
        }
        
        // If no workouts within date range were found, remove this date
        if ((workoutsByDate[dateId]!['workouts'] as List).isEmpty) {
          workoutsByDate.remove(dateId);
        }
      }
      
      // Convert to list and return
      return workoutsByDate.values.toList();
    } catch (e) {
      debugPrint('Error getting daily workout data: $e');
      return [];
    }
  }

  // Get muscle volume data for the last 4 weeks
  Future<List<Map<String, dynamic>>> getMuscleVolumeData() async {
    if (currentUserId == null) return [];

    try {
      // Calculate date range (last 4 weeks)
      final now = DateTime.now();
      final fourWeeksAgo = now.subtract(const Duration(days: 28));

      // Query Firebase
      final snapshot = await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Weekly Muscle Volume')
          .get();

      // Process data
      final List<Map<String, dynamic>> volumeData = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        // Parse date
        DateTime? date;
        try {
          date = DateFormat('yyyy-MM-dd').parse(data['Date'] ?? '');
        } catch (e) {
          // Handle parsing error
          debugPrint('Error parsing date: $e');
          continue;
        }
        
        // Only include data from the last 4 weeks
        if (date.isAfter(fourWeeksAgo)) {
          volumeData.add({
            'date': data['Date'],
            'volume': data['Volume'] ?? 0,
          });
        }
      }
      
      // Sort by date
      volumeData.sort((a, b) => 
        DateFormat('yyyy-MM-dd').parse(a['date']).compareTo(
          DateFormat('yyyy-MM-dd').parse(b['date'])
        )
      );
      
      return volumeData;
    } catch (e) {
      debugPrint('Error getting muscle volume data: $e');
      return [];
    }
  }

  // Get summary of workout data grouped by muscle group
  Future<Map<String, int>> getMuscleGroupSummary() async {
    if (currentUserId == null) return {};

    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Get all date documents
      final dateDocsSnapshot = await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('dailyWorkoutData')
          .get();
      
      final Map<String, int> muscleGroupCount = {};
      
      // For each date, get its workouts
      for (var dateDoc in dateDocsSnapshot.docs) {
        final workoutsSnapshot = await _firestore
            .collection('user')
            .doc(currentUserId)
            .collection('dailyWorkoutData')
            .doc(dateDoc.id)
            .collection('workouts')
            .get();
            
        for (var workoutDoc in workoutsSnapshot.docs) {
          final workoutData = workoutDoc.data();
          final timestamp = workoutData['createdAt'] as Timestamp;
          
          // Skip if workout is too old
          if (timestamp.toDate().isBefore(thirtyDaysAgo)) continue;
          
          final muscleGroup = workoutData['muscleGroup'] as String? ?? 'Unknown';
          muscleGroupCount[muscleGroup] = (muscleGroupCount[muscleGroup] ?? 0) + 1;
        }
      }
      
      return muscleGroupCount;
    } catch (e) {
      debugPrint('Error getting muscle group summary: $e');
      return {};
    }
  }
}