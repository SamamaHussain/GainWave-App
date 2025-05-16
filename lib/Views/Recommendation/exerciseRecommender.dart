// // lib/screens/exercise_recommendation_form.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_hooks/flutter_hooks.dart';

// class ExerciseRecommendation extends HookWidget {
//   const ExerciseRecommendation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final formKey = useMemoized(() => GlobalKey<FormState>());
//     final age = useTextEditingController();
//     final weight = useTextEditingController();
//     final height = useTextEditingController();
//     final duration = useTextEditingController();
//     final calories = useTextEditingController();
//     final fat = useTextEditingController();
//     final water = useTextEditingController();
//     final frequency = useTextEditingController();
//     final experience = useState<String>("Beginner");
//     final bmi = useTextEditingController();
//     final gender = useState<int>(0);
//     final result = useState<String?>(null);
//     final loading = useState<bool>(false);
    
//     // Map experience level to numeric value
//     final experienceMap = {
//       "Beginner": 1,
//       "Intermediate": 2,
//       "Advanced": 3,
//     };

//     // Calculate BMI automatically
//     useEffect(() {
//       void calculateBMI() {
//         if (weight.text.isNotEmpty && height.text.isNotEmpty) {
//           try {
//             final w = double.parse(weight.text);
//             final h = double.parse(height.text);
//             if (w > 0 && h > 0) {
//               final bmiValue = (w / (h * h)).toStringAsFixed(1);
//               bmi.text = bmiValue;
//             }
//           } catch (_) {
//             // Invalid input, do nothing
//           }
//         }
//       }

//       weight.addListener(calculateBMI);
//       height.addListener(calculateBMI);
      
//       return () {
//         weight.removeListener(calculateBMI);
//         height.removeListener(calculateBMI);
//       };
//     }, [weight, height]);

//     Future<void> getRecommendation() async {
//       result.value = null;
//       loading.value = true;

//       final Map<String, dynamic> userData = {
//         "Age": int.parse(age.text),
//         "Gender": gender.value,
//         "Weight (kg)": double.parse(weight.text),
//         "Height (m)": double.parse(height.text),
//         "Session_Duration (hours)": double.parse(duration.text),
//         "Calories_Burned": double.parse(calories.text),
//         "Fat_Percentage": double.parse(fat.text),
//         "Water_Intake (liters)": double.parse(water.text),
//         "Workout_Frequency (days/week)": int.parse(frequency.text),
//         "Experience_Level": experienceMap[experience.value],
//         "BMI": double.parse(bmi.text),
//       };

//       try {
//         final res = await http.post(
//           Uri.parse("http://127.0.0.1:5000/predict"), // Update if hosted remotely
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(userData),
//         );

//         final body = jsonDecode(res.body);
//         result.value = body['recommendation'];
//       } catch (e) {
//         result.value = "Error: $e";
//       } finally {
//         loading.value = false;
//       }
//     }

//     Widget inputField(String label, TextEditingController controller, {String? suffixText, String? hintText, bool readOnly = false}) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: TextFormField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           readOnly: readOnly,
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: hintText,
//             suffixText: suffixText,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             filled: true,
//             fillColor: Colors.grey.shade50,
//           ),
//           validator: (v) => v == null || v.isEmpty ? "Required" : null,
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exercise Recommendation'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.white, Theme.of(context).colorScheme.primary.withOpacity(0.05)],
//           ),
//         ),
//         child: Form(
//           key: formKey,
//           child: ListView(
//             padding: const EdgeInsets.all(20),
//             children: [
//               // Form header
//               Text(
//                 "Your Fitness Profile",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 "Enter your details to get a personalized workout recommendation",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 24),
              
//               // Form sections
//               _buildSectionHeader(context, "Personal Information", Icons.person),
//               const SizedBox(height: 16),
              
//               // Personal info section
//               Row(
//                 children: [
//                   Expanded(child: inputField("Age", age, suffixText: "years")),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: DropdownButtonFormField<int>(
//                       value: gender.value,
//                       decoration: InputDecoration(
//                         labelText: "Gender",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                         filled: true,
//                         fillColor: Colors.grey.shade50,
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: 0, child: Text("Male")),
//                         DropdownMenuItem(value: 1, child: Text("Female")),
//                       ],
//                       onChanged: (v) => gender.value = v!,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
              
//               Row(
//                 children: [
//                   Expanded(child: inputField("Weight", weight, suffixText: "kg")),
//                   const SizedBox(width: 16),
//                   Expanded(child: inputField("Height", height, suffixText: "m", hintText: "e.g. 1.75")),
//                 ],
//               ),
              
//               inputField("BMI", bmi, readOnly: true),
              
//               const SizedBox(height: 24),
//               _buildSectionHeader(context, "Workout Information", Icons.fitness_center),
//               const SizedBox(height: 16),
              
