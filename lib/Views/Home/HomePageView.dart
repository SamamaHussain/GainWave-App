import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:gain_wave_app/utillities/widgets/AnimatedCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class home_page_view extends StatefulWidget {
  const home_page_view({super.key});

  @override
  State<home_page_view> createState() => _home_page_viewState();
}

class _home_page_viewState extends State<home_page_view> {
  @override
  Widget build(BuildContext context) {
    final firebaseServices = Provider.of<FirebaseServices>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: firebaseServices.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Hello ${firebaseServices.FirstName}!',
                            style: GoogleFonts.roboto(
                              color: accentMain,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            firebaseServices.sign_out();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/loginRoute',
                              (_) => false,
                            );
                          },
                          icon: const Icon(Icons.logout_rounded,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const JumpingMotivationCard(),
                    const SizedBox(height: 10),
                    // Your Card
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pushNamed(context, '/workoutPlanningRoute');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        color: secondaryBG,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              20), // Padding inside the Card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                        Icons.fitness_center_rounded,
                                        size: 35,
                                        color: accentMain),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Customize Your Workout',
                                          style: GoogleFonts.roboto(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Plan your workouts the way you want.',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pushNamed(context, '/analysisRoute');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        color: secondaryBG,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              20), // Padding inside the Card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                        Icons.fitness_center_rounded,
                                        size: 35,
                                        color: accentMain),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Plan Your Mesocycle',
                                          style: GoogleFonts.roboto(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Create and plan your own training blocks.',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pushNamed(context, '/recommendarRoute');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        color: secondaryBG,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              20), // Padding inside the Card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                                        Icons.fitness_center_rounded,
                                        size: 35,
                                        color: accentMain),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'AI-Powered Fitness Coaching',
                                          style: GoogleFonts.roboto(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Transform Your Body with AI-Driven Fitness Plans.',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dailyWorkoutRoute');
          },
          shape: CircleBorder(),
          backgroundColor: accentMain,
          child: const Icon(Icons.track_changes, size: 30, color: secondaryBG),
        ),
      ),
    );
  }
}
