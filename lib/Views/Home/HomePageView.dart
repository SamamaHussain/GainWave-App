// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
// import 'package:gain_wave_app/utillities/colors.dart';
// import 'package:gain_wave_app/utillities/widgets/AnimatedCard.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class home_page_view extends StatefulWidget {
//   const home_page_view({super.key});

//   @override
//   State<home_page_view> createState() => _home_page_viewState();
// }

// class _home_page_viewState extends State<home_page_view> {
//   @override
//   Widget build(BuildContext context) {
//     final firebaseServices = Provider.of<FirebaseServices>(context);

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: primaryBG,
//         body: firebaseServices.isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               )
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'Hello ${firebaseServices.FirstName}!',
//                             style: GoogleFonts.roboto(
//                               color: accentMain,
//                               fontSize: 36,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -1,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             firebaseServices.sign_out();
//                             Navigator.of(context).pushNamedAndRemoveUntil(
//                               '/loginRoute',
//                               (_) => false,
//                             );
//                           },
//                           icon: const Icon(Icons.logout_rounded,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     const JumpingMotivationCard(),
//                     const SizedBox(height: 10),
//                     // Your Card
//                     InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () {
//                         Navigator.pushNamed(context, '/workoutPlanningRoute');
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 6,
//                         color: secondaryBG,
//                         child: Padding(
//                           padding: const EdgeInsets.all(
//                               20), // Padding inside the Card
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 41, 61, 23),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                         Icons.fitness_center_rounded,
//                                         size: 35,
//                                         color: accentMain),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Customize Your Workout',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           'Plan your workouts the way you want.',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 16,
//                                             color: Colors.white70,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () {
//                         Navigator.pushNamed(context, '/analysisRoute');
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 6,
//                         color: secondaryBG,
//                         child: Padding(
//                           padding: const EdgeInsets.all(
//                               20), // Padding inside the Card
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 41, 61, 23),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                         Icons.fitness_center_rounded,
//                                         size: 35,
//                                         color: accentMain),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Plan Your Mesocycle',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           'Create and plan your own training blocks.',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 16,
//                                             color: Colors.white70,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () {
//                         Navigator.pushNamed(context, '/recommendarRoute');
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 6,
//                         color: secondaryBG,
//                         child: Padding(
//                           padding: const EdgeInsets.all(
//                               20), // Padding inside the Card
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 41, 61, 23),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                         Icons.fitness_center_rounded,
//                                         size: 35,
//                                         color: accentMain),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'AI-Powered Fitness Coaching',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           'Transform Your Body with AI-Driven Fitness Plans.',
//                                           style: GoogleFonts.roboto(
//                                             fontSize: 16,
//                                             color: Colors.white70,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/dailyWorkoutRoute');
//           },
//           shape: CircleBorder(),
//           backgroundColor: accentMain,
//           child: const Icon(Icons.track_changes, size: 30, color: secondaryBG),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/colors.dart';
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
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: firebaseServices.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: accentMain),
              )
            : CustomScrollView(
                slivers: [
                  // App Bar with User Greeting and Logout
                  SliverAppBar(
                    backgroundColor: primaryBG,
                    expandedHeight: 120,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${firebaseServices.FirstName}',
                                  style: GoogleFonts.roboto(
                                    color: accentMain,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                firebaseServices.sign_out();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/loginRoute',
                                  (_) => false,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: secondaryBG,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white70,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Main Content
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Daily Stats Card
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentMain.withOpacity(0.8),
                                accentMain.withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.insights_rounded,
                                    color: primaryBG,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Today\'s Progress',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: primaryBG,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('Workouts', '0/1'),
                                  _buildStatItem('Calories', '0 kcal'),
                                  _buildStatItem('Recovery', '85%'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/dailyWorkoutRoute');
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryBG,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Start Today\'s Workout',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: accentMain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Section Title
                        Text(
                          'Training',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Feature Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                          children: [
                            _buildFeatureCard(
                              context,
                              'Workout Planner',
                              Icons.fitness_center_rounded,
                              '/workoutPlanningRoute',
                            ),
                            _buildFeatureCard(
                              context,
                              'Mesocycle Tracker',
                              Icons.calendar_month_rounded,
                              '/mesocycleRoute',
                            ),
                            _buildFeatureCard(
                              context,
                              'AI Coach',
                              Icons.smart_toy_rounded,
                              '/recommendarRoute',
                            ),
                            _buildFeatureCard(
                              context,
                              'Analysis',
                              Icons.bar_chart_rounded,
                              '/analysisRoute',
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Section Title
                        Text(
                          'Recovery',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Recovery cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildRecoveryCard(
                                context,
                                'Recovery Form',
                                Icons.favorite_rounded,
                                '/recoveryFormRoute',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildRecoveryCard(
                                context,
                                'Feedback',
                                Icons.rate_review_rounded,
                                '/workoutFeedbackRoute',
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dailyWorkoutRoute');
          },
          elevation: 4,
          backgroundColor: accentMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.play_arrow_rounded, size: 32, color: primaryBG),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: primaryBG,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryBG.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, 
    String title, 
    IconData icon, 
    String route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondaryBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBG,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: accentMain,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryCard(
    BuildContext context, 
    String title, 
    IconData icon, 
    String route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        decoration: BoxDecoration(
          color: secondaryBG,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: accentMain,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
