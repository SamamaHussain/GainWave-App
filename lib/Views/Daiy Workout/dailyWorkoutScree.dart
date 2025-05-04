import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class DailyWorkoutScreen extends StatefulWidget {
  const DailyWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<DailyWorkoutScreen> createState() => _DailyWorkoutScreenState();
}

class _DailyWorkoutScreenState extends State<DailyWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _muscleGroupController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _restTimeController = TextEditingController();
  final TextEditingController _workoutDurationController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _muscleGroupController.dispose();
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
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final workoutData = {
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'exerciseName': _exerciseNameController.text.trim(),
        'muscleGroup': _muscleGroupController.text.trim(),
        'sets': int.parse(_setsController.text.trim()),
        'reps': int.parse(_repsController.text.trim()),
        'weight': double.parse(_weightController.text.trim()),
        'restTime': _restTimeController.text.trim(),
        'workoutDuration': _workoutDurationController.text.trim(),
      };

      try {
        // Use the provider to save workout
        await Provider.of<DailyWorkoutProvider>(context, listen: false)
            .saveWorkoutData(workoutData);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully!')),
        );
        
        // Clear the form
        _exerciseNameController.clear();
        _muscleGroupController.clear();
        _setsController.clear();
        _repsController.clear();
        _weightController.clear();
        _restTimeController.clear();
        _workoutDurationController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving workout: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Workout Log'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
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
                            const Text(
                              'Track Your Workout',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Date Picker
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Date:'),
                              subtitle: Text(
                                DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                            const Divider(),
                            // Exercise Name
                            TextFormField(
                              controller: _exerciseNameController,
                              decoration: const InputDecoration(
                                labelText: 'Exercise Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an exercise name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Muscle Group
                            TextFormField(
                              controller: _muscleGroupController,
                              decoration: const InputDecoration(
                                labelText: 'Muscle Group',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a muscle group';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Sets and Reps - Two fields in a row
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
                                        return 'Enter number';
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
                                        return 'Enter number';
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
                                labelText: 'Weight (kg/lbs)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the weight';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Rest Time
                            TextFormField(
                              controller: _restTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Rest Time (e.g., 60 seconds)',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter rest time';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Workout Duration
                            TextFormField(
                              controller: _workoutDurationController,
                              decoration: const InputDecoration(
                                labelText: 'Workout Duration (e.g., 45 minutes)',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter workout duration';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveWorkout,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text(
                        'SAVE WORKOUT',
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
            ),
    );
  }
}