import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolumeTrackerScreen extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback? onClose;

  const VolumeTrackerScreen({
    super.key,
    this.scrollController,
    this.onClose,
  });

  @override
  State<VolumeTrackerScreen> createState() => _VolumeTrackerScreenState();
}

class _VolumeTrackerScreenState extends State<VolumeTrackerScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, int> _dailyMuscleVolume = {};
  Map<String, List<Map<String, dynamic>>> _exerciseData = {};
  final _exerciseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ... (Keep all your existing methods exactly the same until build method)
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

  // Save locally
  prefs.setString(dateKey, jsonEncode(_dailyMuscleVolume));
  prefs.setString("exercises_$dateKey", jsonEncode(_exerciseData));

  // Show snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Data saved for $dateKey")),
  );

  // Save to Firestore
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final totalVolume = _calculateTotalVolume().toInt();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('Weekly Muscle Volume')
          .doc(dateKey)
          .set({
        'Date': dateKey,
        'Volume': totalVolume,
      });

      debugPrint("✅ Volume saved to Firestore for $dateKey");
    } else {
      debugPrint("⚠️ No user is signed in.");
    }
  } catch (e) {
    debugPrint("❌ Failed to save volume to Firestore: $e");
  }
}
/// Remove Exercise from the List
  void _removeExercise(int index) {
  setState(() {
    _exerciseData["General"]?.removeAt(index);
    _updateVolume();
  });
}

  // Load Data for the Selected Date
 void _loadData() async {
  final prefs = await SharedPreferences.getInstance();
  String dateKey = "${_selectedDate.toLocal()}".split(' ')[0];
  String? savedVolume = prefs.getString(dateKey);
  String? savedExercises = prefs.getString("exercises_$dateKey");

  setState(() {
    if (savedVolume != null) {
      _dailyMuscleVolume = Map<String, int>.from(jsonDecode(savedVolume));
    } else {
      _dailyMuscleVolume.clear();
    }
    
    if (savedExercises != null) {
      _exerciseData = Map<String, List<Map<String, dynamic>>>.from(jsonDecode(savedExercises));
    } else {
      _exerciseData.clear();
    }
  });
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
  // Existing logic methods (_addExercise, _addSet, _updateVolume, _saveData, _loadData) 
  // remain the same as in original code

  void _navigateToHistory(BuildContext context) {
    showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 1.0, // Starts full screen
    minChildSize: 0.25,
    maxChildSize: 1.0,
    expand: false,
    builder: (context, scrollController) {
      return HistoryScreen(
        scrollController: scrollController,
        onClose: () => Navigator.pop(context),
      );
    },
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header with title and buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Volume Tracker",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _changeDate(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () => _navigateToHistory(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total volume container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "Total Workout Volume",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Text(
                  _calculateTotalVolume().toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          
          // Exercise input field
          TextField(
            controller: _exerciseController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_exerciseController.text.isNotEmpty) {
                    _addExercise("General", _exerciseController.text);
                    _exerciseController.clear();
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          
          // Exercises list
          ..._exerciseData["General"]?.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;
            return _buildExerciseCard(index, exercise);
          }).toList() ?? [],

          // Save button
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Workout"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _saveData,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(int index, Map<String, dynamic> exercise) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise['exercise'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeExercise(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addSet("General", index),
                    ),
                  ],
                ),
              ],
            ),
            ...exercise['sets'].asMap().entries.map((setEntry) {
              final setIndex = setEntry.key;
              final set = setEntry.value;
              return _buildSetRow(index, setIndex, set);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(int exerciseIndex, int setIndex, Map<String, dynamic> set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: set['weight'],
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _exerciseData["General"]![exerciseIndex]['sets'][setIndex]['weight'] = value;
                });
                _updateVolume();
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: set['reps'],
              decoration: InputDecoration(
                labelText: "Reps",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _exerciseData["General"]![exerciseIndex]['sets'][setIndex]['reps'] = value;
                });
                _updateVolume();
              },
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Vol: ${set['volume']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalVolume() {
    return _dailyMuscleVolume.values.fold(0, (sum, volume) => sum + volume).toDouble();
  }
}

class HistoryScreen extends StatelessWidget {
  final ScrollController? scrollController;
  final VoidCallback? onClose;

  const HistoryScreen({
    super.key,
    this.scrollController,
    this.onClose,
  });

  // Keep the _getHistoryFromFirestore() method exactly the same

  Future<List<Map<String, dynamic>>> _getHistoryFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("⚠️ No user signed in.");
      return [];
    }

    final uid = user.uid;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('Weekly Muscle Volume')
          .get();

      final history = snapshot.docs.map((doc) {
        final data = doc.data();
        final date = DateTime.parse(data['Date']);
        final volume = data['Volume'] ?? 0;

        return {
          'date': date,
          'volume': volume,
        };
      }).toList();

      // Sort by date descending
      history.sort((a, b) => b['date'].compareTo(a['date']));

      return history;
    } catch (e) {
      debugPrint("❌ Error loading history from Firestore: $e");
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Workout History",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getHistoryFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No history found."));
                }

                final entries = snapshot.data!;

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(
                          DateFormat.yMMMd().format(entry['date']),
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          "${entry['volume']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


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

