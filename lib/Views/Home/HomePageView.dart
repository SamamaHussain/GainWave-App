import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class home_page_view extends StatefulWidget {
  const home_page_view({super.key});

  @override
  State<home_page_view> createState() => _home_page_viewState();
}

class _home_page_viewState extends State<home_page_view> {
  int totalWorkouts = 0;
  int totalVolume = 0;
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseServices = Provider.of<FirebaseServices>(context, listen: false);
      loadUserData(firebaseServices.uid!);
    });
  }

  Future<void> loadUserData(String userId) async {
    if (userId.isEmpty) return;
    
    try {
      setState(() {
        isDataLoading = true;
      });
      
      // Get today's date in the format used for doc IDs
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Reference to today's workouts
      final workoutsRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('dailyWorkoutData')
          .doc(today)
          .collection('workouts');
      
      // Get workout count
      final workoutsSnapshot = await workoutsRef.get();
      final workoutCount = workoutsSnapshot.docs.length;
      
      // Reference to today's volume
      final volumeRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('Weekly Muscle Volume')
          .doc(today);
      
      // Get volume
      final volumeSnapshot = await volumeRef.get();
      final volumeData = volumeSnapshot.data();
      final volume = volumeData != null ? volumeData['Volume'] ?? 0 : 0;
      
      setState(() {
        totalWorkouts = workoutCount;
        totalVolume = volume is int ? volume : int.tryParse(volume.toString()) ?? 0;
        isDataLoading = false;
      });
    } catch (e) {
      setState(() {
        isDataLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseServices = Provider.of<FirebaseServices>(context);
    // final screenSize = MediaQuery.of(context).size;
    final today = DateFormat('MMM d',).format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: firebaseServices.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Preparing your fitness journey...",
                      style: GoogleFonts.roboto(
                        color: accentMain,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(color: accentMain),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: primaryBG,
                    expandedHeight: 80,
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
                            // InkWell(
                            //   onTap: () async {
                            //     firebaseServices.sign_out();
                            //     Navigator.of(context).pushNamedAndRemoveUntil(
                            //       '/loginRoute',
                            //       (_) => false,
                            //     );
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       color: secondaryBG,
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     child: const Icon(
                            //       Icons.logout_rounded,
                            //       color: Colors.white70,
                            //       size: 22,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Main Content
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05, 
                      10,
                      MediaQuery.of(context).size.width * 0.05,
                      100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: accentMain,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: accentMain.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                              isDataLoading
                                  ? Center(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            "Loading your workout stats...",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: primaryBG.withOpacity(0.8),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height: 2,
                                            width: 120,
                                            child: LinearProgressIndicator(
                                              backgroundColor: primaryBG.withOpacity(0.3),
                                              valueColor: AlwaysStoppedAnimation<Color>(primaryBG),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    )
                                  :                               LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            _buildStatItem('Workouts', '$totalWorkouts'),
                                            _buildStatItem('Volume', '$totalVolume'),
                                            Expanded(child: _buildStatItem('Date', today)),
                                          ],
                                        );
                                      }
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
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Add Your Workout',
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
                        
                        // Feature Grid - Responsive
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = MediaQuery.of(context).size.width;
                            // Maintain 2 columns for most sizes, switch to 1 only for very small devices
                            final crossAxisCount = screenWidth < 300 ? 1 : 2;
                            // Adjust aspect ratio based on screen width for better fit
                            final childAspectRatio = screenWidth < 360 ? 1.0 : 
                                                     screenWidth < 400 ? 1.1 : 1.2;
                            
                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: childAspectRatio,
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
                                  'Workout Analysis',
                                  Icons.bar_chart_rounded,
                                  '/analysisRoute',
                                ),
                              ],
                            );
                          }
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
                        
                        // Recovery cards - Responsive (always in a row)
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
                            const SizedBox(width: 12),
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
          child: const Icon(Icons.add, size: 32, color: primaryBG),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    // Responsive text sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final double valueFontSize = screenWidth < 320 ? 16 : screenWidth < 360 ? 18 : 20;
    final double labelFontSize = screenWidth < 320 ? 12 : 14;
    
    return Container(
      width: screenWidth * 0.26, // Control width to prevent overflow
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w700,
                color: primaryBG,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w500,
                color: primaryBG.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, 
    String title, 
    IconData icon, 
    String route,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive text and icon sizing
    final double fontSize = screenWidth < 360 ? 14 : 16;
    final double iconSize = screenWidth < 360 ? 24 : 28;
    final double padding = screenWidth < 360 ? 10 : 16;
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: secondaryBG,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth < 360 ? 10 : 12),
              decoration: BoxDecoration(
                color: primaryBG,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: accentMain,
                size: iconSize,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive sizing
    final double fontSize = screenWidth < 360 ? 12 : 14;
    final double iconSize = screenWidth < 360 ? 20 : 24;
    final double cardHeight = screenWidth < 360 ? 100 : 120;
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(screenWidth < 360 ? 12 : 16),
        height: cardHeight,
        decoration: BoxDecoration(
          color: secondaryBG,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth < 360 ? 8 : 10),
              decoration: BoxDecoration(
                color: primaryBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: accentMain,
                size: iconSize,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
