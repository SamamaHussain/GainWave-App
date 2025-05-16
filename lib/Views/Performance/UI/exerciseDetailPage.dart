// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
// import 'package:gain_wave_app/Views/Performance/Services/exerciseSaveService.dart';
// import 'package:gain_wave_app/Views/Performance/UI/exerciseComponent.dart';
// import 'package:gain_wave_app/utillities/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

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
//   bool _isRunning = false;
//   int _secondsElapsed = 0;
//   int _restSecondsRemaining = 0;
//   bool _isResting = false;
  
//   // Firebase service
//   final FirebaseWorkoutService _firebaseService = FirebaseWorkoutService();
  
//   // Tracking workout data
//   List<int> _setDurations = [];
  
//   // Stopwatch controllers
//   late Stopwatch _stopwatch;
//   late Stopwatch _restStopwatch;
//   late Timer _periodicTimer;
  
//   // Animation controllers
//   late AnimationController _exerciseAnimationController;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
    
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
//       } else {
//         _stopwatch.start();
//       }
//       _isRunning = !_isRunning;
//     });
//   }
  
//   void _resetStopwatch() {
//     setState(() {
//       _stopwatch.reset();
//       _secondsElapsed = 0;
//       _isRunning = false;
//     });
//   }
  
//   void _incrementReps() {
//     setState(() {
//       _reps++;
//     });
//   }
  
//   void _decrementReps() {
//     if (_reps > 1) { // Modified to prevent reps less than 1
//       setState(() {
//         _reps--;
//       });
//     }
//   }
  
//   void _completeSet() {
//     // Record the duration of this set
//     _setDurations.add(_secondsElapsed);
    
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
    
//     // Check if all sets are completed
//     if (_currentSet > widget.exercise.defaultSets) {
//       // Show save dialog after closing the rest timer dialog
//       Future.delayed(Duration(milliseconds: 300), () {
//         _showSaveWorkoutDialog();
//       });
//     }
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
  
//   // Calculate total workout duration from all sets
//   String get _totalWorkoutDuration {
//     int totalSeconds = _setDurations.fold(0, (sum, duration) => sum + duration);
//     return _formatDuration(totalSeconds);
//   }
  
//   // Save workout data to Firebase
//   Future<void> _saveWorkoutData() async {
//     final bool success = await _firebaseService.saveWorkoutData(
//       exerciseName: widget.exercise.name,
//       muscleGroup: widget.exercise.targetMuscle,
//       reps: _reps,
//       sets: _currentSet - 1, // Current set is already incremented after completion
//       workoutDuration: _totalWorkoutDuration,
//     );
    
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Workout saved successfully!'),
//           backgroundColor: accentMain,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save workout data. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
  
//   // Show save workout dialog
//   void _showSaveWorkoutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: secondaryBG,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           'Save Workout',
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDialogRow('Exercise', widget.exercise.name),
//             _buildDialogRow('Target Muscle', widget.exercise.targetMuscle),
//             _buildDialogRow('Sets Completed', '${_currentSet - 1}'),
//             _buildDialogRow('Reps', '$_reps'),
//             _buildDialogRow('Total Duration', _totalWorkoutDuration),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text(
//               'CANCEL',
//               style: GoogleFonts.roboto(color: Colors.white70),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: accentMain,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             onPressed: () {
//               _saveWorkoutData();
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'SAVE',
//               style: GoogleFonts.roboto(
//                 color: primaryBG,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildDialogRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.roboto(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.roboto(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _exerciseAnimationController.dispose();
//     _periodicTimer.cancel();
//     super.dispose();
//   }

