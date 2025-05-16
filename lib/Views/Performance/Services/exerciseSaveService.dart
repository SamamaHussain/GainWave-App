import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirebaseWorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save workout data to Firebase
  Future<bool> saveWorkoutData({
    required String exerciseName,
    required String muscleGroup,
    required int reps,
    required int sets,
    required String workoutDuration,
    required String restTime,
    required int weight,
  }) async {
    try {
      // Check if user is logged in
      if (currentUserId == null) {
        print('Error: No user is currently logged in');
        return false;
      }

      // Get today's date formatted as a string (YYYY-MM-DD)
      final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Create the workout document
      await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('dailyWorkoutData')
          .doc(todayDate)
          .collection('workouts')
          .add({
            'exerciseName': exerciseName,
            'muscleGroup': muscleGroup,
            'reps': reps,
            'sets': sets,
            'workoutDuration': workoutDuration,
            'restTime': restTime,
            'weight': weight,
            'createdAt': FieldValue.serverTimestamp(),
          });
      
      // Check if this is the first workout for today, create a temporary data field
      // in the parent document if it's being created today
      await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('dailyWorkoutData')
          .doc(todayDate)
          .set({
            'tempData': 'Temporary workout data for tracking',
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Error saving workout data: $e');
      return false;
    }
  }
}