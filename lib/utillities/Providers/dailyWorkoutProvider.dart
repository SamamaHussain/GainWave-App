import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyWorkoutProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save workout data to Firebase
  Future<void> saveWorkoutData(Map<String, dynamic> workoutData) async {
    if (currentUserId == null) {
      throw Exception('No user signed in');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Reference to the specific document in the nested collection
      final docRef = _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(workoutData['date']);
      
      // Check if document already exists
      final docSnapshot = await docRef.get();
      
      if (docSnapshot.exists) {
        // If document exists with the same date, update it with the new workout
        // In a real app, you might want to add this to an array of workouts for the day
        // or handle it differently based on your requirements
        await docRef.update({
          'exercises': FieldValue.arrayUnion([{
            'exerciseName': workoutData['exerciseName'],
            'muscleGroup': workoutData['muscleGroup'],
            'sets': workoutData['sets'],
            'reps': workoutData['reps'],
            'weight': workoutData['weight'],
            'restTime': workoutData['restTime'],
            'workoutDuration': workoutData['workoutDuration'],
            'timestamp': FieldValue.serverTimestamp(),
          }])
        });
      } else {
        // If document doesn't exist, create a new one
        await docRef.set({
          'date': workoutData['date'],
          'exercises': [{
            'exerciseName': workoutData['exerciseName'],
            'muscleGroup': workoutData['muscleGroup'],
            'sets': workoutData['sets'],
            'reps': workoutData['reps'],
            'weight': workoutData['weight'],
            'restTime': workoutData['restTime'],
            'workoutDuration': workoutData['workoutDuration'],
            'timestamp': FieldValue.serverTimestamp(),
          }]
        });
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Get all workout data for the current user
  Future<List<Map<String, dynamic>>> getAllWorkouts() async {
    if (currentUserId == null) {
      throw Exception('No user signed in');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .orderBy('date', descending: true)
          .get();
      
      _isLoading = false;
      notifyListeners();
      
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Get workouts for a specific date
  Future<Map<String, dynamic>?> getWorkoutByDate(String date) async {
    if (currentUserId == null) {
      throw Exception('No user signed in');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(date)
          .get();
      
      _isLoading = false;
      notifyListeners();
      
      if (docSnapshot.exists) {
        return {
          'id': docSnapshot.id,
          ...docSnapshot.data()!,
        };
      } else {
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Delete a workout entry
  Future<void> deleteWorkout(String date) async {
    if (currentUserId == null) {
      throw Exception('No user signed in');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(date)
          .delete();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Delete a specific exercise from a workout day
  Future<void> deleteExercise(String date, int exerciseIndex) async {
    if (currentUserId == null) {
      throw Exception('No user signed in');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // First, get the current document
      final docRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(date);
          
      final docSnapshot = await docRef.get();
      
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        List<dynamic> exercises = List.from(data['exercises'] ?? []);
        
        if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
          exercises.removeAt(exerciseIndex);
          
          // If no exercises left, delete the whole document
          if (exercises.isEmpty) {
            await docRef.delete();
          } else {
            // Otherwise update with the modified list
            await docRef.update({
              'exercises': exercises,
            });
          }
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
}