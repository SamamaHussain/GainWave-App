// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/Views/Muscle%20Volume/muscleVolume.dart';
// import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
// import 'package:gain_wave_app/Views/Performance/Exercise%20Data/exercisesList.dart';
// import 'package:gain_wave_app/Views/Performance/UI/storeStats/storestats.dart';
// import 'dart:async';


// class ExerciseLibraryPage extends StatefulWidget {
//   const ExerciseLibraryPage({Key? key}) : super(key: key);

//   @override
//   _ExerciseLibraryPageState createState() => _ExerciseLibraryPageState();
// }

// class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
//   String _selectedFilter = 'All';
//   String _searchQuery = '';
//   final workoutStats = WorkoutStats();


//   List<String> get muscleGroups => ['All', ...exercises.map((e) => e.targetMuscle).toSet().toList()];

//   List<Exercise> get filteredExercises {
//     return exercises.where((exercise) {
//       // Apply muscle group filter
//       final matchesFilter = _selectedFilter == 'All' || exercise.targetMuscle == _selectedFilter;
      
//       // Apply search filter
//       final matchesSearch = _searchQuery.isEmpty || 
//           exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           exercise.targetMuscle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           exercise.equipment.toLowerCase().contains(_searchQuery.toLowerCase());
      
//       return matchesFilter && matchesSearch;
//     }).toList();
//   }


//   @override
//   void initState() {
//     super.initState();
//     // Load workout stats from storage
//     workoutStats.loadStats();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exercise Library'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: ExerciseSearchDelegate(exercises: exercises),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.restore),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => StatsDialog(),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Total exercise time display
//           Container(
//             color: Colors.blueGrey[50],
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.timer, color: Colors.blueGrey),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Total Time Exercised:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 8),
//                 StreamBuilder<int>(
//                   stream: workoutStats.timeStream,
//                   initialData: workoutStats.totalTimeExercised,
//                   builder: (context, snapshot) {
//                     return Text(
//                       workoutStats.getFormattedTotalTime(),
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
          
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search exercises...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//             ),
//           ),
          
//           // Horizontal filter tabs
//           SizedBox(
//             height: 50,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               children: muscleGroups.map((group) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: FilterChip(
//                     label: Text(group),
//                     selected: _selectedFilter == group,
//                     onSelected: (selected) {
//                       setState(() {
//                         _selectedFilter = group;
//                       });
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
          
//           // Exercise list
//           Expanded(
//             child: filteredExercises.isEmpty
//                 ? const Center(child: Text('No exercises found'))
//                 : ListView.builder(
//                     itemCount: filteredExercises.length,
//                     physics: const BouncingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final exercise = filteredExercises[index];
//                       return ExerciseTile(exercise: exercise);
//                     },
//                   ),
//           ),
//         ],
//       ),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// floatingActionButton: Container(
//   decoration: BoxDecoration(
//     boxShadow: [
//       BoxShadow(
//         color: Colors.green.withOpacity(0.5),
//         spreadRadius: 2,
//         blurRadius: 5,
//         offset: const Offset(0, 3),
//       ),
//     ],
//   ),
//   child: ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.white,
//       elevation: 5,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//     ),
//     onPressed: () {
//        showModalBottomSheet(
//   context: context,
//   isScrollControlled: true,
//   backgroundColor: Colors.transparent,
//   builder: (context) => DraggableScrollableSheet(
//     initialChildSize: 0.7,
//     minChildSize: 0.25,
//     maxChildSize: 0.95,
//     expand: false,
//     builder: (context, scrollController) {
//       return VolumeTrackerScreen(
//         scrollController: scrollController,
//         onClose: () => Navigator.pop(context),
//       );
//     },
//   ),
// );
//     },
//     child:const  Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.balance_rounded),
//          SizedBox(width: 8),
//          Text('Track Muscle Volume'),
//       ],
//     ),
//   ),
// ),



//     );
//   }
// }

