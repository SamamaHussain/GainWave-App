import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gain_wave_app/Views/Analysis%20and%20Reporting/AnalysisDataService.dart';
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
      appBar: AppBar(
        title: const Text('Workout Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
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
        const Text(
          'Last 7 Days',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Workouts',
                _totalWorkouts.toString(),
                Icons.fitness_center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Volume',
                _totalVolume.toString(),
                Icons.analytics,
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
                Icons.timer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Avg Volume',
                _avgVolume.toStringAsFixed(1),
                Icons.analytics,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No muscle volume data available'),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Muscle Volume Trend',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
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
                                style: const TextStyle(fontSize: 10),
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
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
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
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
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
        const Text(
          'Muscle Group Focus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _muscleGroupSummary.entries.map((entry) {
                final total = _muscleGroupSummary.values.fold(0, (sum, count) => sum + count);
                final percentage = total > 0 ? (entry.value / total) * 100 : 0;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${percentage.toStringAsFixed(1)}% (${entry.value} workouts)',
                              style: const TextStyle(fontSize: 12),
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
      return const Center(child: Text('No recent workouts'));
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
        const Text(
          'Recent Workouts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (recentWorkouts.isEmpty)
          const Center(child: Text('No recent workouts')),
        ...recentWorkouts.map((workout) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                workout['exerciseName'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${workout['muscleGroup']} • ${workout['sets']} sets × ${workout['reps']} reps • ${DateFormat('MMM dd, yyyy').format(workout['date'] as DateTime)}',
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              trailing: Text(
                '${workout['weight']} kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
  
  // IconData _getMuscleGroupIcon(String muscleGroup) {
  //   switch (muscleGroup.toLowerCase()) {
  //     case 'chest':
  //       return Icons.accessibility_new;
  //     case 'back':
  //       return Icons.airline_seat_flat;
  //     case 'legs':
  //       return Icons.directions_walk;
  //     case 'shoulders':
  //       return Icons.fitness_center;
  //     case 'arms':
  //       return Icons.sports_gymnastics;
  //     case 'abs':
  //       return Icons.rectangle;
  //     default:
  //       return Icons.fitness_center;
  //   }
  // }
}