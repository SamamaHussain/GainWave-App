// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RecoveryRecommendationPage extends StatefulWidget {
//   @override
//   _RecoveryRecommendationPageState createState() => _RecoveryRecommendationPageState();
// }

// class _RecoveryRecommendationPageState extends State<RecoveryRecommendationPage> {
//   double sleepHours = 7;
//   double waterIntake = 2;
//   double sorenessLevel = 3;
//   int age = 25;
//   double weight = 70;
//   String suggestions = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sleepHours = prefs.getDouble('sleepHours') ?? 7;
//       waterIntake = prefs.getDouble('waterIntake') ?? 2;
//       sorenessLevel = prefs.getDouble('sorenessLevel') ?? 3;
//       age = prefs.getInt('age') ?? 25;
//       weight = prefs.getDouble('weight') ?? 70;
//     });
//     _generateSuggestions();
//   }

//   void _generateSuggestions() {
//     String newSuggestions = '';

//     // Sleep recommendations based on age
//     if (age >= 18 && age <= 64 && sleepHours < 7) {
//       newSuggestions += '• Adults need 7-9 hours of sleep. Try to rest more.\n';
//     } else if (age > 64 && sleepHours < 7) {
//       newSuggestions += '• Older adults need 7-8 hours of sleep.\n';
//     }

//     // Water intake recommendations based on weight
//     double recommendedWater = weight * 0.05; // Approx. 5 ml/kg
//     if (waterIntake < recommendedWater) {
//       newSuggestions +=
//           '• Based on your weight, drink at least ${recommendedWater.toStringAsFixed(1)} liters of water daily.\n';
//     }

//     // Soreness recommendations
//     if (sorenessLevel > 5) {
//       newSuggestions += '• Take a rest day or try light stretching for recovery.\n';
//     }

//     // Final suggestion if everything is fine
//     if (newSuggestions.isEmpty) {
//       newSuggestions = 'You’re on track! Keep it up!';
//     }

//     setState(() {
//       suggestions = newSuggestions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Recommendations'),
//         backgroundColor: const Color(0xFF9dff3b),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.green.shade300, Colors.green.shade800],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Title Section
//                 const Text(
//                   'Hello! Here are your recommendations:',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Based on your personal inputs, we’ve tailored these tips to help you optimize your health and fitness journey.',
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),

//                 // Recommendation Card
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         const BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Card Title
//                         const Row(
//                           children: [
//                             Icon(Icons.tips_and_updates_outlined,
//                                 size: 30, color: Color(0xFF9dff3b)),
//                             SizedBox(width: 10),
//                             Text(
//                               'Your Personalized Tips',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF9dff3b),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Recommendations Content
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Text(
//                               suggestions,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Action Buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF9dff3b),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     textStyle: const TextStyle(fontSize: 18),
//                   ),
//                   child: const Text('Back to Form',
//                   style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecoveryRecommendationPage extends StatefulWidget {
  @override
  _RecoveryRecommendationPageState createState() => _RecoveryRecommendationPageState();
}

class _RecoveryRecommendationPageState extends State<RecoveryRecommendationPage> {
  double sleepHours = 7;
  double waterIntake = 2;
  double sorenessLevel = 3;
  int age = 25;
  double weight = 70;
  String suggestions = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sleepHours = prefs.getDouble('sleepHours') ?? 7;
      waterIntake = prefs.getDouble('waterIntake') ?? 2;
      sorenessLevel = prefs.getDouble('sorenessLevel') ?? 3;
      age = prefs.getInt('age') ?? 25;
      weight = prefs.getDouble('weight') ?? 70;
    });
    
    _generateSuggestions();
    
    setState(() {
      isLoading = false;
    });
  }

  void _generateSuggestions() {
    String newSuggestions = '';

    // Sleep recommendations based on age
    if (age >= 18 && age <= 64 && sleepHours < 7) {
      newSuggestions += '• Adults need 7-9 hours of sleep. Try to rest more.\n\n';
    } else if (age > 64 && sleepHours < 7) {
      newSuggestions += '• Older adults need 7-8 hours of sleep.\n\n';
    }

    // Water intake recommendations based on weight
    double recommendedWater = weight * 0.05; // Approx. 5 ml/kg
    if (waterIntake < recommendedWater) {
      newSuggestions +=
          '• Based on your weight, drink at least ${recommendedWater.toStringAsFixed(1)} liters of water daily.\n\n';
    }

    // Soreness recommendations
    if (sorenessLevel > 5) {
      newSuggestions += '• Take a rest day or try light stretching for recovery.\n\n';
    } else if (sorenessLevel >= 3 && sorenessLevel <= 5) {
      newSuggestions += '• Consider light activity and mobility exercises to aid recovery.\n\n';
    }
    
    // Additional general recommendations
    newSuggestions += '• Consider adding protein-rich foods to your diet for muscle recovery.\n\n';
    newSuggestions += '• Use foam rolling techniques to reduce muscle tension.\n\n';
    
    // Final suggestion if everything is fine with existing metrics
    if (sleepHours >= 7 && waterIntake >= recommendedWater && sorenessLevel < 3) {
      newSuggestions = '• You\'re on track with your recovery metrics! Keep it up!\n\n' + newSuggestions;
    }

    setState(() {
      suggestions = newSuggestions;
    });
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
            'Recovery Recommendations',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: accentMain))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Your Recovery Profile',
                                    style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.white24,
                              height: 40,
                            ),
                            _infoRow(
                              icon: Icons.cake_outlined,
                              title: 'Age',
                              value: '$age years',
                            ),
                            _infoRow(
                              icon: Icons.fitness_center_outlined,
                              title: 'Weight',
                              value: '$weight kg',
                            ),
                            _infoRow(
                              icon: Icons.nights_stay_outlined,
                              title: 'Sleep',
                              value: '$sleepHours hours',
                            ),
                            _infoRow(
                              icon: Icons.local_drink_outlined,
                              title: 'Water Intake',
                              value: '$waterIntake liters',
                            ),
                            _infoRow(
                              icon: Icons.accessibility_new_outlined,
                              title: 'Soreness Level',
                              value: '$sorenessLevel/10',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Recommendations Card
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
                                    Icons.tips_and_updates_outlined, 
                                    size: 35, 
                                    color: accentMain
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Your Recommendations',
                                    style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.white24,
                              height: 40,
                            ),
                            Text(
                              suggestions,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentMain,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              textStyle: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('Back to Form'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
  
  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
