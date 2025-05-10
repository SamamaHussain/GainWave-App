import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the workout data passed as an argument from the previous screen
    final Map<String, dynamic> workout = 
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Format the timestamp
    String formattedDate = 'Unknown date';
    if (workout['createdAt'] != null && workout['createdAt'] is Timestamp) {
      final DateTime dateTime = (workout['createdAt'] as Timestamp).toDate();
      formattedDate = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(workout['exerciseName'] ?? 'Workout Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout detail card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    Text(
                      workout['exerciseName'] ?? 'Unknown Exercise',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Muscle group
                    Text(
                      workout['muscleGroup'] ?? 'Unknown Muscle Group',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Date and time
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date & Time',
                      formattedDate,
                    ),
                    const SizedBox(height: 16),

                    // Training parameters section
                    const Text(
                      'Training Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sets and Reps (side by side)
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            Icons.fitness_center,
                            'Sets',
                            '${workout['sets'] ?? '?'}',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            Icons.repeat,
                            'Reps',
                            '${workout['reps'] ?? '?'}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Weight
                    _buildDetailRow(
                      Icons.monitor_weight_outlined,
                      'Weight',
                      '${workout['weight'] ?? '?'} kg',
                    ),
                    const SizedBox(height: 16),

                    // Rest Time
                    _buildDetailRow(
                      Icons.timer_outlined,
                      'Rest Time',
                      workout['restTime'] ?? 'Not specified',
                    ),
                    const SizedBox(height: 16),

                    // Duration
                    _buildDetailRow(
                      Icons.hourglass_bottom,
                      'Workout Duration',
                      workout['workoutDuration'] ?? 'Not specified',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build detail items (for grid layout)
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Card(
      elevation: 1,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue[700], size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}