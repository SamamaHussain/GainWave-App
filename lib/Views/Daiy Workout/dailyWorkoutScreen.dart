import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/dailyWorkoutService.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyWorkoutScreen extends StatefulWidget {
  const DailyWorkoutScreen({Key? key}) : super(key: key);

  @override
  _DailyWorkoutScreenState createState() => _DailyWorkoutScreenState();
}

class _DailyWorkoutScreenState extends State<DailyWorkoutScreen> {
  final DailyWorkoutService _dailyWorkoutService = DailyWorkoutService();
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _exerciseNameController = TextEditingController();
  String _selectedMuscleGroup = 'Chest';
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();
  final TextEditingController _workoutDurationController = TextEditingController();

  // List of muscle groups
  final List<String> _muscleGroups = [
    'Chest',
    'Back',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Legs',
    'Abs',
    'Full Body',
    'Cardio'
  ];

  bool _isLoading = false;
  List<Map<String, dynamic>> _todaysWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadTodaysWorkouts();
  }

  Future<void> _loadTodaysWorkouts() async {
    try {
      final workouts = await _dailyWorkoutService.getWorkoutsForDate(_selectedDate);
      setState(() {
        _todaysWorkouts = workouts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading workouts: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _restTimeController.dispose();
    _workoutDurationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadTodaysWorkouts();
    }
  }

  void _saveWorkoutData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create workout data map
        final workoutData = {
          'exerciseName': _exerciseNameController.text.trim(),
          'muscleGroup': _selectedMuscleGroup,
          'sets': int.parse(_setsController.text.trim()),
          'reps': int.parse(_repsController.text.trim()),
          'weight': double.parse(_weightController.text.trim()),
          'restTime': _restTimeController.text.trim(),
          'workoutDuration': _workoutDurationController.text.trim(),
          'createdAt': Timestamp.now(),
        };

        // Save workout data
        await _dailyWorkoutService.saveWorkoutData(_selectedDate, workoutData);

        // Clear form
        _exerciseNameController.clear();
        _setsController.clear();
        _repsController.clear();
        _weightController.clear();
        _restTimeController.clear();
        _workoutDurationController.clear();

        // Reload today's workouts
        await _loadTodaysWorkouts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving workout: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteWorkout(String dateId, String workoutId) async {
    // Show confirmation dialog
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout?'),
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
      await _dailyWorkoutService.deleteWorkoutData(dateId, workoutId);
      await _loadTodaysWorkouts();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete workout: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Daily Workout'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Date selector
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Today's workouts section
                  if (_todaysWorkouts.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Workouts on ${DateFormat('EEEE, MMM d').format(_selectedDate)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _todaysWorkouts.length,
                              itemBuilder: (context, index) {
                                final workout = _todaysWorkouts[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    workout['exerciseName'] ?? 'Unknown exercise',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${workout['muscleGroup']} • ${workout['sets']} sets • ${workout['reps']} reps',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteWorkout(
                                      workout['id'],
                                      workout['workoutId'],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/WorkoutDetailRoute',
                                      arguments: workout,
                                    ).then((_) => _loadTodaysWorkouts());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Add new workout form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Add New Workout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Add reset button
                                    TextButton.icon(
                                      icon: const Icon(Icons.refresh, size: 18),
                                      label: const Text('Reset'),
                                      onPressed: () {
                                        _exerciseNameController.clear();
                                        _setsController.clear();
                                        _repsController.clear();
                                        _weightController.clear();
                                        _restTimeController.clear();
                                        _workoutDurationController.clear();
                                        setState(() {
                                          _selectedMuscleGroup = 'Chest';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Exercise name
                                TextFormField(
                                  controller: _exerciseNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Exercise Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter exercise name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Muscle group dropdown
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Muscle Group',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _selectedMuscleGroup,
                                  items: _muscleGroups.map((String group) {
                                    return DropdownMenuItem<String>(
                                      value: group,
                                      child: Text(group),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedMuscleGroup = newValue;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Training parameters card
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Training Parameters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Sets & Reps (side by side)
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _setsController,
                                        decoration: const InputDecoration(
                                          labelText: 'Sets',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Enter a number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _repsController,
                                        decoration: const InputDecoration(
                                          labelText: 'Reps',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Enter a number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Weight
                                TextFormField(
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter weight';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Rest time & Workout duration (side by side)
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _restTimeController,
                                        decoration: const InputDecoration(
                                          labelText: 'Rest Time',
                                          border: OutlineInputBorder(),
                                          hintText: 'e.g., 30 sec, 1 min',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _workoutDurationController,
                                        decoration: const InputDecoration(
                                          labelText: 'Duration',
                                          border: OutlineInputBorder(),
                                          hintText: 'e.g., 20 min, 1 hour',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Save button
                        ElevatedButton(
                          onPressed: _saveWorkoutData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'ADD WORKOUT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}