import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseDetailPage.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExerciseDetailPage(exercise: exercise),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: primaryBG,
                    child: Image.asset(
                      exercise.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: primaryBG,
                          child: const Icon(
                            Icons.fitness_center,
                            size: 33,
                            color: accentMain,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Target: ${exercise.targetMuscle}',
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Equipment: ${exercise.equipment}',
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: primaryBG,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(3.0),
                  child: const Icon(
                    Icons.chevron_right,
                    color: accentMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseSearchDelegate extends SearchDelegate<Exercise?> {
  final List<Exercise> exercises;

  ExerciseSearchDelegate({required this.exercises});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBG,
        iconTheme: IconThemeData(color: accentMain),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.roboto(color: Colors.white.withOpacity(0.7)),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.roboto(color: Colors.white),
      ),
      scaffoldBackgroundColor: primaryBG,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: accentMain),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: accentMain),
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

    return Container(
      color: primaryBG,
      child: results.isEmpty
          ? Center(
              child: Text(
                'No exercises found',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final exercise = results[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: secondaryBG,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: primaryBG,
                        child: Image.asset(
                          exercise.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: primaryBG,
                              child: const Icon(
                                Icons.fitness_center,
                                color: accentMain,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      exercise.targetMuscle,
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    onTap: () {
                      close(context, exercise);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailPage(exercise: exercise),
                        ),
                      );
                    },
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: accentMain,
                    ),
                  ),
                );
              },
            ),
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
    return Dialog(
      backgroundColor: secondaryBG,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rest Time',
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Take a break before the next set',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
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
                        backgroundColor: primaryBG,
                        valueColor: const AlwaysStoppedAnimation<Color>(accentMain),
                      ),
                    ),
                    Text(
                      _formatDuration(_secondsRemaining),
                      style: GoogleFonts.roboto(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSkip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentMain,
                  foregroundColor: primaryBG,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'SKIP REST',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}