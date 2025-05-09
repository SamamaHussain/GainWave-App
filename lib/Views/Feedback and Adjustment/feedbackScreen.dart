import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exercisesList.dart';

class WorkoutFeedbackScreen extends StatefulWidget {
  const WorkoutFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutFeedbackScreen> createState() => _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends State<WorkoutFeedbackScreen> {
  // Import exercises from the provided list
  final List<Exercise> exerciseList = exercises;
  
  Exercise? selectedExercise;
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String feedback = '';
  bool _showFeedbackForm = false;
  bool _showFeedback = false;

  // Feedback questions with answers
  Map<String, String?> feedbackAnswers = {
    'How difficult was the workout?': null,
    'Did you feel muscle fatigue?': null,
    'Was the exercise form correct?': null,
    'How long did you rest between sets?': null,
  };

  @override
  void dispose() {
    _repsController.dispose();
    _setsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _selectExercise(Exercise exercise) {
    setState(() {
      selectedExercise = exercise;
      _repsController.text = exercise.defaultReps.toString();
      _setsController.text = exercise.defaultSets.toString();
      _weightController.text = '0';
      _showFeedbackForm = false;
      _showFeedback = false;
      feedback = '';
    });
  }

  void _submitWorkoutDetails() {
    if (_repsController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _showFeedbackForm = true;
      _showFeedback = false;
    });
  }

  void _generateFeedback() {
    // Check if all questions are answered
    if (feedbackAnswers.values.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    // Parse workout details
    final int reps = int.tryParse(_repsController.text) ?? 0;
    final int sets = int.tryParse(_setsController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;

    // Generate feedback based on answers and workout details
    String feedbackResult = '';
    
    // Difficulty-based feedback
    if (feedbackAnswers['How difficult was the workout?'] == 'Too easy') {
      if (weight > 0) {
        feedbackResult += '• Increase your weight by 5-10% next time.\n';
      } else {
        feedbackResult += '• Consider adding weight to this exercise.\n';
      }
    } else if (feedbackAnswers['How difficult was the workout?'] == 'Too hard') {
      if (sets > 2) {
        feedbackResult += '• Reduce your sets by 1 until you build more strength.\n';
      }
      if (weight > 0) {
        feedbackResult += '• Decrease your weight by 10-15% to maintain proper form.\n';
      }
    }

    // Muscle fatigue feedback
    if (feedbackAnswers['Did you feel muscle fatigue?'] == 'No') {
      feedbackResult += '• Try increasing your sets by 1-2 to maximize muscle growth.\n';
      if (weight > 0) {
        feedbackResult += '• Consider increasing your weight by 5% next session.\n';
      }
    } else if (feedbackAnswers['Did you feel muscle fatigue?'] == 'Too much') {
      feedbackResult += '• You might be overtraining. Keep your current sets but ensure adequate rest between workouts.\n';
    }

    // Form-based feedback
    if (feedbackAnswers['Was the exercise form correct?'] == 'No') {
      if (weight > 0) {
        feedbackResult += '• Lower your weight until you can maintain proper form throughout all sets.\n';
      }
      feedbackResult += '• Consider watching tutorial videos for correct ${selectedExercise?.name} form.\n';
    }

    // Rest time feedback
    if (feedbackAnswers['How long did you rest between sets?'] == 'Less than 30 seconds') {
      feedbackResult += '• For strength training, consider longer rest periods (60-90 seconds) between sets.\n';
    } else if (feedbackAnswers['How long did you rest between sets?'] == 'More than 3 minutes') {
      feedbackResult += '• Try reducing rest time between sets to 1-2 minutes for optimal muscle growth.\n';
    }

    // If no specific feedback was generated
    if (feedbackResult.isEmpty) {
      feedbackResult = 'Your workout looks great! Keep maintaining this level of intensity and consistency.';
    } else {
      feedbackResult = 'Based on your feedback, here are some suggestions:\n\n$feedbackResult';
    }

    setState(() {
      feedback = feedbackResult;
      _showFeedback = true;
    });
  }

  Widget _buildExerciseSelector() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Exercise',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<Exercise>(
                isExpanded: true,
                underline: Container(),
                value: selectedExercise,
                hint: const Text('Select an exercise'),
                items: exerciseList.map((Exercise exercise) {
                  return DropdownMenuItem<Exercise>(
                    value: exercise,
                    child: Text(exercise.name),
                  );
                }).toList(),
                onChanged: (Exercise? value) {
                  if (value != null) {
                    _selectExercise(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDetailsForm() {
    if (selectedExercise == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${selectedExercise!.name} Details',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitWorkoutDetails,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Submit Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    if (!_showFeedbackForm) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...feedbackAnswers.keys.map((question) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  if (question == 'How difficult was the workout?')
                    _buildRadioGroup(
                      question,
                      ['Too easy', 'Just right', 'Too hard'],
                    ),
                  if (question == 'Did you feel muscle fatigue?')
                    _buildRadioGroup(
                      question,
                      ['No', 'Just right', 'Too much'],
                    ),
                  if (question == 'Was the exercise form correct?')
                    _buildRadioGroup(
                      question,
                      ['Yes', 'Partially', 'No'],
                    ),
                  if (question == 'How long did you rest between sets?')
                    _buildRadioGroup(
                      question,
                      ['Less than 30 seconds', '30-90 seconds', '1-3 minutes', 'More than 3 minutes'],
                    ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
            Center(
              child: ElevatedButton(
                onPressed: _generateFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Get Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String question, List<String> options) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: feedbackAnswers[question],
          onChanged: (value) {
            setState(() {
              feedbackAnswers[question] = value;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackResult() {
    if (!_showFeedback || feedback.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Personalized Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              feedback,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acknowledge feedback received
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback acknowledged!')),
                  );
                  
                  // Reset the form
                  setState(() {
                    selectedExercise = null;
                    _repsController.clear();
                    _setsController.clear();
                    _weightController.clear();
                    feedbackAnswers = {
                      'How difficult was the workout?': null,
                      'Did you feel muscle fatigue?': null,
                      'Was the exercise form correct?': null,
                      'How long did you rest between sets?': null,
                    };
                    _showFeedbackForm = false;
                    _showFeedback = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExerciseSelector(),
              const SizedBox(height: 8),
              _buildWorkoutDetailsForm(),
              const SizedBox(height: 8),
              _buildFeedbackForm(),
              const SizedBox(height: 8),
              _buildFeedbackResult(),
            ],
          ),
        ),
      ),
    );
  }
}