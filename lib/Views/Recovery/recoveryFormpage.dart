import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Recovery/recoveryRecommendationPage.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecoveryFormPage extends StatefulWidget {
  @override
  _RecoveryFormPageState createState() => _RecoveryFormPageState();
}

class _RecoveryFormPageState extends State<RecoveryFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _sorenessController = TextEditingController();

  bool isSubmitting = false;

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', int.parse(_ageController.text));
    await prefs.setDouble('weight', double.parse(_weightController.text));
    await prefs.setDouble('sleepHours', double.parse(_sleepController.text));
    await prefs.setDouble('waterIntake', double.parse(_waterController.text));
    await prefs.setDouble('sorenessLevel', double.parse(_sorenessController.text));
  }

  void _navigateToRecommendations() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isSubmitting = true);
      await _saveData();
      setState(() => isSubmitting = false);
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => RecoveryRecommendationPage()),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.roboto(color: Colors.white70),
      hintText: hint,
      hintStyle: GoogleFonts.roboto(color: Colors.white38),
      prefixIcon: Icon(icon, color: accentMain),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentMain, width: 2),
      ),
      filled: true,
      fillColor: primaryBG,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
            'Recovery Profile',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: primaryBG,
          child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Card(
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
                                  Icons.fitness_center_outlined, 
                                  size: 35, 
                                  color: accentMain
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  'Let\'s Personalize Your Recovery',
                                  style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Fill in the details below to get tailored recovery recommendations based on your profile.',
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Form Inputs
                  Card(
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
                                  Icons.person_outline_rounded, 
                                  size: 35, 
                                  color: accentMain
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                'Your Details',
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
                  
                          // Age Input
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(color: Colors.white),
                            decoration: _buildInputDecoration(
                                'Age', 'Enter your age (years)', Icons.cake_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              int? age = int.tryParse(value);
                              if (age == null || age < 15 || age > 120) {
                                return 'Your age must be (15-120)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                  
                          // Weight Input
                          TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(color: Colors.white),
                            decoration: _buildInputDecoration(
                                'Weight', 'Enter your weight (kg)', Icons.fitness_center_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your weight';
                              }
                              double? weight = double.tryParse(value);
                              if (weight == null || weight < 30 || weight > 600) {
                                return 'Enter a valid weight (30-600 kg)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                  
                          // Sleep Hours Input
                          TextFormField(
                            controller: _sleepController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(color: Colors.white),
                            decoration: _buildInputDecoration(
                                'Sleep Hours', 'Enter daily sleep hours', Icons.nights_stay_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your sleep hours';
                              }
                              double? sleep = double.tryParse(value);
                              if (sleep == null || sleep < 0 || sleep > 12) {
                                return 'Enter valid sleep hours (0-12)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                  
                          // Water Intake Input
                          TextFormField(
                            controller: _waterController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(color: Colors.white),
                            decoration: _buildInputDecoration(
                                'Water Intake', 'Enter daily water intake (liters)', Icons.local_drink_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your water intake';
                              }
                              double? water = double.tryParse(value);
                              if (water == null || water < 0 || water > 10) {
                                return 'Enter valid water intake (0-10 liters)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                  
                          // Muscle Soreness Input
                          // TextFormField(
                          //   controller: _sorenessController,
                          //   keyboardType: TextInputType.number,
                          //   style: GoogleFonts.roboto(color: Colors.white),
                          //   decoration: _buildInputDecoration(
                          //       'Muscle Soreness', 'Rate soreness (1-10)', Icons.accessibility_new_outlined),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your soreness level';
                          //     }
                          //     double? soreness = double.tryParse(value);
                          //     if (soreness == null || soreness < 1 || soreness > 10) {
                          //       return 'Enter valid soreness level (1-10)';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: TextFormField(
        controller: _sorenessController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.roboto(color: Colors.white),
        decoration: _buildInputDecoration(
            'Muscle Soreness', 'Rate soreness (1-10)', Icons.accessibility_new_outlined),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your soreness level';
          }
          double? soreness = double.tryParse(value);
          if (soreness == null || soreness < 1 || soreness > 10) {
            return 'Enter valid soreness level (1-10)';
          }
          return null;
        },
      ),
    ),
    const Padding(
      padding: EdgeInsets.only(top: 12, left: 4),
      child: Tooltip(
        message: '1 = Low level soreness, 10 = Extreme soreness/pain',
        child: Icon(
          Icons.info_outline,
          size: 18,
          color: Colors.white70,
        ),
      ),
    ),
  ],
),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _navigateToRecommendations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentMain,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      textStyle: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Center(child: Text('See Recommendations')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}