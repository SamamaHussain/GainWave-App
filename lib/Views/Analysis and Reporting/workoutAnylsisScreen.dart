import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gain_wave_app/Views/Analysis%20and%20Reporting/AnalysisDataService.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WorkoutAnalysisScreen extends StatefulWidget {
  const WorkoutAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutAnalysisScreen> createState() => _WorkoutAnalysisScreenState();
}

class _WorkoutAnalysisScreenState extends State<WorkoutAnalysisScreen> {
  final AnalysisDataService _dataService = AnalysisDataService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _workoutData = [];
  List<Map<String, dynamic>> _volumeData = [];
  Map<String, int> _muscleGroupSummary = {};
  
  int _totalWorkouts = 0;
  int _totalMinutes = 0;
  int _totalVolume = 0;
  double _avgVolume = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all data in parallel
      final workoutsFuture = _dataService.getDailyWorkoutData();
      final volumeFuture = _dataService.getMuscleVolumeData();
      final muscleGroupsFuture = _dataService.getMuscleGroupSummary();

      // Wait for all data to load
      final results = await Future.wait([
        workoutsFuture,
        volumeFuture,
        muscleGroupsFuture,
      ]);

      _workoutData = results[0] as List<Map<String, dynamic>>;
      _volumeData = results[1] as List<Map<String, dynamic>>;
      _muscleGroupSummary = results[2] as Map<String, int>;

      // Calculate summary metrics
      _calculateSummaryMetrics();
    } catch (e) {
      debugPrint('Error loading data: $e');
      // Show error if needed
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateSummaryMetrics() {
    _totalWorkouts = 0;
    _totalMinutes = 0;
    _totalVolume = 0;

    // Count total workouts and minutes
    for (var dayData in _workoutData) {
      final workouts = dayData['workouts'] as List;
      _totalWorkouts += workouts.length;
      _totalMinutes += dayData['totalWorkoutDuration'] as int;
    }

    // Calculate total and average volume if data exists
    if (_volumeData.isNotEmpty) {
      double sum = 0;
      for (var data in _volumeData) {
        final volume = (data['volume'] as num).toDouble();
        sum += volume;
        _totalVolume += volume.toInt();
      }
      _avgVolume = sum / _volumeData.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        backgroundColor: primaryBG,
        elevation: 0,
        title: Text(
          'Workout Summary',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentMain))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: accentMain,
              backgroundColor: secondaryBG,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 24),
                    _buildMuscleVolumeChart(),
                    const SizedBox(height: 24),
                    _buildMuscleGroupDistribution(),
                    const SizedBox(height: 24),
                    _buildRecentWorkouts(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last 7 Days',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Workouts',
                _totalWorkouts.toString(),
                Icons.fitness_center_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Volume',
                _totalVolume.toString(),
                Icons.analytics_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Workout Time',
                '${_totalMinutes} min',
                Icons.timer_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Avg Volume',
                _avgVolume.toStringAsFixed(1),
                Icons.show_chart_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 61, 23),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentMain, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleVolumeChart() {
    // Handle empty data case
    if (_volumeData.isEmpty) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: secondaryBG,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No muscle volume data available',
              style: GoogleFonts.roboto(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscle Volume Trend',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: secondaryBG,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < _volumeData.length) {
                            final date = DateFormat('yyyy-MM-dd').parse(_volumeData[value.toInt()]['date']);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('MM/dd').format(date),
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
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
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  minX: 0,
                  maxX: _volumeData.length - 1.0,
                  minY: _getMinY(),
                  maxY: _getMaxY(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(_volumeData.length, (index) {
                        return FlSpot(
                          index.toDouble(),
                          (_volumeData[index]['volume'] as num).toDouble(),
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
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: accentMain.withOpacity(0.2),
                        gradient: LinearGradient(
                          colors: [
                            accentMain.withOpacity(0.4),
                            accentMain.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getMinY() {
    if (_volumeData.isEmpty) return 0;
    double min = (_volumeData[0]['volume'] as num).toDouble();
    for (var data in _volumeData) {
      final volume = (data['volume'] as num).toDouble();
      if (volume < min) min = volume;
    }
    return (min * 0.8).floorToDouble(); // Add 20% margin
  }

  double _getMaxY() {
    if (_volumeData.isEmpty) return 100;
    double max = (_volumeData[0]['volume'] as num).toDouble();
    for (var data in _volumeData) {
      final volume = (data['volume'] as num).toDouble();
      if (volume > max) max = volume;
    }
    return (max * 1.2).ceilToDouble(); // Add 20% margin
  }

  Widget _buildMuscleGroupDistribution() {
    if (_muscleGroupSummary.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscle Group Focus',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: secondaryBG,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: _muscleGroupSummary.entries.map((entry) {
                final total = _muscleGroupSummary.values.fold(0, (sum, count) => sum + count);
                final percentage = total > 0 ? (entry.value / total) * 100 : 0;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.key,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 10,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              color: accentMain,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${percentage.toStringAsFixed(1)}% (${entry.value} workouts)',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts() {
    if (_workoutData.isEmpty) {
      return Center(
        child: Text(
          'No recent workouts',
          style: GoogleFonts.roboto(color: Colors.white70),
        ),
      );
    }

    // Create a flat list of all workouts from all days
    final allWorkouts = [];
    for (var dayData in _workoutData) {
      final date = DateFormat('yyyy-MM-dd').parse(dayData['date']);
      final workouts = dayData['workouts'] as List;
      
      for (var workout in workouts) {
        allWorkouts.add({
          'date': date,
          'exerciseName': workout['exerciseName'],
          'muscleGroup': workout['muscleGroup'],
          'sets': workout['sets'],
          'reps': workout['reps'],
          'weight': workout['weight'],
        });
      }
    }
    
    // Sort by date (most recent first)
    allWorkouts.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    // Take only the most recent workouts (limit to 5)
    final recentWorkouts = allWorkouts.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Workouts',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        if (recentWorkouts.isEmpty)
          Center(
            child: Text(
              'No recent workouts',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ),
        ...recentWorkouts.map((workout) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: secondaryBG,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                workout['exerciseName'] as String,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                '${workout['muscleGroup']} • ${workout['sets']} sets × ${workout['reps']} reps • ${DateFormat('MMM dd, yyyy').format(workout['date'] as DateTime)}',
                style: GoogleFonts.roboto(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 41, 61, 23),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: accentMain,
                  size: 22,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: accentMain.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${workout['weight']} kg',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: accentMain,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}