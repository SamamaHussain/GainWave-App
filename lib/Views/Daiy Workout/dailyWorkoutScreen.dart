// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
// import 'package:intl/intl.dart';
// // Import the service we created instead of the provider

// class DailyWorkoutScreen extends StatefulWidget {
//   const DailyWorkoutScreen({Key? key}) : super(key: key);

//   @override
//   State<DailyWorkoutScreen> createState() => _DailyWorkoutScreenState();
// }

// class _DailyWorkoutScreenState extends State<DailyWorkoutScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Create an instance of our service
//   final DailyWorkoutService _workoutService = DailyWorkoutService();
  
//   // Form Controllers
//   final TextEditingController _exerciseNameController = TextEditingController();
//   final TextEditingController _muscleGroupController = TextEditingController();
//   final TextEditingController _setsController = TextEditingController();
//   final TextEditingController _repsController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _restTimeController = TextEditingController();
//   final TextEditingController _workoutDurationController = TextEditingController();
  
//   DateTime _selectedDate = DateTime.now();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _exerciseNameController.dispose();
//     _muscleGroupController.dispose();
//     _setsController.dispose();
//     _repsController.dispose();
//     _weightController.dispose();
//     _restTimeController.dispose();
//     _workoutDurationController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _saveWorkout() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       final workoutData = {
//         'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
//         'exerciseName': _exerciseNameController.text.trim(),
//         'muscleGroup': _muscleGroupController.text.trim(),
//         'sets': int.parse(_setsController.text.trim()),
//         'reps': int.parse(_repsController.text.trim()),
//         'weight': double.parse(_weightController.text.trim()),
//         'restTime': _restTimeController.text.trim(),
//         'workoutDuration': _workoutDurationController.text.trim(),
//       };

//       try {
//         // Use the service directly instead of the provider
//         await _workoutService.saveWorkoutData(workoutData);
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Workout saved successfully!')),
//         );
        
//         // Clear the form
//         _exerciseNameController.clear();
//         _muscleGroupController.clear();
//         _setsController.clear();
//         _repsController.clear();
//         _weightController.clear();
//         _restTimeController.clear();
//         _workoutDurationController.clear();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving workout: $e')),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daily Workout Log'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.manage_history_rounded),
//             onPressed: () => Navigator.pushNamed(context, '/WorkoutHistoryRoute'),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Card(
//                       elevation: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Track Your Workout',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             // Date Picker
//                             ListTile(
//                               contentPadding: EdgeInsets.zero,
//                               title: const Text('Date:'),
//                               subtitle: Text(
//                                 DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
//                                 style: const TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.calendar_today),
//                                 onPressed: () => _selectDate(context),
//                               ),
//                             ),
//                             const Divider(),
//                             // Exercise Name
//                             TextFormField(
//                               controller: _exerciseNameController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Exercise Name',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter an exercise name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             // Muscle Group
//                             TextFormField(
//                               controller: _muscleGroupController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Muscle Group',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a muscle group';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             // Sets and Reps - Two fields in a row
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: _setsController,
//                                     decoration: const InputDecoration(
//                                       labelText: 'Sets',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Required';
//                                       }
//                                       if (int.tryParse(value) == null) {
//                                         return 'Enter number';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: _repsController,
//                                     decoration: const InputDecoration(
//                                       labelText: 'Reps',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Required';
//                                       }
//                                       if (int.tryParse(value) == null) {
//                                         return 'Enter number';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             // Weight
//                             TextFormField(
//                               controller: _weightController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Weight (kg/lbs)',
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter the weight';
//                                 }
//                                 if (double.tryParse(value) == null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             // Rest Time
//                             TextFormField(
//                               controller: _restTimeController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Rest Time (e.g., 60 seconds)',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter rest time';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             // Workout Duration
//                             TextFormField(
//                               controller: _workoutDurationController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Workout Duration (e.g., 45 minutes)',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter workout duration';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _saveWorkout,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                       ),
//                       child: const Text(
//                         'SAVE WORKOUT',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Daily Workout'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_history_rounded),
            onPressed: () => Navigator.pushNamed(context, '/WorkoutHistoryRoute'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
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

                    // Exercise details card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Exercise Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                            
                            // Sets
                            TextFormField(
                              controller: _setsController,
                              decoration: const InputDecoration(
                                labelText: 'Sets',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number of sets';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Reps
                            TextFormField(
                              controller: _repsController,
                              decoration: const InputDecoration(
                                labelText: 'Reps',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number of reps';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
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

                            // Rest time
                            TextFormField(
                              controller: _restTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Rest Time (e.g., "30 sec", "1 min")',
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

                            // Workout duration
                            TextFormField(
                              controller: _workoutDurationController,
                              decoration: const InputDecoration(
                                labelText: 'Workout Duration (e.g., "20 min", "1 hour")',
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
                    const SizedBox(height: 24),

                    // Save button
                    ElevatedButton(
                      onPressed: _saveWorkoutData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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