// class StatsDialog extends StatelessWidget {
//   final workoutStats = WorkoutStats();

//   StatsDialog({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Reset Stats'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: const Icon(Icons.timer),
//             title: const Text('Total Time Exercised'),
//             subtitle: StreamBuilder<int>(
//               stream: workoutStats.timeStream,
//               initialData: workoutStats.totalTimeExercised,
//               builder: (context, snapshot) {
//                 return Text(
//                   workoutStats.getFormattedTotalTime(),
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('CLOSE'),
//         ),
//         TextButton(
//           onPressed: () {
//             workoutStats.resetStats();
//             Navigator.of(context).pop();
//           },
//           child: const Text('RESET STATS'),
//         ),
//       ],
//     );
//   }
// }

// class ExerciseTile extends StatelessWidget {
//   final Exercise exercise;

//   const ExerciseTile({Key? key, required this.exercise}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => ExerciseDetailPage(exercise: exercise),
//             ),
//           );
//         },
//         child: Row(
//           children: [
//             // Exercise image
//             Container(
//               width: 100,
//               height: 100,
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 exercise.imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.fitness_center, size: 40),
//                   );
//                 },
//               ),
//             ),
//             // Exercise info
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       exercise.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Target: ${exercise.targetMuscle}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     Text(
//                       'Equipment: ${exercise.equipment}',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Chevron icon
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.chevron_right),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ExerciseSearchDelegate extends SearchDelegate<Exercise?> {
//   final List<Exercise> exercises;

//   ExerciseSearchDelegate({required this.exercises});

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return buildSearchResults();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return buildSearchResults();
//   }

//   Widget buildSearchResults() {
//     final results = exercises.where((exercise) {
//       return exercise.name.toLowerCase().contains(query.toLowerCase()) ||
//           exercise.targetMuscle.toLowerCase().contains(query.toLowerCase()) ||
//           exercise.equipment.toLowerCase().contains(query.toLowerCase());
//     }).toList();

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final exercise = results[index];
//         return ListTile(
//           leading: Container(
//             width: 50,
//             height: 50,
//             child: Image.asset(
//               exercise.imageUrl,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.fitness_center),
//                 );
//               },
//             ),
//           ),
//           title: Text(exercise.name),
//           subtitle: Text(exercise.targetMuscle),
//           onTap: () {
//             close(context, exercise);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => ExerciseDetailPage(exercise: exercise),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ExerciseDetailPage extends StatefulWidget {
//   final Exercise exercise;

//   const ExerciseDetailPage({Key? key, required this.exercise}) : super(key: key);

//   @override
//   _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
// }

// class _ExerciseDetailPageState extends State<ExerciseDetailPage> with TickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentSet = 1;
//   int _reps = 0;
//   int _currentTab = 0;
//   bool _isRunning = false;
//   int _secondsElapsed = 0;
//   int _restSecondsRemaining = 0;
//   bool _isResting = false;
//   final workoutStats = WorkoutStats();
//   int _sessionStartTime = 0;
  
//   // Stopwatch controllers
//   late Stopwatch _stopwatch;
//   late Stopwatch _restStopwatch;
//   late Timer _periodicTimer;
  
//   // Animation controllers
//   late AnimationController _exerciseAnimationController;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _currentTab = _tabController.index;
//       });
//     });
    
//     _reps = widget.exercise.defaultReps;
//     _stopwatch = Stopwatch();
//     _restStopwatch = Stopwatch();
    
//     _exerciseAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
    
//     // Set up timer for updating stopwatch display
//     _setupTimers();
//   }
  
//   void _setupTimers() {
//     // Timer that updates the UI every 100ms for stopwatch
//     _periodicTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_isRunning) {
//             _secondsElapsed = _stopwatch.elapsed.inSeconds;
//           }
//           if (_isResting) {
//             _restSecondsRemaining = widget.exercise.defaultRestTime - _restStopwatch.elapsed.inSeconds;
//             if (_restSecondsRemaining <= 0) {
//               _endRest();
//             }
//           }
//         });
//       }
//     });
//   }
  
//   void _toggleStopwatch() {
//     setState(() {
//       if (_isRunning) {
//         _stopwatch.stop();
//         // Record exercise time
//         if (_sessionStartTime > 0) {
//           final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
//           workoutStats.addExerciseTime((sessionTime / 1000).round());
//           _sessionStartTime = 0;
//         }
//       } else {
//         _stopwatch.start();
//         // Start timing this exercise session
//         _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
//       }
//       _isRunning = !_isRunning;
//     });
//   }
  
//   void _resetStopwatch() {
//     setState(() {
//       // If we're stopping an active session, record the time
//       if (_isRunning && _sessionStartTime > 0) {
//         final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
//         workoutStats.addExerciseTime((sessionTime / 1000).round());
//       }
      
//       _stopwatch.reset();
//       _secondsElapsed = 0;
//       _isRunning = false;
//       _sessionStartTime = 0;
//     });
//   }
  
//   void _incrementReps() {
//     setState(() {
//       _reps++;
//     });
//   }
  
//   void _decrementReps() {
//     if (_reps > 0) {
//       setState(() {
//         _reps--;
//       });
//     }
//   }
  
//   void _completeSet() {
//     // Add the exercise time to total stats
//     if (_isRunning && _sessionStartTime > 0) {
//       final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
//       workoutStats.addExerciseTime((sessionTime / 1000).round());
//       _sessionStartTime = 0; // Reset for next set
//     }
    
//     _resetStopwatch();
//     setState(() {
//       _currentSet++;
//       _isResting = true;
//       _restStopwatch.reset();
//       _restStopwatch.start();
//       _restSecondsRemaining = widget.exercise.defaultRestTime;
//     });
    
//     // Show rest timer dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => RestTimerDialog(
//         initialDuration: widget.exercise.defaultRestTime,
//         onComplete: _endRest,
//         onSkip: _endRest,
//       ),
//     );
//   }
  
//   void _endRest() {
//     if (_isResting) {
//       setState(() {
//         _isResting = false;
//         _restStopwatch.stop();
//         _restStopwatch.reset();
//       });
//       Navigator.of(context).pop(); // Close the rest dialog
//     }
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _exerciseAnimationController.dispose();
//     _periodicTimer.cancel();
    
//     // Add any remaining exercise time before disposing
//     if (_isRunning && _sessionStartTime > 0) {
//       final sessionTime = DateTime.now().millisecondsSinceEpoch - _sessionStartTime;
//       workoutStats.addExerciseTime((sessionTime / 1000).round());
//     }
    
//     super.dispose();
//   }

//   String _formatDuration(int seconds) {
//     final minutes = (seconds / 60).floor();
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.exercise.name),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Info'),
//             Tab(text: 'Perform'),
//             Tab(text: 'History'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Info Tab
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image
//                 Center(
//                   child: Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Image.asset(
//                       widget.exercise.imageUrl,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.fitness_center, size: 64),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Exercise details
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Details',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Divider(),
//                         _buildDetailRow('Target Muscle', widget.exercise.targetMuscle),
//                         _buildDetailRow('Equipment', widget.exercise.equipment),
//                         _buildDetailRow('Default Sets', widget.exercise.defaultSets.toString()),
//                         _buildDetailRow('Default Reps', widget.exercise.defaultReps.toString()),
//                         _buildDetailRow('Rest Time', '${widget.exercise.defaultRestTime} seconds'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Description
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Instructions',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Divider(),
//                         Text(widget.exercise.description),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Perform Tab
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Set indicator
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'SET $_currentSet OF ${widget.exercise.defaultSets}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
                