//               // Workout info section
//               Row(
//                 children: [
//                   Expanded(child: inputField("Session Duration", duration, suffixText: "hours")),
//                   const SizedBox(width: 16),
//                   Expanded(child: inputField("Frequency", frequency, suffixText: "days/week")),
//                 ],
//               ),
              
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: experience.value,
//                 decoration: InputDecoration(
//                   labelText: "Experience Level",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
//                   DropdownMenuItem(value: "Intermediate", child: Text("Intermediate")),
//                   DropdownMenuItem(value: "Advanced", child: Text("Advanced")),
//                 ],
//                 onChanged: (v) => experience.value = v!,
//               ),
              
//               const SizedBox(height: 24),
//               _buildSectionHeader(context, "Health Metrics", Icons.monitor_heart),
//               const SizedBox(height: 16),
              
//               // Health metrics section
//               Row(
//                 children: [
//                   Expanded(child: inputField("Calories Burned", calories, suffixText: "kcal")),
//                   const SizedBox(width: 16),
//                   Expanded(child: inputField("Fat Percentage", fat, suffixText: "%")),
//                 ],
//               ),
              
//               inputField("Water Intake", water, suffixText: "liters"),
              
//               const SizedBox(height: 32),
              
//               // Submit button
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.play_arrow),
//                 label: Text(loading.value ? "Processing..." : "Get Your Workout Plan"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: loading.value ? null : () {
//                   if (formKey.currentState!.validate()) {
//                     getRecommendation();
//                   }
//                 },
//               ),
              
//               const SizedBox(height: 32),
              
//               // Results section
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 500),
//                 child: loading.value
//                     ? const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(32.0),
//                           child: Column(
//                             children: [
//                               CircularProgressIndicator(),
//                               SizedBox(height: 16),
//                               Text("Creating your personalized plan...")
//                             ],
//                           ),
//                         ),
//                       )
//                     : result.value != null
//                         ? _buildResultCard(context, result.value!)
//                         : const SizedBox.shrink(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: Theme.of(context).colorScheme.primary,
//           size: 20,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildResultCard(BuildContext context, String recommendation) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.star,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   "Your Personalized Workout Plan",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 24),
//             Text(
//               recommendation,
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/exercise_recommendation_form.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';


class ExerciseRecommendation extends HookWidget {
  const ExerciseRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final age = useTextEditingController();
    final weight = useTextEditingController();
    final height = useTextEditingController();
    final duration = useTextEditingController();
    final calories = useTextEditingController();
    final fat = useTextEditingController();
    final water = useTextEditingController();
    final frequency = useTextEditingController();
    final experience = useState<String>("Beginner");
    final bmi = useTextEditingController();
    final gender = useState<int>(0);
    final result = useState<String?>(null);
    final loading = useState<bool>(false);
    
    // Map experience level to numeric value
    final experienceMap = {
      "Beginner": 1,
      "Intermediate": 2,
      "Advanced": 3,
    };

    // Calculate BMI automatically
    useEffect(() {
      void calculateBMI() {
        if (weight.text.isNotEmpty && height.text.isNotEmpty) {
          try {
            final w = double.parse(weight.text);
            final h = double.parse(height.text);
            if (w > 0 && h > 0) {
              final bmiValue = (w / (h * h)).toStringAsFixed(1);
              bmi.text = bmiValue;
            }
          } catch (_) {
            // Invalid input, do nothing
          }
        }
      }

      weight.addListener(calculateBMI);
      height.addListener(calculateBMI);
      
      return () {
        weight.removeListener(calculateBMI);
        height.removeListener(calculateBMI);
      };
    }, [weight, height]);

