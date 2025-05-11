import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DailyWorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  // Convert DateTime to string format for document ID
  String _formatDateForDocId(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Save workout data to Firestore
  Future<void> saveWorkoutData(DateTime date, Map<String, dynamic> workoutData) async {
    final dateId = _formatDateForDocId(date);
    
    try {
      // Add workout to the workouts subcollection for the specific date
      await _firestore
          .collection('user')
          .doc(_userId)
          .collection('dailyWorkoutData')
          .doc(dateId)
          .collection('workouts')
          .add(workoutData);
    } catch (e) {
      throw Exception('Failed to save workout: $e');
    }
  }

  // Get all workout data grouped by date
  Future<List<Map<String, dynamic>>> getAllWorkoutData() async {
    List<Map<String, dynamic>> result = [];
    
    try {
      // Get all date documents
      final datesSnapshot = await _firestore
          .collection('user')
          .doc(_userId)
          .collection('dailyWorkoutData')
          .get();
      
      // For each date, get all workouts
      for (var dateDoc in datesSnapshot.docs) {
        final dateId = dateDoc.id;
        
        // Get workouts for this date
        final workoutsSnapshot = await _firestore
            .collection('user')
            .doc(_userId)
            .collection('dailyWorkoutData')
            .doc(dateId)
            .collection('workouts')
            .orderBy('createdAt', descending: true)
            .get();
        
        // Add each workout with its date ID
        for (var workoutDoc in workoutsSnapshot.docs) {
          final workoutData = workoutDoc.data();
          workoutData['id'] = dateId; // Add date as ID
          workoutData['workoutId'] = workoutDoc.id; // Add workout document ID
          result.add(workoutData);
        }
      }
      
      // Sort by createdAt (newest first)
      result.sort((a, b) {
        final aDate = a['createdAt'] as Timestamp;
        final bDate = b['createdAt'] as Timestamp;
        return bDate.compareTo(aDate);
      });
      
      return result;
    } catch (e) {
      throw Exception('Failed to get workout data: $e');
    }
  }

  // Get workouts for a specific date
  Future<List<Map<String, dynamic>>> getWorkoutsForDate(DateTime date) async {
    final dateId = _formatDateForDocId(date);
    List<Map<String, dynamic>> workouts = [];
    
    try {
      final workoutsSnapshot = await _firestore
          .collection('user')
          .doc(_userId)
          .collection('dailyWorkoutData')
          .doc(dateId)
          .collection('workouts')
          .orderBy('createdAt', descending: true)
          .get();
      
      for (var doc in workoutsSnapshot.docs) {
        final workoutData = doc.data();
        workoutData['id'] = dateId; // Add date as ID
        workoutData['workoutId'] = doc.id; // Add workout document ID
        workouts.add(workoutData);
      }
      
      return workouts;
    } catch (e) {
      throw Exception('Failed to get workouts for date: $e');
    }
  }

  // Delete a specific workout
  Future<void> deleteWorkoutData(String dateId, String workoutId) async {
    try {
      await _firestore
          .collection('user')
          .doc(_userId)
          .collection('dailyWorkoutData')
          .doc(dateId)
          .collection('workouts')
          .doc(workoutId)
          .delete();
      
      // Check if there are any workouts left for this date
      final remainingWorkouts = await _firestore
          .collection('user')
          .doc(_userId)
          .collection('dailyWorkoutData')
          .doc(dateId)
          .collection('workouts')
          .limit(1)
          .get();
      
      // If no workouts left, delete the date document
      if (remainingWorkouts.docs.isEmpty) {
        await _firestore
            .collection('user')
            .doc(_userId)
            .collection('dailyWorkoutData')
            .doc(dateId)
            .delete();
      }
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }
}