import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutStats {
  static final WorkoutStats _instance = WorkoutStats._internal();
  factory WorkoutStats() => _instance;
  WorkoutStats._internal();

  // Total time spent exercising in seconds
  int _totalTimeExercised = 0;
  
  // Stream controller to broadcast changes
  final _controller = StreamController<int>.broadcast();
  Stream<int> get timeStream => _controller.stream;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters
  int get totalTimeExercised => _totalTimeExercised;

  // Method to add exercise time
  void addExerciseTime(int seconds) {
    _totalTimeExercised += seconds;
    _controller.add(_totalTimeExercised);
    _saveStats();
  }

  // Load stats from Firestore
  Future<void> loadStats() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('User not authenticated');
        return;
      }

      final doc = await _firestore
          .collection('user_workout_stats')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _totalTimeExercised = data?['totalTimeExercised'] ?? 0;
          _controller.add(_totalTimeExercised);
        });
      }
    } catch (e) {
      print('Error loading workout stats: $e');
    }
  }

  // Save stats to Firestore
  Future<void> _saveStats() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('User not authenticated');
        return;
      }

      await _firestore
          .collection('user_workout_stats')
          .doc(userId)
          .set({
            'totalTimeExercised': _totalTimeExercised,
            'lastUpdated': FieldValue.serverTimestamp(),
            'formattedTime': getFormattedTotalTime(),
          }, SetOptions(merge: true));

      print('Workout stats saved to Firestore');
    } catch (e) {
      print('Error saving workout stats: $e');
    }
  }

  // Get formatted time string
  String getFormattedTotalTime() {
    final hours = (_totalTimeExercised / 3600).floor();
    final minutes = ((_totalTimeExercised % 3600) / 60).floor();
    final seconds = _totalTimeExercised % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Clear all data (for testing)
  Future<void> resetStats() async {
    _totalTimeExercised = 0;
    _controller.add(_totalTimeExercised);
    await _saveStats();
  }

  // Dispose of stream controller
  void dispose() {
    _controller.close();
  }

  // Helper method for state management
  void setState(void Function() fn) {
    fn();
    _controller.add(_totalTimeExercised);
  }
}