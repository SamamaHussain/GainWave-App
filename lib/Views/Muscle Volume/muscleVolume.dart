import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Performance/Exercise%20Data/exercisesList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';

class VolumeTrackerScreen extends StatefulWidget {
  const VolumeTrackerScreen({super.key});

  @override
  State<VolumeTrackerScreen> createState() => _VolumeTrackerScreenState();
}

class _VolumeTrackerScreenState extends State<VolumeTrackerScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, int> _dailyMuscleVolume = {};
  Map<String, List<Map<String, dynamic>>> _exerciseData = {};
  
  // For exercise selection
  String _selectedMuscleFilter = 'All';
  List<String> _muscleGroups = ['All'];
  List<Exercise> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _initMuscleGroups();
    _filteredExercises = exercises;
  }

  // Initialize unique muscle groups from exercise data
  void _initMuscleGroups() {
    Set<String> uniqueMuscles = {'All'};
    for (var exercise in exercises) {
      uniqueMuscles.add(exercise.targetMuscle);
    }
    setState(() {
      _muscleGroups = uniqueMuscles.toList();
    });
  }

  // Filter exercises by muscle group
  void _filterExercises(String muscleGroup) {
    setState(() {
      _selectedMuscleFilter = muscleGroup;
      if (muscleGroup == 'All') {
        _filteredExercises = exercises;
      } else {
        _filteredExercises = exercises.where((e) => e.targetMuscle == muscleGroup).toList();
      }
    });
  }

  // Show exercise selection dialog
  void _showExerciseSelector() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Select Exercise'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Muscle group filter dropdown
                  DropdownButton<String>(
                    value: _selectedMuscleFilter,
                    isExpanded: true,
                    hint: const Text('Filter by muscle'),
                    onChanged: (value) {
                      setStateDialog(() {
                        _filterExercises(value!);
                      });
                    },
                    items: _muscleGroups.map((muscle) {
                      return DropdownMenuItem(
                        value: muscle,
                        child: Text(muscle),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Exercise list
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = _filteredExercises[index];
                        return ListTile(
                          title: Text(exercise.name),
                          subtitle: Text(exercise.targetMuscle),
                          onTap: () {
                            _addPredefinedExercise(exercise);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Add a predefined exercise to tracking
  void _addPredefinedExercise(Exercise exercise) {
    setState(() {
      // Add muscle group if it doesn't exist
      _exerciseData.putIfAbsent(exercise.targetMuscle, () => []);
      
      // Create sets based on default sets for the exercise
      List<Map<String, dynamic>> sets = [];
      for (int i = 0; i < exercise.defaultSets; i++) {
        sets.add({
          'weight': '',
          'reps': exercise.defaultReps.toString(),
          'volume': 0
        });
      }
      
      // Add exercise with default sets
      _exerciseData[exercise.targetMuscle]!.add({
        'exercise': exercise.name,
        'sets': sets,
        'equipment': exercise.equipment,
        'restTime': exercise.defaultRestTime,
      });
    });
  }

  // Add Exercise for a Muscle Group
  void _addExercise(String muscleGroup, String exerciseName) {
    setState(() {
      _exerciseData.putIfAbsent(muscleGroup, () => []);
      _exerciseData[muscleGroup]!.add({
        'exercise': exerciseName,
        'sets': [
          {'weight': '', 'reps': '', 'volume': 0}
        ]
      });
    });
  }

  // Add Set to a Specific Exercise
  void _addSet(String muscleGroup, int exerciseIndex) {
    setState(() {
      _exerciseData[muscleGroup]![exerciseIndex]['sets'].add({
        'weight': '',
        'reps': '',
        'volume': 0,
      });
    });
  }

  // Calculate Total Daily Volume
  void _updateVolume() {
    Map<String, int> dailyVolume = {};
    _exerciseData.forEach((muscleGroup, exercises) {
      int totalVolume = 0;

      for (var exercise in exercises) {
        for (var set in exercise['sets']) {
          if (set['weight'].isNotEmpty && set['reps'].isNotEmpty) {
            int weight = int.parse(set['weight']);
            int reps = int.parse(set['reps']);
            set['volume'] = (weight * reps).toInt();
            totalVolume += set['volume'] as int;
          }
        }
      }

      dailyVolume[muscleGroup] = totalVolume;
    });

    setState(() {
      _dailyMuscleVolume = dailyVolume;
    });
  }

  // Save Data for the Selected Date
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    String dateKey = "${_selectedDate.toLocal()}".split(' ')[0];
    prefs.setString(dateKey, jsonEncode(_dailyMuscleVolume));
    prefs.setString("exercises_$dateKey", jsonEncode(_exerciseData));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data saved for $dateKey")),
    );
  }

  // Load Data for the Selected Date
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String dateKey = "${_selectedDate.toLocal()}".split(' ')[0];
    String? savedVolume = prefs.getString(dateKey);
    String? savedExercises = prefs.getString("exercises_$dateKey");

    if (savedVolume != null) {
      setState(() {
        _dailyMuscleVolume = Map<String, int>.from(jsonDecode(savedVolume));
      });
    }
    if (savedExercises != null) {
      setState(() {
        _exerciseData =
            Map<String, List<Map<String, dynamic>>>.from(jsonDecode(savedExercises));
      });
    }
  }

  // Navigate to Weekly Volume Page
  void _navigateToWeeklyVolume(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyVolumeScreen(
          currentDate: _selectedDate,
        ),
      ),
    );
  }

  // Change Selected Date
  void _changeDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volume Tracker - ${_selectedDate.toLocal()}".split(' ')[0]),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _changeDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveData,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _navigateToWeeklyVolume(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Exercise selection button
            ElevatedButton.icon(
              icon: const Icon(Icons.fitness_center),
              label: const Text("Select Exercise"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _showExerciseSelector,
            ),
            const SizedBox(height: 10),
            // Custom muscle group input (for exercises not in the database)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Add Custom Muscle Group",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (muscle) {
                      if (muscle.isNotEmpty) {
                        TextEditingController exerciseController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Enter Exercise Name"),
                            content: TextField(
                              controller: exerciseController,
                              decoration: const InputDecoration(hintText: "Exercise Name"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  _addExercise(muscle, exerciseController.text);
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _exerciseData.entries.map((entry) {
                  String muscleGroup = entry.key;
                  List<Map<String, dynamic>> exercises = entry.value;
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$muscleGroup Volume: ${_dailyMuscleVolume[muscleGroup] ?? 0}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          ...exercises.asMap().entries.map((exerciseEntry) {
                            int exerciseIndex = exerciseEntry.key;
                            Map<String, dynamic> exercise = exerciseEntry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        exercise['exercise'],
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Equipment info if available
                                    if (exercise['equipment'] != null)
                                      Tooltip(
                                        message: exercise['equipment'],
                                        child: const Icon(Icons.info_outline, size: 16),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                ...exercise['sets'].asMap().entries.map((setEntry) {
                                  int setIndex = setEntry.key;
                                  Map<String, dynamic> set = setEntry.value;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Set ${setIndex + 1}"),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            initialValue: set['weight'],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Weight',
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _exerciseData[muscleGroup]![exerciseIndex]['sets']
                                                    [setIndex]['weight'] = value;
                                              });
                                              _updateVolume();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            initialValue: set['reps'],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Reps',
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _exerciseData[muscleGroup]![exerciseIndex]['sets']
                                                    [setIndex]['reps'] = value;
                                              });
                                              _updateVolume();
                                            },
                                          ),
                                        ),
                                        Text("Vol: ${set['volume']}"),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text("Add Set"),
                                      onPressed: () => _addSet(muscleGroup, exerciseIndex),
                                    ),
                                    // Show rest time if available
                                    if (exercise['restTime'] != null)
                                      Text("Rest: ${exercise['restTime']}s", 
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Weekly Volume Screen
class WeeklyVolumeScreen extends StatelessWidget {
  final DateTime currentDate;

  const WeeklyVolumeScreen({super.key, required this.currentDate});

  Future<Map<String, int>> _getWeeklyVolume() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> weeklyVolume = {};
    for (int i = 0; i < 7; i++) {
      String dateKey =
          "${currentDate.subtract(Duration(days: i)).toLocal()}".split(' ')[0];
      String? savedVolume = prefs.getString(dateKey);
      if (savedVolume != null) {
        Map<String, int> dailyVolume = Map<String, int>.from(jsonDecode(savedVolume));
        dailyVolume.forEach((muscle, volume) {
          weeklyVolume[muscle] = (weeklyVolume[muscle] ?? 0) + volume;
        });
      }
    }
    return weeklyVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Volume")),
      body: FutureBuilder<Map<String, int>>(
        future: _getWeeklyVolume(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data."));
          }

          Map<String, int> weeklyVolume = snapshot.data ?? {};
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: weeklyVolume.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: Text("${entry.value} kg"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}