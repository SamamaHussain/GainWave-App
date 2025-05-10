import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Performance/Model/exerciseModel.dart';
import 'package:gain_wave_app/Views/Performance/Services/exercisesList.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // final int reps = int.tryParse(_repsController.text) ?? 0;
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
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 41, 61, 23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 35,
                    color: accentMain,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Select Exercise',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white24,
              height: 40,
            ),
            Text(
              'Choose your exercise',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white24),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Exercise>(
                  isExpanded: true,
                  value: selectedExercise,
                  hint: Text(
                    'Select an exercise',
                    style: GoogleFonts.roboto(color: Colors.white70),
                  ),
                  dropdownColor: secondaryBG,
                  icon: const Icon(Icons.arrow_drop_down, color: accentMain),
                  items: exerciseList.map((Exercise exercise) {
                    return DropdownMenuItem<Exercise>(
                      value: exercise,
                      child: Text(
                        exercise.name,
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (Exercise? value) {
                    if (value != null) {
                      _selectExercise(value);
                    }
                  },
                ),
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
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 41, 61, 23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    size: 35,
                    color: accentMain,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '${selectedExercise!.name} Details',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white24,
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _repsController,
                    label: 'Reps',
                    icon: Icons.repeat,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _setsController,
                    label: 'Sets',
                    icon: Icons.format_list_numbered,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _weightController,
                    label: 'Weight | kg',
                    icon: Icons.monitor_weight_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitWorkoutDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentMain,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Submit Workout',
                  style: GoogleFonts.roboto(
                    color: primaryBG,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.roboto(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.white70),
        prefixIcon: Icon(icon, color: accentMain, size: 22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: accentMain),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    if (!_showFeedbackForm) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 41, 61, 23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rate_review_outlined,
                    size: 35,
                    color: accentMain,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Workout Feedback',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white24,
              height: 40,
            ),
            ...feedbackAnswers.keys.map((question) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
            Center(
              child: ElevatedButton(
                onPressed: _generateFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentMain,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Get Feedback',
                  style: GoogleFonts.roboto(
                    color: primaryBG,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String question, List<String> options) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: options.map((option) {
          return RadioListTile<String>(
            title: Text(
              option,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            value: option,
            groupValue: feedbackAnswers[question],
            onChanged: (value) {
              setState(() {
                feedbackAnswers[question] = value;
              });
            },
            activeColor: accentMain,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedbackResult() {
    if (!_showFeedback || feedback.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 41, 61, 23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tips_and_updates_outlined,
                    size: 35,
                    color: accentMain,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Your Personalized Feedback',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white24,
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Text(
                feedback,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                  backgroundColor: accentMain,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.roboto(
                    color: primaryBG,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        appBar: AppBar(
          backgroundColor: primaryBG,
          elevation: 0,
          title: Text(
            'Workout Feedback',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildExerciseSelector(),
                const SizedBox(height: 16),
                _buildWorkoutDetailsForm(),
                const SizedBox(height: 16),
                _buildFeedbackForm(),
                const SizedBox(height: 16),
                _buildFeedbackResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}