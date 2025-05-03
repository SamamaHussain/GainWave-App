import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Muscle%20Volume/muscleVolume.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exercisesList.dart';
import 'package:gain_wave_app/Views/Performance/Services/storestats.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseComponent.dart';

class ExerciseLibraryPage2 extends StatefulWidget {
  const ExerciseLibraryPage2({Key? key}) : super(key: key);

  @override
  _ExerciseLibraryPage2State createState() => _ExerciseLibraryPage2State();
}

class _ExerciseLibraryPage2State extends State<ExerciseLibraryPage2> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final workoutStats = WorkoutStats();

  List<String> get muscleGroups => ['All', ...exercises.map((e) => e.targetMuscle).toSet().toList()];

  List<Exercise> get filteredExercises {
    return exercises.where((exercise) {
      // Apply muscle group filter
      final matchesFilter = _selectedFilter == 'All' || exercise.targetMuscle == _selectedFilter;
      
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty || 
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.targetMuscle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.equipment.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Load workout stats from storage
    workoutStats.loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ExerciseSearchDelegate(exercises: exercises),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StatsDialog(workoutStats: workoutStats),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Total exercise time display
          Container(
            color: Colors.blueGrey[50],
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.blueGrey),
                const SizedBox(width: 8),
                const Text(
                  'Total Time Exercised:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                StreamBuilder<int>(
                  stream: workoutStats.timeStream,
                  initialData: workoutStats.totalTimeExercised,
                  builder: (context, snapshot) {
                    return Text(
                      workoutStats.getFormattedTotalTime(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Horizontal filter tabs
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: muscleGroups.map((group) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(group),
                    selected: _selectedFilter == group,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = group;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Exercise list
          Expanded(
            child: filteredExercises.isEmpty
                ? const Center(child: Text('No exercises found'))
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return ExerciseTile(exercise: exercise);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
            backgroundColor: Colors.white,
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.25,
                maxChildSize: 0.95,
                expand: false,
                builder: (context, scrollController) {
                  return VolumeTrackerScreen(
                    scrollController: scrollController,
                    onClose: () => Navigator.pop(context),
                  );
                },
              ),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.balance_rounded),
              SizedBox(width: 8),
              Text('Track Muscle Volume'),
            ],
          ),
        ),
      ),
    );
  }
}