import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/storestats.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseDetailPage.dart';


class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseDetailPage(exercise: exercise),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                exercise.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.fitness_center, size: 40),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target: ${exercise.targetMuscle}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      'Equipment: ${exercise.equipment}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsDialog extends StatelessWidget {
  final WorkoutStats workoutStats;

  const StatsDialog({Key? key, required this.workoutStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Stats'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Total Time Exercised'),
            subtitle: StreamBuilder<int>(
              stream: workoutStats.timeStream,
              initialData: workoutStats.totalTimeExercised,
              builder: (context, snapshot) {
                return Text(
                  workoutStats.getFormattedTotalTime(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CLOSE'),
        ),
        TextButton(
          onPressed: () {
            workoutStats.resetStats();
            Navigator.of(context).pop();
          },
          child: const Text('RESET STATS'),
        ),
      ],
    );
  }
}

class ExerciseSearchDelegate extends SearchDelegate<Exercise?> {
  final List<Exercise> exercises;

  ExerciseSearchDelegate({required this.exercises});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    final results = exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
          exercise.targetMuscle.toLowerCase().contains(query.toLowerCase()) ||
          exercise.equipment.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final exercise = results[index];
        return ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              exercise.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.fitness_center),
                );
              },
            ),
          ),
          title: Text(exercise.name),
          subtitle: Text(exercise.targetMuscle),
          onTap: () {
            close(context, exercise);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExerciseDetailPage(exercise: exercise),
              ),
            );
          },
        );
      },
    );
  }
}

class RestTimerDialog extends StatefulWidget {
  final int initialDuration;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const RestTimerDialog({
    Key? key,
    required this.initialDuration,
    required this.onComplete,
    required this.onSkip,
  }) : super(key: key);

  @override
  _RestTimerDialogState createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<RestTimerDialog> with SingleTickerProviderStateMixin {
  late int _secondsRemaining;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialDuration;
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.initialDuration),
    );
    
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    
    _animationController.forward();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsRemaining--;
        });
        
        if (_secondsRemaining <= 0) {
          _timer.cancel();
          widget.onComplete();
        }
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }
  
  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rest Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Take a break before the next set'),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: _animation.value,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  Text(
                    _formatDuration(_secondsRemaining),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onSkip,
          child: const Text('SKIP'),
        ),
      ],
    );
  }
}