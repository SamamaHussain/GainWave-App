// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/Views/Daiy%20Workout/workoutDetailScreen.dart';
// import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
// import 'package:intl/intl.dart';

// class WorkoutHistoryScreen extends StatefulWidget {
//   const WorkoutHistoryScreen({Key? key}) : super(key: key);

//   @override
//   State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
// }

// class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
//   late Future<List<Map<String, dynamic>>> _workoutsFuture;
//   bool _isLoading = false;
  
//   // Create an instance of our service
//   final DailyWorkoutService _workoutService = DailyWorkoutService();

//   @override
//   void initState() {
//     super.initState();
//     _loadWorkouts();
//   }

//   void _loadWorkouts() {
//     setState(() {
//       _isLoading = true;
//     });
//     // Use the service directly instead of Provider
//     _workoutsFuture = _workoutService.getAllWorkouts();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _deleteWorkout(String date) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Workout'),
//         content: Text('Are you sure you want to delete the workout from $date?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               setState(() {
//                 _isLoading = true;
//               });
              
//               try {
//                 // Use the service directly instead of Provider
//                 await _workoutService.deleteWorkout(date);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Workout deleted successfully')),
//                 );
//                 _loadWorkouts(); // Refresh the list
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error deleting workout: $e')),
//                 );
//               } finally {
//                 setState(() {
//                   _isLoading = false;
//                 });
//               }
//             },
//             child: const Text('DELETE'),
//           ),
//         ],
//       ),
//     );
//   }



//   String _formatDate(String dateStr) {
//     try {
//       final date = DateFormat('yyyy-MM-dd').parse(dateStr);
//       return DateFormat('EEEE, MMM d, yyyy').format(date);
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Workout History'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadWorkouts,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: _workoutsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error_outline, size: 60, color: Colors.red),
//                         const SizedBox(height: 16),
//                         Text('Error: ${snapshot.error}'),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _loadWorkouts,
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 final workouts = snapshot.data ?? [];

//                 if (workouts.isEmpty) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.fitness_center, size: 80, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text(
//                           'No workouts recorded yet',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Start logging your workouts to see them here',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

// return             
//                 ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: workouts.length,
//                   itemBuilder: (context, index) {
//                     final workout = workouts[index];
//                     final dateStr = workout['date'] as String;
//                     final exerciseName = workout['exerciseName'] as String? ?? 'Unknown Exercise';
//                     final muscleGroup = workout['muscleGroup'] as String? ?? 'Unknown Muscle Group';

//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         leading: CircleAvatar(
//                           backgroundColor: Theme.of(context).colorScheme.primary,
//                           child: const Icon(Icons.fitness_center, color: Colors.white),
//                         ),
//                         title: Text(
//                           _formatDate(dateStr),
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text('Exercise: $exerciseName'),
//                             Text('Muscle Group: $muscleGroup'),
//                           ],
//                         ),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteWorkout(dateStr),
//                           tooltip: 'Delete Workout',
//                         ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => WorkoutDetailScreen(workoutData: workout),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pop(context); // Go back to add workout screen
//         },
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//         child: const Icon(Icons.add),
//         tooltip: 'Add New Workout',
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Daiy%20Workout/workoutDetailScreen.dart';
import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({Key? key}) : super(key: key);

  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final DailyWorkoutService _dailyWorkoutService = DailyWorkoutService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _workouts = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final workouts = await _dailyWorkoutService.getAllWorkoutData();
      setState(() {
        _workouts = workouts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load workouts: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteWorkout(String dateId, int index) async {
    // Show confirmation dialog
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmDelete) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _dailyWorkoutService.deleteWorkoutData(dateId);
      
      // Update the UI by removing the deleted workout
      setState(() {
        _workouts.removeAt(index);
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete workout: ${e.toString()}')),
      );
    }
  }

  // Helper method to format timestamp
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    
    try {
      if (timestamp is DateTime) {
        return DateFormat('EEEE, MMM d, yyyy').format(timestamp);
      } else if (timestamp.runtimeType.toString().contains('Timestamp')) {
        // Convert Firestore timestamp to DateTime
        return DateFormat('EEEE, MMM d, yyyy').format(timestamp.toDate());
      } else {
        // Try to parse from string format (YYYY-MM-DD)
        return DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(timestamp));
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorkouts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWorkouts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _workouts.isEmpty
                  ? const Center(
                      child: Text(
                        'No workouts found.\nStart tracking your workouts!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadWorkouts,
                      child: ListView.builder(
                        itemCount: _workouts.length,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final workout = _workouts[index];
                          final dateId = workout['id'] ?? '';
                          final exerciseName = workout['exerciseName'] ?? 'Unknown exercise';
                          final muscleGroup = workout['muscleGroup'] ?? 'Unknown';
                          
                          // Display date from document ID or createdAt
                          final displayDate = workout['id'] != null
                              ? _formatDate(workout['id'])
                              : _formatDate(workout['createdAt']);

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                exerciseName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(displayDate),
                                  Text('Muscle group: $muscleGroup'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteWorkout(dateId, index),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetailScreen(workout: workout),
                                  ),
                                ).then((_) => _loadWorkouts()); // Refresh after returning
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
