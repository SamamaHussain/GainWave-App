import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Muscle%20Volume/muscleVolume.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exercisesList.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseComponent.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseLibraryPage extends StatefulWidget {
  const ExerciseLibraryPage({Key? key}) : super(key: key);

  @override
  _ExerciseLibraryPageState createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBG,
        title: Text(
          'Exercise Library',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: secondaryBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: accentMain,
                size: 22,
              ),
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ExerciseSearchDelegate(exercises: exercises),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar with better styling
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: GoogleFonts.roboto(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                hintStyle: GoogleFonts.roboto(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: accentMain),
                fillColor: secondaryBG,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Horizontal filter tabs - redesigned
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const BouncingScrollPhysics(),
              children: muscleGroups.map((group) {
                final isSelected = _selectedFilter == group;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFilter = group;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? accentMain : secondaryBG,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: accentMain.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        group,
                        style: GoogleFonts.roboto(
                          color: isSelected ? primaryBG : Colors.white,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Exercise list with better styling and empty state
          Expanded(
            child: filteredExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center_rounded,
                          size: 50,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No exercises found',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 100),
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
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: accentMain.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 280,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: primaryBG,
            backgroundColor: accentMain,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  return Container(
                    decoration: const BoxDecoration(
                      color: primaryBG,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: VolumeTrackerScreen(
                      scrollController: scrollController,
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.balance_rounded,
                color: primaryBG,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Track Muscle Volume',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryBG,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}