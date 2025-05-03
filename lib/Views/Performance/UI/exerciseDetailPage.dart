import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/storestats.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseComponent.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailPage({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentSet = 1;
  int _reps = 0;
  // int _currentTab = 0;
  bool _isRunning = false;
  int _secondsElapsed = 0;
  int _restSecondsRemaining = 0;
  bool _isResting = false;
  final workoutStats = WorkoutStats();
  int _sessionStartTime = 0;
  
  // Stopwatch controllers
  late Stopwatch _stopwatch;
  late Stopwatch _restStopwatch;
  late Timer _periodicTimer;
  
  // Animation controllers
  late AnimationController _exerciseAnimationController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        // _currentTab = _tabController.index;
      });
    });
    
    _reps = widget.exercise.defaultReps;
    _stopwatch = Stopwatch();
    _restStopwatch = Stopwatch();
    
    _exerciseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // Set up timer for updating stopwatch display
    _setupTimers();
  }
  
  void _setupTimers() {
    // Timer that updates the UI every 100ms for stopwatch
    _periodicTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          if (_isRunning) {
            _secondsElapsed = _stopwatch.elapsed.inSeconds;
          }
          if (_isResting) {
            _restSecondsRemaining = widget.exercise.defaultRestTime - _restStopwatch.elapsed.inSeconds;
            if (_restSecondsRemaining <= 0) {
              _endRest();
            }
          }
        });
      }
    });
  }
  
  void _toggleStopwatch() {
    setState(() {
      if (_isRunning) {
        _stopwatch.stop();
        // Record exercise time
        if (_sessionStartTime > 0) {
          final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
          workoutStats.addExerciseTime((sessionTime / 1000).round());
          _sessionStartTime = 0;
        }
      } else {
        _stopwatch.start();
        // Start timing this exercise session
        _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
      }
      _isRunning = !_isRunning;
    });
  }
  
  void _resetStopwatch() {
    setState(() {
      // If we're stopping an active session, record the time
      if (_isRunning && _sessionStartTime > 0) {
        final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
        workoutStats.addExerciseTime((sessionTime / 1000).round());
      }
      
      _stopwatch.reset();
      _secondsElapsed = 0;
      _isRunning = false;
      _sessionStartTime = 0;
    });
  }
  
  void _incrementReps() {
    setState(() {
      _reps++;
    });
  }
  
  void _decrementReps() {
    if (_reps > 0) {
      setState(() {
        _reps--;
      });
    }
  }
  
  void _completeSet() {
    // Add the exercise time to total stats
    if (_isRunning && _sessionStartTime > 0) {
      final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
      workoutStats.addExerciseTime((sessionTime / 1000).round());
      _sessionStartTime = 0; // Reset for next set
    }
    
    _resetStopwatch();
    setState(() {
      _currentSet++;
      _isResting = true;
      _restStopwatch.reset();
      _restStopwatch.start();
      _restSecondsRemaining = widget.exercise.defaultRestTime;
    });
    
    // Show rest timer dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RestTimerDialog(
        initialDuration: widget.exercise.defaultRestTime,
        onComplete: _endRest,
        onSkip: _endRest,
      ),
    );
  }
  
  void _endRest() {
    if (_isResting) {
      setState(() {
        _isResting = false;
        _restStopwatch.stop();
        _restStopwatch.reset();
      });
      Navigator.of(context).pop(); // Close the rest dialog
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _exerciseAnimationController.dispose();
    _periodicTimer.cancel();
    
    // Add any remaining exercise time before disposing
    if (_isRunning && _sessionStartTime > 0) {
      final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
      workoutStats.addExerciseTime((sessionTime / 1000).round());
    }
    
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Perform'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Info Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset(
                      widget.exercise.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.fitness_center, size: 64),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Exercise details
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        _buildDetailRow('Target Muscle', widget.exercise.targetMuscle),
                        _buildDetailRow('Equipment', widget.exercise.equipment),
                        _buildDetailRow('Default Sets', widget.exercise.defaultSets.toString()),
                        _buildDetailRow('Default Reps', widget.exercise.defaultReps.toString()),
                        _buildDetailRow('Rest Time', '${widget.exercise.defaultRestTime} seconds'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Text(widget.exercise.description),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Perform Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Set indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SET $_currentSet OF ${widget.exercise.defaultSets}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Rep counter
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'REPS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 32),
                              onPressed: _decrementReps,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '$_reps',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 32),
                              onPressed: _incrementReps,
                            ),
                          ],
                        ),
                        Text(
                          'Target: ${widget.exercise.defaultReps}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Stopwatch
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'TIMER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_secondsElapsed),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _toggleStopwatch,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: Icon(
                                _isRunning ? Icons.pause : Icons.play_arrow,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _resetStopwatch,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(
                                Icons.refresh,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Complete set button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _completeSet,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'COMPLETE SET',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Display total time exercised
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: StreamBuilder<int>(
                    stream: workoutStats.timeStream,
                    initialData: workoutStats.totalTimeExercised,
                    builder: (context, snapshot) {
                      return Text(
                        'Total time exercised: ${workoutStats.getFormattedTotalTime()}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // History Tab - Now includes stats
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Exercise Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.timer),
                          title: const Text('Total Time Exercised'),
                          trailing: StreamBuilder<int>(
                            stream: workoutStats.timeStream,
                            initialData: workoutStats.totalTimeExercised,
                            builder: (context, snapshot) {
                              return Text(
                                workoutStats.getFormattedTotalTime(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This data can be synced with Firebase. Additional statistics will appear here as you complete workouts.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Exercise data will be stored to Firebase'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('SYNC WITH FIREBASE'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Workout history will appear here',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
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