// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gain_wave_app/utillities/Providers/dailyWorkoutProvider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:gain_wave_app/utillities/colors.dart';

// // Import the service instead of the provider

// class PerformanceAnalysisScreen extends StatefulWidget {
//   const PerformanceAnalysisScreen({Key? key}) : super(key: key);

//   @override
//   State<PerformanceAnalysisScreen> createState() => _PerformanceAnalysisScreenState();
// }

// class _PerformanceAnalysisScreenState extends State<PerformanceAnalysisScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _workoutHistory = [];
//   Map<String, List<Map<String, dynamic>>> _volumeData = {};
//   String _selectedExercise = 'All';
//   List<String> _exerciseList = ['All'];
  
//   // Create an instance of DailyWorkoutService
//   final DailyWorkoutService _workoutService = DailyWorkoutService();
  
//   // For summary stats
//   int _totalWorkouts = 0;
//   double _averageVolume = 0;
//   String _mostTrainedMuscle = '';
//   String _strongestExercise = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadAllData();
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadAllData() async {
//     setState(() {
//       _isLoading = true;
//     });
    
//     try {
//       // Load workout history using the service
//       await _loadWorkoutData();
      
//       // Load volume data
//       await _loadVolumeData();
      
//       // Calculate stats
//       _calculateStats();
      
//     } catch (e) {
//       debugPrint("Error loading data: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadWorkoutData() async {
//     try {
//       // Use the service to get all workouts
//       final workouts = await _workoutService.getAllWorkouts();
//       setState(() {
//         _workoutHistory = workouts;
        
//         // Extract unique exercise names for dropdown
//         Set<String> exercises = {'All'};
//         for (var workout in workouts) {
//           exercises.add(workout['exerciseName']);
//         }
//         _exerciseList = exercises.toList();
//       });
//     } catch (e) {
//       debugPrint("Error loading workout data: $e");
//     }
//   }

//   Future<void> _loadVolumeData() async {
//     final userId = _workoutService.currentUserId;
//     if (userId == null) return;
    
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(userId)
//           .collection('Weekly Muscle Volume')
//           .orderBy('Date')
//           .get();
      
//       Map<String, List<Map<String, dynamic>>> volumeByDate = {};
      
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final date = data['Date'] as String;
//         final volume = data['Volume'] as int;
        
//         if (!volumeByDate.containsKey('General')) {
//           volumeByDate['General'] = [];
//         }
        
//         volumeByDate['General']!.add({
//           'date': DateTime.parse(date),
//           'volume': volume,
//         });
//       }
      
//       setState(() {
//         _volumeData = volumeByDate;
//       });
//     } catch (e) {
//       debugPrint("Error loading volume data: $e");
//     }
//   }

//   void _calculateStats() {
//     if (_workoutHistory.isEmpty) return;
    
//     // Total workouts (using unique dates)
//     Set<String> uniqueDates = {};
//     for (var workout in _workoutHistory) {
//       uniqueDates.add(workout['date']);
//     }
//     _totalWorkouts = uniqueDates.length;
    
//     // Average volume from volume data
//     if (_volumeData.containsKey('General') && _volumeData['General']!.isNotEmpty) {
//       double totalVolume = 0;
//       for (var entry in _volumeData['General']!) {
//         totalVolume += entry['volume'];
//       }
//       _averageVolume = totalVolume / _volumeData['General']!.length;
//     }
    
//     // Most trained muscle group
//     Map<String, int> muscleFrequency = {};
//     for (var workout in _workoutHistory) {
//       String muscle = workout['muscleGroup'] ?? 'General';
//       muscleFrequency[muscle] = (muscleFrequency[muscle] ?? 0) + 1;
//     }
    
//     if (muscleFrequency.isNotEmpty) {
//       _mostTrainedMuscle = muscleFrequency.entries
//           .reduce((a, b) => a.value > b.value ? a : b)
//           .key;
//     }
    
//     // Strongest exercise (highest average weight)
//     Map<String, List<num>> exerciseWeights = {};
//     for (var workout in _workoutHistory) {
//       String exercise = workout['exerciseName'];
//       num weight = num.tryParse('${workout['weight']}') ?? 0;
      
//       if (!exerciseWeights.containsKey(exercise)) {
//         exerciseWeights[exercise] = [];
//       }
//       exerciseWeights[exercise]!.add(weight);
//     }
    
//     if (exerciseWeights.isNotEmpty) {
//       Map<String, double> exerciseAvgWeights = {};
//       exerciseWeights.forEach((exercise, weights) {
//         double sum = weights.fold(0, (prev, weight) => prev + weight);
//         exerciseAvgWeights[exercise] = sum / weights.length;
//       });
      
//       _strongestExercise = exerciseAvgWeights.entries
//           .reduce((a, b) => a.value > b.value ? a : b)
//           .key;
//     }
//   }

//   List<Map<String, dynamic>> get filteredWorkouts {
//     if (_selectedExercise == 'All') {
//       return _workoutHistory;
//     } else {
//       return _workoutHistory
//           .where((workout) => workout['exerciseName'] == _selectedExercise)
//           .toList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBG,
//       appBar: AppBar(
//         title: Text(
//           "Performance Analysis",
//           style: GoogleFonts.roboto(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             color: accentMain,
//           ),
//         ),
//         backgroundColor: primaryBG,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: accentMain,
//           labelColor: accentMain,
//           unselectedLabelColor: Colors.white70,
//           tabs: const [
//             Tab(text: "Progress"),
//             Tab(text: "Stats"),
//           ],
//         ),
//       ),
//       body: _isLoading 
//         ? const Center(child: CircularProgressIndicator(color: accentMain))
//         : TabBarView(
//             controller: _tabController,
//             children: [
//               _buildProgressTab(),
//               _buildStatsTab(),
//             ],
//           ),
//     );
//   }

//   Widget _buildProgressTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Exercise selector
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: secondaryBG,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedExercise,
//                 isExpanded: true,
//                 dropdownColor: secondaryBG,
//                 icon: const Icon(Icons.keyboard_arrow_down, color: accentMain),
//                 style: GoogleFonts.roboto(color: Colors.white),
//                 items: _exerciseList.map((String exercise) {
//                   return DropdownMenuItem<String>(
//                     value: exercise,
//                     child: Text(exercise),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     setState(() {
//                       _selectedExercise = newValue;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 24),

//           // Volume progress chart
//           if (_volumeData.isNotEmpty && _volumeData['General']!.isNotEmpty)
//             _buildVolumeChart(),
          
//           const SizedBox(height: 24),
          
//           // Recent workouts
//           Text(
//             "Recent Workouts",
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
          
//           const SizedBox(height: 12),
          
//           if (filteredWorkouts.isEmpty)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   "No workout data available",
//                   style: GoogleFonts.roboto(color: Colors.white70),
//                 ),
//               ),
//             )
//           else
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: filteredWorkouts.length > 5 ? 5 : filteredWorkouts.length,
//               itemBuilder: (context, index) {
//                 final workout = filteredWorkouts[index];
//                 return _buildWorkoutItem(workout);
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Summary stats
//           _buildSummaryStats(),
          
//           const SizedBox(height: 24),
          
//           // Workout frequency
//           Text(
//             "Workout Frequency",
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
          
//           const SizedBox(height: 12),
          
//           _buildWorkoutFrequencyChart(),
          
//           const SizedBox(height: 24),
          
//           // Overall progress
//           Text(
//             "Progress Report",
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
          
//           const SizedBox(height: 12),
          
//           _buildProgressReport(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryStats() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: secondaryBG,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Summary Stats",
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: accentMain,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatCard("Total Workouts", "$_totalWorkouts"),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildStatCard("Avg. Volume", "${_averageVolume.toStringAsFixed(0)}"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatCard("Most Trained", _mostTrainedMuscle),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildStatCard("Strongest Exercise", _strongestExercise),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.black26,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.roboto(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.white70,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: GoogleFonts.roboto(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVolumeChart() {
//     if (_volumeData.isEmpty || !_volumeData.containsKey('General')) {
//       return Center(child: Text('No volume data available', style: GoogleFonts.roboto(color: Colors.white70)));
//     }
    
//     List<Map<String, dynamic>> data = [..._volumeData['General']!];
//     data.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    
//     // Keep only the most recent 7 entries to avoid crowding
//     if (data.length > 7) {
//       data = data.sublist(data.length - 7);
//     }
    
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: secondaryBG,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Training Volume",
//             style: GoogleFonts.roboto(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           value.toInt().toString(),
//                           style: GoogleFonts.roboto(
//                             color: Colors.white60,
//                             fontSize: 10,
//                           ),
//                         );
//                       },
//                       reservedSize: 32,
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         if (value.toInt() >= 0 && value.toInt() < data.length) {
//                           final date = data[value.toInt()]['date'] as DateTime;
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               DateFormat('MM/dd').format(date),
//                               style: GoogleFonts.roboto(
//                                 color: Colors.white60,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           );
//                         }
//                         return const Text('');
//                       },
//                       reservedSize: 24,
//                     ),
//                   ),
//                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 minX: 0,
//                 maxX: data.length - 1.0,
//                 minY: 0,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: List.generate(data.length, (index) {
//                       return FlSpot(index.toDouble(), data[index]['volume'].toDouble());
//                     }),
//                     isCurved: true,
//                     color: accentMain,
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 4,
//                           color: accentMain,
//                           strokeWidth: 2,
//                           strokeColor: Colors.white,
//                         );
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: accentMain.withOpacity(0.2),
//                     ),
//                   ),
//                 ],
//                 lineTouchData: LineTouchData(
//                   touchTooltipData: LineTouchTooltipData(
//                     tooltipRoundedRadius: 8,
//                     tooltipPadding: const EdgeInsets.all(8),
//                     tooltipBorder: BorderSide.none,
//                     getTooltipItems: (List<LineBarSpot> touchedSpots) {
//                       return touchedSpots.map((spot) {
//                         final date = data[spot.x.toInt()]['date'] as DateTime;
//                         return LineTooltipItem(
//                           '${DateFormat('MMM d').format(date)}\n',
//                           GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold),
//                           children: [
//                             TextSpan(
//                               text: 'Volume: ${spot.y.toInt()} kg',
//                               style: GoogleFonts.roboto(
//                                 color: accentMain,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList();
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkoutFrequencyChart() {
//     // Group workouts by day of week
//     Map<int, int> dayFrequency = {};
//     for (var workout in _workoutHistory) {
//       final date = DateTime.parse(workout['date']);
//       final weekday = date.weekday; // 1 = Monday, 7 = Sunday
//       dayFrequency[weekday] = (dayFrequency[weekday] ?? 0) + 1;
//     }
    
//     List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: secondaryBG,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: BarChart(
//         BarChartData(
//           gridData: FlGridData(show: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= 0 && index < weekdays.length) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         weekdays[index],
//                         style: GoogleFonts.roboto(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                       ),
//                     );
//                   }
//                   return const Text('');
//                 },
//                 reservedSize: 24,
//               ),
//             ),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           ),
//           borderData: FlBorderData(show: false),
//           barGroups: List.generate(7, (index) {
//             final weekday = index + 1;
//             return BarChartGroupData(
//               x: index,
//               barRods: [
//                 BarChartRodData(
//                   toY: dayFrequency[weekday]?.toDouble() ?? 0,
//                   color: accentMain,
//                   width: 16,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(4),
//                     topRight: Radius.circular(4),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _buildProgressReport() {
//     // Extract exercises and their progress
//     Map<String, List<Map<String, dynamic>>> exerciseProgress = {};
    
//     // Group workouts by exercise
//     for (var workout in _workoutHistory) {
//       final exercise = workout['exerciseName'];
//       if (exercise != null) {
//         if (!exerciseProgress.containsKey(exercise)) {
//           exerciseProgress[exercise] = [];
//         }
//         exerciseProgress[exercise]!.add(workout);
//       }
//     }
    
//     // Sort entries by date for each exercise
//     exerciseProgress.forEach((exercise, entries) {
//       entries.sort((a, b) => a['date'].compareTo(b['date']));
//     });
    
//     // Calculate progress for each exercise (comparing first and last entry)
//     List<Widget> progressWidgets = [];
    
//     exerciseProgress.forEach((exercise, entries) {
//       if (entries.length >= 2) {
//         final firstEntry = entries.first;
//         final lastEntry = entries.last;
        
//         final firstWeight = num.tryParse('${firstEntry['weight']}') ?? 0;
//         final lastWeight = num.tryParse('${lastEntry['weight']}') ?? 0;
        
//         final change = lastWeight - firstWeight;
//         final percentChange = firstWeight > 0 ? (change / firstWeight * 100) : 0;
        
//         final isPositive = change >= 0;
        
//         progressWidgets.add(
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.black26,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isPositive ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       isPositive ? Icons.trending_up : Icons.trending_down,
//                       color: isPositive ? Colors.green : Colors.red,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           exercise,
//                           style: GoogleFonts.roboto(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           'From ${firstWeight}kg to ${lastWeight}kg',
//                           style: GoogleFonts.roboto(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     isPositive ? '+${change.toStringAsFixed(1)}kg' : '${change.toStringAsFixed(1)}kg',
//                     style: GoogleFonts.roboto(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isPositive ? Colors.green : Colors.red,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '(${percentChange.toStringAsFixed(1)}%)',
//                     style: GoogleFonts.roboto(
//                       fontSize: 12,
//                       color: isPositive ? Colors.green : Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     });
    
//     if (progressWidgets.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             "Not enough data to show progress",
//             style: GoogleFonts.roboto(color: Colors.white70),
//           ),
//         ),
//       );
//     }
    
//     return Column(children: progressWidgets);
//   }

//   Widget _buildWorkoutItem(Map<String, dynamic> workout) {
//     final date = workout['date'];
//     final exercise = workout['exerciseName'];
//     final weight = workout['weight'];
//     final sets = workout['sets'];
//     final reps = workout['reps'];
    
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       color: secondaryBG,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 41, 61, 23),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.fitness_center_rounded,
//                 size: 20,
//                 color: accentMain,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     exercise,
//                     style: GoogleFonts.roboto(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     DateTime.tryParse(date) != null 
//                         ? DateFormat.yMMMd().format(DateTime.parse(date))
//                         : date,
//                     style: GoogleFonts.roboto(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "${weight}kg",
//                   style: GoogleFonts.roboto(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: accentMain,
//                   ),
//                 ),
//                 Text(
//                   "${sets}x${reps}",
//                   style: GoogleFonts.roboto(
//                     fontSize: 14,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

class PerformanceAnalysisScreen extends StatefulWidget {
  const PerformanceAnalysisScreen({super.key});

  @override
  State<PerformanceAnalysisScreen> createState() => _PerformanceAnalysisScreenState();
}

class _PerformanceAnalysisScreenState extends State<PerformanceAnalysisScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _workoutHistory = [];
  List<Map<String, dynamic>> _recentWorkouts = [];
  Map<String, int> _exerciseFrequency = {};
  int _periodDays = 7;
  int _totalVolume = 0;
  int _avgVolume = 0;
  int _workoutCount = 0;
  String _mostWorkedMuscle = '';
  
  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get volume data from Firestore
      final volumeData = await _getWorkoutHistoryFromFirestore(_periodDays);
      
      // Get workout details from Daily_Workout_Data collection
      final workoutDetails = await _getRecentWorkoutDetails();
      
      // Calculate exercise frequency
      _calculateExerciseFrequency(workoutDetails);
      
      // Process the data for statistics
      _processWorkoutData(volumeData);
      
      setState(() {
        _workoutHistory = volumeData;
        _recentWorkouts = workoutDetails;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading workout data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _calculateExerciseFrequency(List<Map<String, dynamic>> workouts) {
    Map<String, int> frequency = {};
    
    for (var workout in workouts) {
      // Access exerciseName directly from the workout
      String exerciseName = workout['exerciseName'] ?? 'Unknown';
      frequency[exerciseName] = (frequency[exerciseName] ?? 0) + 1;
    }
    
    _exerciseFrequency = Map.fromEntries(
      frequency.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value))
    );
  }
  
  Future<List<Map<String, dynamic>>> _getRecentWorkoutDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return [];
      }
      
      final uid = user.uid;
      final DateTime cutoffDate = DateTime.now().subtract(Duration(days: _periodDays));
      
      // Query the Daily_Workout_Data collection
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('Daily_Workout_Data')
          .get();
      
      List<Map<String, dynamic>> workouts = [];
      
      // Group exercises by date
      Map<String, List<Map<String, dynamic>>> exercisesByDate = {};
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final dateStr = doc.id; // Using the document ID as the date
        
        // Convert timestamp to DateTime
        DateTime? exerciseDate;
        if (data['createdAt'] is Timestamp) {
          exerciseDate = (data['createdAt'] as Timestamp).toDate();
        }
        
        // Skip if date is before cutoff
        if (exerciseDate != null && exerciseDate.isBefore(cutoffDate)) {
          continue;
        }
        
        // Add document ID as date and include all fields
        final exerciseData = {
          'id': dateStr,
          'date': exerciseDate,
          'exerciseName': data['exerciseName'] ?? 'Unknown',
          'muscleGroup': data['muscleGroup'] ?? 'Unknown',
          'reps': data['reps'] ?? 0,
          'sets': data['sets'] ?? 0,
          'weight': data['weight'] ?? 0,
          'restTime': data['restTime'] ?? '0',
          'workoutDuration': data['workoutDuration'] ?? '0',
          'createdAt': data['createdAt']
        };
        
        // Use the date string as key for grouping
        String dateKey = dateStr;
        if (!exercisesByDate.containsKey(dateKey)) {
          exercisesByDate[dateKey] = [];
        }
        exercisesByDate[dateKey]!.add(exerciseData);
      }
      
      // Convert grouped exercises to workout format
      exercisesByDate.forEach((dateKey, exercises) {
        if (exercises.isNotEmpty) {
          // Use the first exercise's timestamp for the workout date
          final firstExercise = exercises.first;
          DateTime? workoutDate = firstExercise['date'];
          
          workouts.add({
            'id': dateKey,
            'date': workoutDate,
            'exercises': exercises,
            'createdAt': firstExercise['createdAt']
          });
        }
      });
      
      // Sort workouts by date (most recent first)
      workouts.sort((a, b) {
        final dateA = a['date'];
        final dateB = b['date'];
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });
      
      return workouts;
    } catch (e) {
      debugPrint("❌ Error loading workout details: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getWorkoutHistoryFromFirestore(int days) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("⚠️ No user signed in.");
      return [];
    }

    final uid = user.uid;
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(Duration(days: days));

    try {
      // Get volume data
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('Weekly Muscle Volume')
          .where('Date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(startDate))
          .where('Date', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
          .get();

      final history = snapshot.docs.map((doc) {
        final data = doc.data();
        final date = DateTime.parse(data['Date']);
        final volume = data['Volume'] ?? 0;

        return {
          'date': date,
          'volume': volume,
          'dateString': data['Date'],
        };
      }).toList();

      // Sort by date
      history.sort((a, b) => a['date'].compareTo(b['date']));

      return history;
    } catch (e) {
      debugPrint("❌ Error loading history from Firestore: $e");
      return [];
    }
  }

  void _processWorkoutData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      _totalVolume = 0;
      _avgVolume = 0;
      _workoutCount = 0;
      _mostWorkedMuscle = 'None';
      return;
    }

    // Calculate total and average volume
    _totalVolume = data.fold(0, (sum, item) => sum + (item['volume'] as int));
    _workoutCount = data.length;
    _avgVolume = _workoutCount > 0 ? (_totalVolume / _workoutCount).round() : 0;

    // Find most worked muscle group
    _getMostWorkedMuscle();
  }

  Future<void> _getMostWorkedMuscle() async {
    try {
      // Calculate most worked muscle from the recent workout data
      Map<String, int> muscleCount = {};
      
      for (var workout in _recentWorkouts) {
        List<dynamic> exercises = workout['exercises'] ?? [];
        
        for (var exercise in exercises) {
          String muscleGroup = exercise['muscleGroup'] ?? 'Unknown';
          muscleCount[muscleGroup] = (muscleCount[muscleGroup] ?? 0) + 1;
        }
      }
      
      if (muscleCount.isNotEmpty) {
        // Find the muscle with the highest count
        var mostWorked = muscleCount.entries
            .reduce((a, b) => a.value > b.value ? a : b);
        _mostWorkedMuscle = mostWorked.key;
      } else {
        _mostWorkedMuscle = 'General';
      }
    } catch (e) {
      _mostWorkedMuscle = 'General';
      debugPrint("❌ Error finding most worked muscle: $e");
    }
  }

  void _changePeriod(int days) {
    setState(() {
      _periodDays = days;
    });
    _loadWorkoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        title: Text(
          "Workout Analysis",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentMain))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Time period selector
        _buildPeriodSelector(),
        
        const SizedBox(height: 20),
        
        // Summary cards
        _buildSummaryCards(),
        
        const SizedBox(height: 24),
        
        // Volume chart
        _buildVolumeChart(),
        
        const SizedBox(height: 24),
        
        // Exercise frequency
        _buildExerciseFrequency(),
        
        const SizedBox(height: 24),
        
        // Workout history list
        _buildWorkoutHistory(),
      ],
    );
  }
  
  Widget _buildExerciseFrequency() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Most Frequent Exercises",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _exerciseFrequency.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      "No exercise data available",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: _exerciseFrequency.entries
                      .take(5) // Show only top 5 exercises
                      .map((entry) => _buildFrequencyItem(entry.key, entry.value))
                      .toList(),
                ),
        ],
      ),
    );
  }
  
  Widget _buildFrequencyItem(String exercise, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              exercise,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 41, 61, 23),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$count time${count != 1 ? 's' : ''}",
              style: GoogleFonts.roboto(
                color: accentMain,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _periodButton(7, 'Week'),
          _periodButton(30, 'Month'),
        ],
      ),
    );
  }

  Widget _periodButton(int days, String label) {
    final isSelected = _periodDays == days;
    
    return GestureDetector(
      onTap: () => _changePeriod(days),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentMain : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(
            color: isSelected ? primaryBG : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard("Total Volume", "$_totalVolume kg", Icons.fitness_center),
        _buildStatCard("Avg. Volume", "$_avgVolume kg", Icons.show_chart),
        _buildStatCard("Workouts", "$_workoutCount", Icons.calendar_today),
        _buildStatCard("Top Focus", _mostWorkedMuscle, Icons.stars),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: accentMain, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Volume Trend",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _workoutHistory.isEmpty
                ? _buildEmptyChart()
                : _buildLineChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Text(
        "No workout data available",
        style: GoogleFonts.roboto(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 1000, // Adjust based on your data
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white24,
              strokeWidth: 1,
              dashArray: [5, 10],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= _workoutHistory.length || value.toInt() < 0) {
                  return const SizedBox();
                }
                
                // Only show some dates to avoid crowding
                if (_workoutHistory.length > 7 && value.toInt() % (_workoutHistory.length ~/ 5) != 0) {
                  return const SizedBox();
                }
                
                final date = _workoutHistory[value.toInt()]['date'] as DateTime;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MM/dd').format(date),
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.roboto(
                    color: Colors.white60,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: _workoutHistory.length - 1.0,
        minY: 0,
        maxY: _findMaxVolume() * 1.2, // Add 20% headroom
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(_workoutHistory.length, (index) {
              return FlSpot(
                index.toDouble(),
                (_workoutHistory[index]['volume'] as int).toDouble(),
              );
            }),
            isCurved: true,
            color: accentMain,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: accentMain,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: accentMain.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  double _findMaxVolume() {
    if (_workoutHistory.isEmpty) return 1000;
    
    return _workoutHistory
        .map((workout) => (workout['volume'] as int).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  Widget _buildWorkoutHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Workouts",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _recentWorkouts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "No workout data available",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: _recentWorkouts
                      .take(1) // Show only the last 5 workouts
                      .map((workout) => _buildDetailedWorkoutItem(workout))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildDetailedWorkoutItem(Map<String, dynamic> workout) {
    DateTime? date = workout['date'];
    String dateDisplay = "Unknown date";
    
    if (date != null) {
      dateDisplay = DateFormat.yMMMd().format(date);
    } else if (workout['id'] != null) {
      // Try to use ID as fallback for date display
      dateDisplay = workout['id'].toString();
    }
    
    // Get exercises from workout data
    List<dynamic> exercises = workout['exercises'] ?? [];
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 41, 61, 23),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fitness_center_rounded,
            size: 16,
            color: accentMain,
          ),
        ),
        title: Text(
          dateDisplay,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "${exercises.length} exercise${exercises.length != 1 ? 's' : ''}",
          style: GoogleFonts.roboto(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.expand_more,
          color: accentMain,
        ),
        children: [
          // Display exercises
          if (exercises.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "No exercise data available",
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ...exercises.map((exercise) => _buildExerciseItem(exercise)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildExerciseItem(dynamic exercise) {
    String exerciseName = exercise['exerciseName'] ?? 'Unknown exercise';
    int sets = exercise['sets'] ?? 0;
    int reps = exercise['reps'] ?? 0;
    int weight = exercise['weight'] ?? 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exerciseName,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "$sets × $reps @ ${weight}kg",
                style: GoogleFonts.roboto(
                  color: accentMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            exercise['muscleGroup'] ?? '',
            style: GoogleFonts.roboto(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}