    Future<void> getRecommendation() async {
      result.value = null;
      loading.value = true;

      final Map<String, dynamic> userData = {
        "Age": int.parse(age.text),
        "Gender": gender.value,
        "Weight (kg)": double.parse(weight.text),
        "Height (m)": double.parse(height.text),
        "Session_Duration (hours)": double.parse(duration.text),
        "Calories_Burned": double.parse(calories.text),
        "Fat_Percentage": double.parse(fat.text),
        "Water_Intake (liters)": double.parse(water.text),
        "Workout_Frequency (days/week)": int.parse(frequency.text),
        "Experience_Level": experienceMap[experience.value],
        "BMI": double.parse(bmi.text),
      };

      try {
        final res = await http.post(
          Uri.parse("http://10.120.83.226:5000/predict"), // Update if hosted remotely
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        final body = jsonDecode(res.body);
        result.value = body['recommendation'];
      } catch (e) {
        result.value = "Error: $e";
      } finally {
        loading.value = false;
      }
    }


    Widget freqInputField(String label, TextEditingController controller, {
      String? suffixText, 
      String? hintText, 
      bool readOnly = false, 
      String? Function(String?)? validator
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.allow(RegExp(r'^[1-7]')), // Allows only 1–7
  ],
          readOnly: readOnly,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            suffixText: suffixText,
            labelStyle: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 16,
            ),
            hintStyle: GoogleFonts.roboto(
              color: Colors.white38,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentMain),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: secondaryBG,
          ),
          validator: validator ?? (v) => v == null || v.isEmpty ? "Required" : null,
        ),
      );
    }

    Widget inputField(String label, TextEditingController controller, {
      String? suffixText, 
      String? hintText, 
      bool readOnly = false, 
      String? Function(String?)? validator
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          readOnly: readOnly,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            suffixText: suffixText,
            labelStyle: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 16,
            ),
            hintStyle: GoogleFonts.roboto(
              color: Colors.white38,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentMain),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: secondaryBG,
          ),
          validator: validator ?? (v) => v == null || v.isEmpty ? "Required" : null,
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryBG,
      appBar: AppBar(
        backgroundColor: primaryBG,
        title: Text(
          'Exercise Recommendation',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryBG, primaryBG.withOpacity(0.8)],
          ),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              // Form header
              Row(
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    color: accentMain,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Your Fitness Profile",
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: accentMain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Enter your details to get a personalized workout recommendation",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              
              // Form sections
              _buildSectionHeader(context, "Personal Information", Icons.person),
              const SizedBox(height: 16),
              
              // Personal info section
              Row(
                children: [
                  Expanded(
                    child: inputField(
                      "Age", 
                      age, 
                      suffixText: "years",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = int.parse(v);
                          if (value <= 15 || value > 120) return "age range 15-120";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: gender.value,
                      dropdownColor: secondaryBG,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: accentMain),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        filled: true,
                        fillColor: secondaryBG,
                      ),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("Male")),
                        DropdownMenuItem(value: 1, child: Text("Female")),
                      ],
                      onChanged: (v) => gender.value = v!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: inputField(
                      "Weight", 
                      weight, 
                      suffixText: "kg",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = double.parse(v);
                          if (value <= 30 || value > 600) return "weight must be more than 30 and less than 600";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: inputField(
                      "Height", 
                      height, 
                      suffixText: "m", 
                      hintText: "e.g. 1.75",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = double.parse(v);
                          if (value <= 1.4 || value > 2.5) return "height must be from 1.4-2.5";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                ],
              ),
              
              inputField("BMI", bmi, readOnly: true),
              
              const SizedBox(height: 24),
              _buildSectionHeader(context, "Workout Information", Icons.fitness_center),
              const SizedBox(height: 16),
              
              // Workout info section
              Row(
                children: [
                  Expanded(
                    child: inputField(
                      "Session Duration", 
                      duration, 
                      suffixText: "hours",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = double.parse(v);
                          if (value <= 1 || value > 3) return "Enter between 1-3";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: freqInputField(
                      "Frequency", 
                      frequency, 
                      suffixText: "days/week", 


                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = int.parse(v);
                          if (value <= 2 || value > 7) return "Min 2 days, Max 7 days";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: experience.value,
                dropdownColor: secondaryBG,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: "Experience Level",
                  labelStyle: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentMain),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  filled: true,
                  fillColor: secondaryBG,
                ),
                items: const [
                  DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
                  DropdownMenuItem(value: "Intermediate", child: Text("Intermediate")),
                  DropdownMenuItem(value: "Advanced", child: Text("Advanced")),
                ],
                onChanged: (v) => experience.value = v!,
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(context, "Health Metrics", Icons.monitor_heart),
              const SizedBox(height: 16),
              
              // Health metrics section
              Row(
                children: [
                  Expanded(
                    child: inputField(
                      "Calories to Burn", 
                      calories, 
                      suffixText: "kcal",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = double.parse(v);
                          if (value < 50 || value > 5000) return "value must be above 50";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: inputField(
                      "Fat Percentage", 
                      fat, 
                      suffixText: "%",
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        try {
                          final value = double.parse(v);
                          if (value < 1 || value > 80) return "percentage must be 1-80";
                        } catch (_) {
                          return "Numbers only";
                        }
                        return null;
                      }
                    )
                  ),
                ],
              ),
              
              inputField(
                "Water Intake", 
                water, 
                suffixText: "liters",
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  try {
                    final value = double.parse(v);
                    if (value < 0 || value > 10) return "value must be 1-10 liters";
                  } catch (_) {
                    return "Numbers only";
                  }
                  return null;
                }
              ),
              
              const SizedBox(height: 32),
              
              // Submit button
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  loading.value ? "Processing..." : "Get Your Workout Plan",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentMain,
                  foregroundColor: primaryBG,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: loading.value ? null : () {
                  if (formKey.currentState!.validate()) {
                    getRecommendation();
                  }
                },
              ),
              
              const SizedBox(height: 32),
              
              // Results section
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: loading.value
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: accentMain,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Creating your personalized plan...",
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : result.value != null
                        ? _buildResultCard(context, result.value!)
                        : const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: accentMain,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: accentMain,
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultCard(BuildContext context, String recommendation) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: secondaryBG,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: accentMain,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  "Your Personalized Workout Plan",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: accentMain,
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 1,
              color: Colors.white12,
            ),
            Text(
              recommendation,
              style: GoogleFonts.roboto(
                fontSize: 16,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt, size: 18),
                  label: Text(
                    "Save Plan",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentMain.withOpacity(0.2),
                    foregroundColor: accentMain,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Save functionality would go here 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Workout plan saved!",
                          style: GoogleFonts.roboto(),
                        ),
                        backgroundColor: accentMain,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}