import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gain_wave_app/utillities/colors.dart';

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
      SnackBar(
        content: Text("Data saved for $dateKey"),
        backgroundColor: accentMain,
      ),
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

  // Change Selected Date
  void _changeDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentMain,
              onPrimary: Colors.white,
              surface: secondaryBG,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: primaryBG,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _loadData();
    }
  }

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
        color: primaryBG,
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
                color: Colors.grey[700],
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
                Text(
                  "Volume Tracker",
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: accentMain,
                    letterSpacing: -0.5,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                      onPressed: () => _changeDate(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.white),
                      onPressed: () => _navigateToHistory(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Selected date display
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              DateFormat.yMMMMd().format(_selectedDate),
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),

          // Total volume container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryBG,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Total Workout Volume",
                  style: GoogleFonts.roboto(
                    fontSize: 18, 
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _calculateTotalVolume().toStringAsFixed(0),
                  style: GoogleFonts.roboto(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: accentMain,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          
          // Exercise input field
          TextField(
            controller: _exerciseController,
            style: GoogleFonts.roboto(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Exercise Name",
              labelStyle: GoogleFonts.roboto(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: accentMain),
              ),
              filled: true,
              fillColor: secondaryBG,
              suffixIcon: IconButton(
                icon: const Icon(Icons.add, color: accentMain),
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
            padding: const EdgeInsets.only(top: 10, bottom: 40),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(
                "Save Workout",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentMain,
                foregroundColor: secondaryBG,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 41, 61, 23),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        size: 20,
                        color: accentMain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      exercise['exercise'],
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeExercise(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: accentMain),
                      onPressed: () => _addSet("General", index),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 24),
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
          // Set number indicator
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${setIndex + 1}",
              style: GoogleFonts.roboto(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: set['weight'],
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                labelStyle: GoogleFonts.roboto(color: Colors.white60, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: accentMain),
                ),
                filled: true,
                fillColor: Colors.black26,
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
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Reps",
                labelStyle: GoogleFonts.roboto(color: Colors.white60, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: accentMain),
                ),
                filled: true,
                fillColor: Colors.black26,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 41, 61, 23),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Vol: ${set['volume']}",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, 
                color: accentMain,
              ),
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
        color: primaryBG,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
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
                Text(
                  "Weekly Volume History",
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: accentMain,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
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
                  return const Center(
                    child: CircularProgressIndicator(color: accentMain),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No history found.",
                      style: GoogleFonts.roboto(color: Colors.white70),
                    ),
                  );
                }

                final entries = snapshot.data!;

                return ListView.builder(
                      physics: const BouncingScrollPhysics(),

                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: secondaryBG,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 12,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 41, 61, 23),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center_rounded,
                            size: 20,
                            color: accentMain,
                          ),
                        ),
                        title: Text(
                          DateFormat.yMMMd().format(entry['date']),
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "${entry['volume']}",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: accentMain,
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
      backgroundColor: primaryBG,
      appBar: AppBar(
        title: Text(
          "Weekly Volume",
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: accentMain,
          ),
        ),
        backgroundColor: primaryBG,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _getWeeklyVolume(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentMain));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading data.",
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
            );
          }

          Map<String, int> weeklyVolume = snapshot.data ?? {};
          
          if (weeklyVolume.isEmpty) {
            return Center(
              child: Text(
                "No volume data found for this week.",
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
            );
          }
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: weeklyVolume.entries.map((entry) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: secondaryBG,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 12,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 41, 61, 23),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      size: 20,
                      color: accentMain,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    "${entry.value} kg",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: accentMain,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}