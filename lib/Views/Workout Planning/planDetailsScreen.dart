import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Workout%20Planning/plannerModel.dart';
import 'package:gain_wave_app/utillities/colors.dart';

// Workout Plan Details Screen
class WorkoutPlanDetailsScreen extends StatelessWidget {
  final String planName;
  final List<WorkoutDay> workoutPlan;

  const WorkoutPlanDetailsScreen({
    Key? key,
    required this.planName,
    required this.workoutPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        appBar: AppBar(
          title: const Text('Plan Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textMain,
              )),
          backgroundColor: secondaryBG,
          iconTheme: const IconThemeData(color: textMain),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: secondaryBG,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${workoutPlan.length} days per week',
                      style: const TextStyle(
                        fontSize: 16,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This plan is designed to hit all muscle groups throughout the week with optimal recovery time.',
                      style: TextStyle(fontSize: 16, color: textMain),
                    ),
                  ],
                ),
              ),
            ),
            ...workoutPlan.map((day) => _buildWorkoutDayCard(day)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDayCard(WorkoutDay day) {
    return Card(
      color: secondaryBG,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textMain,
              ),
            ),
            const SizedBox(height: 16),
            ...day.exercises.map((exercise) => _buildExerciseItem(exercise)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryBG,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fitness_center, color: accentMain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: textMain,
                  ),
                ),
                Text(
                  '${exercise.defaultSets} sets × ${exercise.defaultReps} reps',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
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

// WorkoutDay is now defined in workout_models.dart