//                 // Rep counter
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'REPS',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove_circle_outline, size: 32),
//                               onPressed: _decrementReps,
//                             ),
//                             const SizedBox(width: 16),
//                             Text(
//                               '$_reps',
//                               style: const TextStyle(
//                                 fontSize: 48,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             IconButton(
//                               icon: const Icon(Icons.add_circle_outline, size: 32),
//                               onPressed: _incrementReps,
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'Target: ${widget.exercise.defaultReps}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
                
//                 // Stopwatch
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'TIMER',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           _formatDuration(_secondsElapsed),
//                           style: const TextStyle(
//                             fontSize: 48,
//                             fontWeight: FontWeight.w300,
//                             fontFamily: 'monospace',
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _toggleStopwatch,
//                               style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(16),
//                               ),
//                               child: Icon(
//                                 _isRunning ? Icons.pause : Icons.play_arrow,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             ElevatedButton(
//                               onPressed: _resetStopwatch,
//                               style: ElevatedButton.styleFrom(
//                                 shape: const CircleBorder(),
//                                 padding: const EdgeInsets.all(16),
//                               ),
//                               child: const Icon(
//                                 Icons.refresh,
//                                 size: 32,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 const Spacer(),
                
//                 // Complete set button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _completeSet,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     ),
//                     child: const Text(
//                       'COMPLETE SET',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 // Display total time exercised
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: StreamBuilder<int>(
//                     stream: workoutStats.timeStream,
//                     initialData: workoutStats.totalTimeExercised,
//                     builder: (context, snapshot) {
//                       return Text(
//                         'Total time exercised: ${workoutStats.getFormattedTotalTime()}',
//                         style: TextStyle(
//                           color: Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // History Tab - Now includes stats
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Card(
//                   margin: const EdgeInsets.all(16.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Exercise Statistics',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Divider(),
//                         ListTile(
//                           leading: const Icon(Icons.timer),
//                           title: const Text('Total Time Exercised'),
//                           trailing: StreamBuilder<int>(
//                             stream: workoutStats.timeStream,
//                             initialData: workoutStats.totalTimeExercised,
//                             builder: (context, snapshot) {
//                               return Text(
//                                 workoutStats.getFormattedTotalTime(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'This data can be synced with Firebase. Additional statistics will appear here as you complete workouts.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Exercise data will be stored to Firebase'),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.cloud_upload),
//                           label: const Text('SYNC WITH FIREBASE'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 32),
                
//                 Icon(
//                   Icons.history,
//                   size: 64,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Workout history will appear here',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RestTimerDialog extends StatefulWidget {
//   final int initialDuration;
//   final VoidCallback onComplete;
//   final VoidCallback onSkip;

//   const RestTimerDialog({
//     Key? key,
//     required this.initialDuration,
//     required this.onComplete,
//     required this.onSkip,
//   }) : super(key: key);

//   @override
//   _RestTimerDialogState createState() => _RestTimerDialogState();
// }

// class _RestTimerDialogState extends State<RestTimerDialog> with SingleTickerProviderStateMixin {
//   late int _secondsRemaining;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late Timer _timer;
  
//   @override
//   void initState() {
//     super.initState();
//     _secondsRemaining = widget.initialDuration;
    
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: widget.initialDuration),
//     );
    
//     _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    
//     _animationController.forward();
    
//     // Start timer
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           _secondsRemaining--;
//         });
        
//         if (_secondsRemaining <= 0) {
//           _timer.cancel();
//           widget.onComplete();
//         }
//       }
//     });
//   }
  
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }
  
//   String _formatDuration(int seconds) {
//     final minutes = (seconds / 60).floor();
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Rest Time'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text('Take a break before the next set'),
//           const SizedBox(height: 24),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   SizedBox(
//                     width: 150,
//                     height: 150,
//                     child: CircularProgressIndicator(
//                       value: _animation.value,
//                       strokeWidth: 8,
//                       backgroundColor: Colors.grey[300],
//                     ),
//                   ),
//                   Text(
//                     _formatDuration(_secondsRemaining),
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: widget.onSkip,
//           child: const Text('SKIP'),
//         ),
//       ],
//     );
//   }
  
// }
