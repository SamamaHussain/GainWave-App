// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DailyWorkoutService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
  
//   // Get current user ID
//   String? get currentUserId => _auth.currentUser?.uid;

//   // Save workout data to Firebase
//   Future<void> saveWorkoutData(Map<String, dynamic> workoutData) async {
//     if (currentUserId == null) {
//       throw Exception('No user signed in');
//     }
    
//     try {
//       // Reference to the specific document in the nested collection
//       final docRef = _firestore
//           .collection('user')
//           .doc(currentUserId)
//           .collection('Daily_Workout_Data')
//           .doc(workoutData['date']);
      
//       // Save each field directly
//       await docRef.set({
//         'date': workoutData['date'],
//         'exerciseName': workoutData['exerciseName'],
//         'muscleGroup': workoutData['muscleGroup'],
//         'sets': workoutData['sets'],
//         'reps': workoutData['reps'],
//         'weight': workoutData['weight'],
//         'restTime': workoutData['restTime'],
//         'workoutDuration': workoutData['workoutDuration'],
//         'timestamp': Timestamp.now(),
//       });
//     } catch (e) {
//       throw e;
//     }
//   }

//   // Get all workout data for the current user
//   Future<List<Map<String, dynamic>>> getAllWorkouts() async {
//     if (currentUserId == null) {
//       throw Exception('No user signed in');
//     }
    
//     try {
//       final querySnapshot = await _firestore
//           .collection('user')
//           .doc(currentUserId)
//           .collection('Daily_Workout_Data')
//           .orderBy('date', descending: true)
//           .get();
      
//       return querySnapshot.docs
//           .map((doc) => {
//                 'id': doc.id,
//                 ...doc.data(),
//               })
//           .toList();
//     } catch (e) {
//       throw e;
//     }
//   }

//   // Get workout for a specific date
//   Future<Map<String, dynamic>?> getWorkoutByDate(String date) async {
//     if (currentUserId == null) {
//       throw Exception('No user signed in');
//     }
    
//     try {
//       final docSnapshot = await _firestore
//           .collection('user')
//           .doc(currentUserId)
//           .collection('Daily_Workout_Data')
//           .doc(date)
//           .get();
      
//       if (docSnapshot.exists) {
//         return {
//           'id': docSnapshot.id,
//           ...docSnapshot.data()!,
//         };
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw e;
//     }
//   }

//   // Delete a workout entry
//   Future<void> deleteWorkout(String date) async {
//     if (currentUserId == null) {
//       throw Exception('No user signed in');
//     }
    
//     try {
//       await _firestore
//           .collection('user')
//           .doc(currentUserId)
//           .collection('Daily_Workout_Data')
//           .doc(date)
//           .delete();
//     } catch (e) {
//       throw e;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DailyWorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save workout data to Firebase
  Future<void> saveWorkoutData(DateTime date, Map<String, dynamic> workoutData) async {
    // Ensure user is logged in
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Format date as string for document ID - format as YYYY-MM-DD
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      // Reference to user's workout collection
      final userWorkoutRef = _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data');
      
      // Add workout data with date as document ID
      await userWorkoutRef.doc(formattedDate).set(workoutData);
    } catch (e) {
      // Re-throw the exception to be handled by the UI
      throw Exception('Failed to save workout data: ${e.toString()}');
    }
  }

  // Get workout data for a specific date
  Future<Map<String, dynamic>?> getWorkoutData(DateTime date) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      final docSnapshot = await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(formattedDate)
          .get();
      
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch workout data: ${e.toString()}');
    }
  }

  // Get all workout data for the current user
  Future<List<Map<String, dynamic>>> getAllWorkoutData() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all workout data: ${e.toString()}');
    }
  }

  // Delete workout data for a specific date
  Future<void> deleteWorkoutData(String dateId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('user')
          .doc(currentUserId)
          .collection('Daily_Workout_Data')
          .doc(dateId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete workout data: ${e.toString()}');
    }
  }


}