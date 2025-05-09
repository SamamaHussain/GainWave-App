import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';

// Shared workout model class
class WorkoutDay {
  final String name;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.name,
    required this.exercises,
  });
}