//   String _formatDuration(int seconds) {
//     final minutes = (seconds / 60).floor();
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }
  
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.roboto(
//               color: Colors.white70,
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.roboto(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final double padding = screenWidth < 360 ? 16.0 : 24.0;
    
//     return Scaffold(
//       backgroundColor: primaryBG,
//       appBar: AppBar(
//         backgroundColor: primaryBG,
//         elevation: 0,
//         title: Text(
//           widget.exercise.name,
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         actions: [
//           // Add Save button to the app bar
//           IconButton(
//             icon: Icon(Icons.save, color: accentMain),
//             onPressed: _showSaveWorkoutDialog,
//             tooltip: 'Save workout data',
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: accentMain,
//           labelColor: accentMain,
//           unselectedLabelColor: Colors.white70,
//           labelStyle: GoogleFonts.roboto(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//           tabs: const [
//             Tab(text: 'Info'),
//             Tab(text: 'Perform'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Info Tab
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.all(padding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Image with improved container
//                   Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: secondaryBG,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.asset(
//                         widget.exercise.imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: secondaryBG,
//                             child: const Icon(
//                               Icons.fitness_center,
//                               size: 64,
//                               color: accentMain,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   // Exercise details card
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: secondaryBG,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.info_outline_rounded,
//                                 color: accentMain,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 'Details',
//                                 style: GoogleFonts.roboto(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           _buildDetailRow('Target Muscle', widget.exercise.targetMuscle),
//                           _buildDetailRow('Equipment', widget.exercise.equipment),
//                           _buildDetailRow('Default Sets', widget.exercise.defaultSets.toString()),
//                           _buildDetailRow('Default Reps', widget.exercise.defaultReps.toString()),
//                           _buildDetailRow('Rest Time', '${widget.exercise.defaultRestTime} seconds'),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   // Instructions card
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: secondaryBG,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.description_rounded,
//                                 color: accentMain,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 'Instructions',
//                                 style: GoogleFonts.roboto(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(color: Colors.white24, height: 24),
//                           Text(
//                             widget.exercise.description,
//                             style: GoogleFonts.roboto(
//                               color: Colors.white,
//                               fontSize: 16,
//                               height: 1.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Perform Tab
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.all(padding),
//               child: Column(
//                 children: [
//                   // Set indicator
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     decoration: BoxDecoration(
//                       color: accentMain,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: accentMain.withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'SET',
//                           style: GoogleFonts.roboto(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: primaryBG.withOpacity(0.8),
//                           ),
//                         ),
//                         Text(
//                           '$_currentSet OF ${widget.exercise.defaultSets}',
//                           style: GoogleFonts.roboto(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: primaryBG,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   // Rep counter
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: secondaryBG,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.repeat_rounded,
//                                 color: accentMain,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 'REPS',
//                                 style: GoogleFonts.roboto(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: primaryBG,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: IconButton(
//                                   icon: const Icon(Icons.remove, size: 24),
//                                   onPressed: _decrementReps,
//                                   color: accentMain,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 100,
//                                 child: Center(
//                                   child: Text(
//                                     '$_reps',
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 48,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: primaryBG,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: IconButton(
//                                   icon: const Icon(Icons.add, size: 24),
//                                   onPressed: _incrementReps,
//                                   color: accentMain,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Target: ${widget.exercise.defaultReps}',
//                             style: GoogleFonts.roboto(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   // Stopwatch
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: secondaryBG,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.timer_rounded,
//                                 color: accentMain,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 'TIMER',
//                                 style: GoogleFonts.roboto(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             _formatDuration(_secondsElapsed),
//                             style: GoogleFonts.roboto(
//                               fontSize: 48,
//                               fontWeight: FontWeight.w300,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: _isRunning ? primaryBG : accentMain,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: IconButton(
//                                   onPressed: _toggleStopwatch,
//                                   icon: Icon(
//                                     _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                                     size: 25,
//                                     color: _isRunning ? accentMain : primaryBG,
//                                   ),
//                                   padding: const EdgeInsets.all(12),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: primaryBG,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: IconButton(
//                                   onPressed: _resetStopwatch,
//                                   icon: const Icon(
//                                     Icons.refresh_rounded,
//                                     size: 25,
//                                     color: accentMain,
//                                   ),
//                                   padding: const EdgeInsets.all(12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
                  
//                   // Complete set button
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: accentMain.withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       onPressed: _completeSet,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: accentMain,
//                         padding: const EdgeInsets.symmetric(vertical: 16.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         'COMPLETE SET',
//                         style: GoogleFonts.roboto(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: primaryBG,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exerciseSaveService.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseComponent.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _weight = 0; // Add weight tracking
  bool _isRunning = false;
  int _secondsElapsed = 0;
  int _restSecondsRemaining = 0;
  bool _isResting = false;
  
  // Firebase service
  final FirebaseWorkoutService _firebaseService = FirebaseWorkoutService();
  
  // Tracking workout data
  List<int> _setDurations = [];
  List<int> _restDurations = [];
  
  // Stopwatch controllers
  late Stopwatch _stopwatch;
  late Stopwatch _restStopwatch;
  late Timer _periodicTimer;
  
  // Animation controllers
  late AnimationController _exerciseAnimationController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _reps = widget.exercise.defaultReps;
    _weight = 10; // Default weight value
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
      } else {
        _stopwatch.start();
      }
      _isRunning = !_isRunning;
    });
  }
  
  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _secondsElapsed = 0;
      _isRunning = false;
    });
  }
  
  void _incrementReps() {
    setState(() {
      _reps++;
    });
  }
  
  void _decrementReps() {
    if (_reps > 1) { // Modified to prevent reps less than 1
      setState(() {
        _reps--;
      });
    }
  }
  
  void _completeSet() {
    // Record the duration of this set
    _setDurations.add(_secondsElapsed);
    
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
    
    // Check if all sets are completed
    if (_currentSet > widget.exercise.defaultSets) {
      // Show save dialog after closing the rest timer dialog
      Future.delayed(Duration(milliseconds: 300), () {
        _showSaveWorkoutDialog();
      });
    }
  }
  
  void _endRest() {
    if (_isResting) {
      // Record rest duration before ending
      _restDurations.add(widget.exercise.defaultRestTime - _restSecondsRemaining);
      
      setState(() {
        _isResting = false;
        _restStopwatch.stop();
        _restStopwatch.reset();
      });
      Navigator.of(context).pop(); // Close the rest dialog
    }
  }
  
  // Calculate total workout duration from all sets
  String get _totalWorkoutDuration {
    int totalSeconds = _setDurations.fold(0, (sum, duration) => sum + duration);
    return _formatDuration(totalSeconds);
  }
  
  // Calculate average rest time
  String get _averageRestTime {
    if (_restDurations.isEmpty) return "0";
    int totalRestSeconds = _restDurations.fold(0, (sum, duration) => sum + duration);
    return totalRestSeconds.toString();
  }
  
  // Save workout data to Firebase
  Future<void> _saveWorkoutData() async {
    final bool success = await _firebaseService.saveWorkoutData(
      exerciseName: widget.exercise.name,
      muscleGroup: widget.exercise.targetMuscle,
      reps: _reps,
      sets: _currentSet - 1, // Current set is already incremented after completion
      workoutDuration: _totalWorkoutDuration,
      restTime: _averageRestTime,
      weight: _weight,
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout saved successfully!'),
          backgroundColor: accentMain,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save workout data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Show save workout dialog
  void _showSaveWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBG,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Save Workout',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content:           Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Exercise', widget.exercise.name),
            _buildDialogRow('Target Muscle', widget.exercise.targetMuscle),
            _buildDialogRow('Sets Completed', '${_currentSet - 1}'),
            _buildDialogRow('Reps', '$_reps'),
            
            // Weight input field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight (kg)',
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: accentMain),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: _weight.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _weight = int.tryParse(value) ?? _weight;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            _buildDialogRow('Total Duration', _totalWorkoutDuration),
            _buildDialogRow('Rest Time', _averageRestTime + ' seconds'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'CANCEL',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentMain,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _saveWorkoutData();
              Navigator.of(context).pop();
            },
            child: Text(
              'SAVE',
              style: GoogleFonts.roboto(
                color: primaryBG,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _exerciseAnimationController.dispose();
    _periodicTimer.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth < 360 ? 16.0 : 24.0;
    
    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        backgroundColor: primaryBG,
        elevation: 0,
        title: Text(
          widget.exercise.name,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Add Save button to the app bar
          IconButton(
            icon: Icon(Icons.save, color: accentMain),
            onPressed: _showSaveWorkoutDialog,
            tooltip: 'Save workout data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: accentMain,
          labelColor: accentMain,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Perform'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Info Tab
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with improved container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.exercise.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: secondaryBG,
                            child: const Icon(
                              Icons.fitness_center,
                              size: 64,
                              color: accentMain,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Exercise details card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: accentMain,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Details',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          _buildDetailRow('Target Muscle', widget.exercise.targetMuscle),
                          _buildDetailRow('Equipment', widget.exercise.equipment),
                          _buildDetailRow('Default Sets', widget.exercise.defaultSets.toString()),
                          _buildDetailRow('Default Reps', widget.exercise.defaultReps.toString()),
                          _buildDetailRow('Rest Time', '${widget.exercise.defaultRestTime} seconds'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Instructions card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description_rounded,
                                color: accentMain,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Instructions',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Text(
                            widget.exercise.description,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Perform Tab
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  // Set indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: accentMain,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentMain.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'SET',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryBG.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          '$_currentSet OF ${widget.exercise.defaultSets}',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: primaryBG,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Rep counter
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.repeat_rounded,
                                color: accentMain,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'REPS',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryBG,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.remove, size: 24),
                                  onPressed: _decrementReps,
                                  color: accentMain,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Center(
                                  child: Text(
                                    '$_reps',
                                    style: GoogleFonts.roboto(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryBG,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, size: 24),
                                  onPressed: _incrementReps,
                                  color: accentMain,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Target: ${widget.exercise.defaultReps}',
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Weight selector
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                color: accentMain,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'WEIGHT (KG)',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryBG,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.remove, size: 24),
                                  onPressed: () {
                                    if (_weight > 0) {
                                      setState(() {
                                        _weight--;
                                      });
                                    }
                                  },
                                  color: accentMain,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Center(
                                  child: Text(
                                    '$_weight',
                                    style: GoogleFonts.roboto(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryBG,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, size: 24),
                                  onPressed: () {
                                    setState(() {
                                      _weight++;
                                    });
                                  },
                                  color: accentMain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stopwatch
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBG,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer_rounded,
                                color: accentMain,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'TIMER',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _formatDuration(_secondsElapsed),
                            style: GoogleFonts.roboto(
                              fontSize: 48,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: _isRunning ? primaryBG : accentMain,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                  onPressed: _toggleStopwatch,
                                  icon: Icon(
                                    _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    size: 25,
                                    color: _isRunning ? accentMain : primaryBG,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryBG,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                  onPressed: _resetStopwatch,
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 25,
                                    color: accentMain,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Complete set button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: accentMain.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _completeSet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentMain,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'COMPLETE SET',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryBG,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}