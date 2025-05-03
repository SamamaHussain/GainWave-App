import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exercisesList.dart';
import 'package:gain_wave_app/utillities/colors.dart';

class WorkoutPlannerScreen extends StatefulWidget {
  const WorkoutPlannerScreen({Key? key}) : super(key: key);

  @override
  _WorkoutPlannerScreenState createState() => _WorkoutPlannerScreenState();
}

class _WorkoutPlannerScreenState extends State<WorkoutPlannerScreen> {
  // User preferences
  String _selectedIntensity = 'Medium';
  String _selectedGoal = 'Build Muscle';
  int _workoutDaysPerWeek = 3;
  
  // Plan options
  final List<String> _intensityLevels = ['Low', 'Medium', 'High'];
  final List<String> _goals = ['Build Muscle', 'Lose Weight', 'Increase Strength'];
  final List<int> _daysPerWeek = [3, 4, 5, 6];
  
  // Workout plans
  final Map<String, String> _planDescriptions = {
    'Power Push': '3-day full body workout focused on compound movements',
    'Muscle Max': '4-day upper/lower split for maximum muscle growth',
    'Total Beast': '5-6 day plan targeting specific muscle groups each day',
  };

  String _recommendedPlan = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customize Your Workout Plan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: textMain),
              ),
              const SizedBox(height: 20),
              
              // Questions section
              _buildQuestionCard(
                'What is your preferred workout intensity?',
                DropdownButton<String>(
                  value: _selectedIntensity,
                  isExpanded: true,
                  items: _intensityLevels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style: const TextStyle(color: textMain),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedIntensity = newValue!;
                      _updateRecommendedPlan();
                    });
                  },
                ),
              ),
              
              _buildQuestionCard(
                'What is your primary fitness goal?',
                DropdownButton<String>(
                  value: _selectedGoal,
                  isExpanded: true,
                  items: _goals.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style: const TextStyle(color: textMain),
                    ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGoal = newValue!;
                      _updateRecommendedPlan();
                    });
                  },
                ),
              ),
              
              _buildQuestionCard(
                'How many days can you work out per week?',
                DropdownButton<int>(
                  value: _workoutDaysPerWeek,
                  isExpanded: true,
                  items: _daysPerWeek.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value days',
                        style: const TextStyle(color: textMain),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _workoutDaysPerWeek = newValue!;
                      _updateRecommendedPlan();
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Recommended plan section
              if (_recommendedPlan.isNotEmpty)
                Card(
                  color: secondaryBG,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const  Row(
                          children: [
                            Icon(Icons.fitness_center, color: accentMain),
                            const SizedBox(width: 8),
                            Text(
                              'Recommended Plan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _recommendedPlan,
                          style: const TextStyle(
                            color: textMain,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_planDescriptions[_recommendedPlan] ?? '',
                          style: const TextStyle(color: textMain),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentMain,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            _showWorkoutPlanDetails(context);
                          },
                          child: const Text('View Plan Details',
                            style: TextStyle(color: primaryBG),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              const SizedBox(height: 20),
              
              // All available plans
              const Text(
                'All Available Plans',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: textMain),
              ),
              const SizedBox(height: 12),
              ..._planDescriptions.entries.map((entry) => 
                _buildPlanCard(entry.key, entry.value)
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question, Widget dropdown) {
    return Card(
      color: secondaryBG,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: textMain),
            ),
            const SizedBox(height: 12),
            dropdown,
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String planName, String description) {
    final bool isRecommended = planName == _recommendedPlan;
    
    return Card(
      color: accentMain,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isRecommended 
            ? const BorderSide(color: textMain, width: 3) 
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _recommendedPlan = planName;
          });
          _showWorkoutPlanDetails(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryBG,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Recommended',
                    style: TextStyle(
                      color: textMain,
                      fontSize: 12,
                    ),
                  ),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _updateRecommendedPlan() {
    // Simple logic to recommend workout plan based on user selections
    if (_workoutDaysPerWeek <= 3) {
      _recommendedPlan = 'Power Push';
    } else if (_workoutDaysPerWeek == 4) {
      _recommendedPlan = 'Muscle Max';
    } else {
      _recommendedPlan = 'Total Beast';
    }
    
    // Override based on intensity
    if (_selectedIntensity == 'Low' && _recommendedPlan == 'Total Beast') {
      _recommendedPlan = 'Muscle Max';
    } else if (_selectedIntensity == 'High' && _workoutDaysPerWeek >= 4) {
      _recommendedPlan = 'Total Beast';
    }
    
    // Adjust based on goal
    if (_selectedGoal == 'Lose Weight' && _recommendedPlan == 'Muscle Max') {
      _recommendedPlan = 'Power Push'; // More full body workouts for calorie burn
    }
  }

  void _showWorkoutPlanDetails(BuildContext context) {
    // Generate workout based on selected plan
    List<WorkoutDay> workoutPlan;
    
    switch (_recommendedPlan) {
      case 'Power Push':
        workoutPlan = _generatePowerPushPlan();
        break;
      case 'Muscle Max':
        workoutPlan = _generateMuscleMaxPlan();
        break;
      case 'Total Beast':
        workoutPlan = _generateTotalBeastPlan();
        break;
      default:
        workoutPlan = _generatePowerPushPlan();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlanDetailsScreen(
          planName: _recommendedPlan,
          workoutPlan: workoutPlan,
        ),
      ),
    );
  }

  List<WorkoutDay> _generatePowerPushPlan() {
    // 3-day full-body workout plan
    return [
      WorkoutDay(
        name: 'Day 1: Full Body Focus',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Squat'),
          exercises.firstWhere((e) => e.name == 'Bench Press'),
          exercises.firstWhere((e) => e.name == 'Lat Pulldown'),
          exercises.firstWhere((e) => e.name == 'Shoulder Press'),
          exercises.firstWhere((e) => e.name == 'Plank'),
        ],
      ),
      WorkoutDay(
        name: 'Day 2: Full Body Strength',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Deadlift'),
          exercises.firstWhere((e) => e.name == 'Incline Dumbbell Press'),
          exercises.firstWhere((e) => e.name == 'Pull-Up'),
          exercises.firstWhere((e) => e.name == 'Bicep Curl'),
          exercises.firstWhere((e) => e.name == 'Russian Twist'),
        ],
      ),
      WorkoutDay(
        name: 'Day 3: Full Body Power',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Leg Press'),
          exercises.firstWhere((e) => e.name == 'Cable Row'),
          exercises.firstWhere((e) => e.name == 'Dumbbell Fly'),
          exercises.firstWhere((e) => e.name == 'Tricep Dip'),
          exercises.firstWhere((e) => e.name == 'Mountain Climbers'),
        ],
      ),
    ];
  }

  List<WorkoutDay> _generateMuscleMaxPlan() {
    // 4-day upper/lower split
    return [
      WorkoutDay(
        name: 'Day 1: Upper Body',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Bench Press'),
          exercises.firstWhere((e) => e.name == 'Cable Row'),
          exercises.firstWhere((e) => e.name == 'Shoulder Press'),
          exercises.firstWhere((e) => e.name == 'Pull-Up'),
          exercises.firstWhere((e) => e.name == 'Tricep Dip'),
        ],
      ),
      WorkoutDay(
        name: 'Day 2: Lower Body',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Squat'),
          exercises.firstWhere((e) => e.name == 'Leg Press'),
          exercises.firstWhere((e) => e.name == 'Lunges'),
          exercises.firstWhere((e) => e.name == 'Leg Curl'),
          exercises.firstWhere((e) => e.name == 'Seated Calf Raise'),
        ],
      ),
      WorkoutDay(
        name: 'Day 3: Upper Body Focus',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Incline Dumbbell Press'),
          exercises.firstWhere((e) => e.name == 'Lat Pulldown'),
          exercises.firstWhere((e) => e.name == 'Dumbbell Fly'),
          exercises.firstWhere((e) => e.name == 'Bicep Curl'),
          exercises.firstWhere((e) => e.name == 'Hammer Curl'),
        ],
      ),
      WorkoutDay(
        name: 'Day 4: Lower Body Power',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Deadlift'),
          exercises.firstWhere((e) => e.name == 'Leg Extension'),
          exercises.firstWhere((e) => e.name == 'Lunges'),
          exercises.firstWhere((e) => e.name == 'Plank'),
          exercises.firstWhere((e) => e.name == 'Russian Twist'),
        ],
      ),
    ];
  }

  List<WorkoutDay> _generateTotalBeastPlan() {
    // 5-6 day split focusing on specific muscle groups
    return [
      WorkoutDay(
        name: 'Day 1: Chest Focus',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Bench Press'),
          exercises.firstWhere((e) => e.name == 'Incline Dumbbell Press'),
          exercises.firstWhere((e) => e.name == 'Dumbbell Fly'),
          exercises.firstWhere((e) => e.name == 'Tricep Dip'),
          exercises.firstWhere((e) => e.name == 'Plank'),
        ],
      ),
      WorkoutDay(
        name: 'Day 2: Back Day',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Deadlift'),
          exercises.firstWhere((e) => e.name == 'Pull-Up'),
          exercises.firstWhere((e) => e.name == 'Lat Pulldown'),
          exercises.firstWhere((e) => e.name == 'Cable Row'),
          exercises.firstWhere((e) => e.name == 'Russian Twist'),
        ],
      ),
      WorkoutDay(
        name: 'Day 3: Leg Power',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Squat'),
          exercises.firstWhere((e) => e.name == 'Leg Press'),
          exercises.firstWhere((e) => e.name == 'Leg Extension'),
          exercises.firstWhere((e) => e.name == 'Leg Curl'),
          exercises.firstWhere((e) => e.name == 'Seated Calf Raise'),
        ],
      ),
      WorkoutDay(
        name: 'Day 4: Shoulders & Arms',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Shoulder Press'),
          exercises.firstWhere((e) => e.name == 'Bicep Curl'),
          exercises.firstWhere((e) => e.name == 'Tricep Dip'),
          exercises.firstWhere((e) => e.name == 'Hammer Curl'),
          exercises.firstWhere((e) => e.name == 'Mountain Climbers'),
        ],
      ),
      WorkoutDay(
        name: 'Day 5: Full Body Finish',
        exercises: [
          exercises.firstWhere((e) => e.name == 'Lunges'),
          exercises.firstWhere((e) => e.name == 'Pull-Up'),
          exercises.firstWhere((e) => e.name == 'Bench Press'),
          exercises.firstWhere((e) => e.name == 'Shoulder Press'),
          exercises.firstWhere((e) => e.name == 'Plank'),
        ],
      ),
    ];
  }
}

// Workout model classes
class WorkoutDay {
  final String name;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.name,
    required this.exercises,
  });
}

// Workout Plan Details Screen
class WorkoutPlanDetailsScreen extends StatelessWidget {
  final String planName;
  final List<WorkoutDay> workoutPlan;

  const WorkoutPlanDetailsScreen({
    Key? key,
    required this.planName,
    required this.workoutPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        appBar: AppBar(
          title: Text(planName),
          backgroundColor:accentMain,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Save workout plan to user's profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Workout plan saved!')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${workoutPlan.length} days per week',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This plan is designed to hit all muscle groups throughout the week with optimal recovery time.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ...workoutPlan.map((day) => _buildWorkoutDayCard(day)).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentMain,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Save and start the workout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Workout plan activated!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Start This Plan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDayCard(WorkoutDay day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...day.exercises.map((exercise) => _buildExerciseItem(exercise)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryBG,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.fitness_center, color: accentMain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${exercise.defaultSets} sets × ${exercise.defaultReps} reps',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show exercise details
            },
          ),
        ],
      ),
    );
  }
}