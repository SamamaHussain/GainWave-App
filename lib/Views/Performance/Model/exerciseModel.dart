class Exercise {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String targetMuscle;
  final String equipment;
  final int defaultReps;
  final int defaultSets;
  final int defaultRestTime; // in seconds

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.targetMuscle,
    required this.equipment,
    required this.defaultReps,
    required this.defaultSets,
    required this.defaultRestTime,
  });
}