// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// // No need to import the service here since this screen just displays data passed to it

// class WorkoutDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> workoutData;

//   const WorkoutDetailScreen({
//     Key? key,
//     required this.workoutData,
//   }) : super(key: key);

//   String _formatDate(String dateStr) {
//     try {
//       final date = DateFormat('yyyy-MM-dd').parse(dateStr);
//       return DateFormat('EEEE, MMMM d, yyyy').format(date);
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dateStr = workoutData['date'] as String? ?? 'Unknown Date';
//     final exerciseName = workoutData['exerciseName'] as String? ?? 'Unknown Exercise';
//     final muscleGroup = workoutData['muscleGroup'] as String? ?? 'Unknown Muscle Group';
//     final sets = workoutData['sets']?.toString() ?? 'N/A';
//     final reps = workoutData['reps']?.toString() ?? 'N/A';
//     final weight = workoutData['weight']?.toString() ?? 'N/A';
//     final restTime = workoutData['restTime'] as String? ?? 'N/A';
//     final workoutDuration = workoutData['workoutDuration'] as String? ?? 'N/A';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_formatDate(dateStr)),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with date and exercise name
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.fitness_center,
//                       size: 50,
//                       color: Colors.blueAccent,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       exerciseName,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       muscleGroup,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey[600],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // Workout details
//             Card(
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Workout Details',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(Icons.repeat, 'Sets', sets),
//                     const Divider(),
//                     _buildDetailRow(Icons.fitness_center, 'Reps', reps),
//                     const Divider(),
//                     _buildDetailRow(Icons.monitor_weight_outlined, 'Weight', '$weight kg/lbs'),
//                     const Divider(),
//                     _buildDetailRow(Icons.timer, 'Rest Time', restTime),
//                     const Divider(),
//                     _buildDetailRow(Icons.access_time, 'Duration', workoutDuration),
//                   ],
//                 ),
//               ),
//             ),
            
//             const SizedBox(height: 30),
            
//             // Motivational quote
//             Card(
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//               elevation: 0,
//               child: const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.emoji_emotions,
//                       size: 28,
//                       color: Colors.amber,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '"The only bad workout is the one that didn\'t happen."',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 24,
//             color: Colors.blueAccent,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  // Helper method to format timestamp or date string
  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';
    
    try {
      if (date is DateTime) {
        return DateFormat('EEEE, MMMM d, yyyy').format(date);
      } else if (date.runtimeType.toString().contains('Timestamp')) {
        // Convert Firestore timestamp to DateTime
        return DateFormat('EEEE, MMMM d, yyyy').format(date.toDate());
      } else if (date is String) {
        // Try to parse from string format (expecting YYYY-MM-DD)
        try {
          return DateFormat('EEEE, MMMM d, yyyy').format(DateTime.parse(date));
        } catch (e) {
          return date; // Return original string if parsing fails
        }
      }
      return 'Unknown date format';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract workout data with fallbacks for potential null values
    final dateId = workout['id'] ?? '';
    final exerciseName = workout['exerciseName'] ?? 'Unknown exercise';
    final muscleGroup = workout['muscleGroup'] ?? 'Unknown';
    final sets = workout['sets']?.toString() ?? 'N/A';
    final reps = workout['reps']?.toString() ?? 'N/A';
    final weight = workout['weight']?.toString() ?? 'N/A';
    final restTime = workout['restTime'] ?? 'N/A';
    final workoutDuration = workout['workoutDuration'] ?? 'N/A';
    
    // Display date from document ID or createdAt
    final displayDate = dateId.isNotEmpty
        ? _formatDate(dateId)
        : _formatDate(workout['createdAt']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(displayDate, exerciseName, muscleGroup),
            const SizedBox(height: 16),
            _buildTrainingParametersCard(sets, reps, weight, restTime, workoutDuration),
            const SizedBox(height: 16),
            _buildAdditionalInfoCard(workout),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String date, String exerciseName, String muscleGroup) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.blue[700],
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    exerciseName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue[700],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: Colors.blue[700],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Muscle Group: $muscleGroup',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingParametersCard(
      String sets, String reps, String weight, String restTime, String workoutDuration) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Training Parameters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.repeat, 'Sets', sets),
            _buildDetailRow(Icons.fitness_center, 'Reps', reps),
            _buildDetailRow(Icons.monitor_weight, 'Weight', '$weight kg'),
            _buildDetailRow(Icons.timer, 'Rest Time', restTime),
            _buildDetailRow(Icons.access_time, 'Workout Duration', workoutDuration),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard(Map<String, dynamic> workout) {
    // Filter out the fields we've already displayed
    final displayedKeys = [
      'id', 'exerciseName', 'muscleGroup', 'sets', 'reps', 
      'weight', 'restTime', 'workoutDuration', 'createdAt'
    ];
    
    // Check if there are any additional fields to display
    final additionalFields = workout.keys.where((key) => !displayedKeys.contains(key)).toList();
    
    if (additionalFields.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget if no additional fields
    }
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...additionalFields.map((key) {
              final value = workout[key]?.toString() ?? 'N/A';
              return _buildDetailRow(Icons.info_outline, key, value);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}