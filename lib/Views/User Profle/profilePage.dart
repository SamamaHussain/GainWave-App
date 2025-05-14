
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/About%20&%20Support/aboutandSupport.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isEditingName = false;
  String? currentPlan = "No Plan Selected";
  String? planSaveDate;
  
  // Text controllers for editing
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseServices = Provider.of<FirebaseServices>(context, listen: false);
      _loadUserProfile(firebaseServices.uid!);
      
      // Initialize controllers with current values
      _firstNameController.text = firebaseServices.FirstName ?? '';
      _lastNameController.text = firebaseServices.LastName ?? '';
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile(String userId) async {
    if (userId.isEmpty) return;
    
    try {
      setState(() {
        isLoading = true;
      });
      
      // Get current selected plan
      final planSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('workout_plans')
          .doc('Saved Plan')
          .get();
      
      if (planSnapshot.exists) {
        final planData = planSnapshot.data();
        setState(() {
          currentPlan = planData?['plan_name'] ?? "No Plan Selected";
          
          // Format date if available
          if (planData?['date_saved'] != null) {
            final timestamp = planData!['date_saved'] as Timestamp;
            planSaveDate = DateFormat('MMM d, yyyy').format(timestamp.toDate());
          }
        });
      }
      
    } catch (e) {
      print('Error loading profile data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserName() async {
    final firebaseServices = Provider.of<FirebaseServices>(context, listen: false);
    if (firebaseServices.uid == null) return;
    
    setState(() {
      isLoading = true;
    });
    
    try {
      // Update in Firestore
      await FirebaseFirestore.instance.collection('user').doc(firebaseServices.uid).update({
        'FirstName': _firstNameController.text.trim(),
        'LastName': _lastNameController.text.trim(),
      });
      
      // Update in provider manually (instead of using refreshUserData)
      await _refreshUserDataLocally(firebaseServices);
      
      // Update UI
      setState(() {
        isEditingName = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!',
            style: GoogleFonts.roboto(
              color: accentMain,
              fontSize: 16,
            ),
          ),
          backgroundColor: secondaryBG,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  // Manual refresh function for FirebaseServices data
  Future<void> _refreshUserDataLocally(FirebaseServices firebaseServices) async {
    try {
      // Fetch updated user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseServices.uid)
          .get();
      
      if (userDoc.exists) {
        // Update provider data directly
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
        // Update the firebaseServices provider data through reflection
        // This works because Dart can access and modify fields dynamically
        firebaseServices.FirstName = userData['FirstName'];
        firebaseServices.LastName = userData['LastName'];
        
        // Manually notify listeners since we're updating the provider directly
        firebaseServices.notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user data locally: $e');
      // Handle error silently - no need to show another error
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseServices = Provider.of<FirebaseServices>(context);
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        appBar: AppBar(
          backgroundColor: primaryBG,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: firebaseServices.isLoading || isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Loading your profile...",
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
                  // Main Content
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      screenSize.width * 0.05, 
                      10,
                      screenSize.width * 0.05,
                      100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Profile Avatar and Name
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(border: Border.all(width: 1, color: accentMain),
                            color: secondaryBG,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Avatar Circle
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 29, 29, 29),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${firebaseServices.FirstName?[0] ?? ''}${firebaseServices.LastName?[0] ?? ''}',
                                    style: GoogleFonts.roboto(
                                      color: accentMain,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // User Name - Editable
                              isEditingName
                                  ? Column(
                                      children: [
                                        TextField(
                                          controller: _firstNameController,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'First Name',
                                            labelStyle: GoogleFonts.roboto(color: Colors.white70),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: accentMain),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: accentMain, width: 2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _lastNameController,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Last Name',
                                            labelStyle: GoogleFonts.roboto(color: Colors.white70),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: accentMain),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: accentMain, width: 2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: _updateUserName,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: accentMain,
                                                foregroundColor: primaryBG,
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text('Save'),
                                            ),
                                            const SizedBox(width: 16),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isEditingName = false;
                                                  // Reset to original values
                                                  _firstNameController.text = firebaseServices.FirstName ?? '';
                                                  _lastNameController.text = firebaseServices.LastName ?? '';
                                                });
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white70,
                                              ),
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${firebaseServices.FirstName ?? ''} ${firebaseServices.LastName ?? ''}',
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: accentMain, size: 20),
                                          onPressed: () {
                                            setState(() {
                                              isEditingName = true;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                              
                              const SizedBox(height: 8),
                              // User Email
                              Text(
                                firebaseServices.user?.email ?? '',
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Current Plan Section
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
                                    Icons.fitness_center_rounded,
                                    color: primaryBG,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Current Plan',
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
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentPlan ?? "No Plan Selected",
                                          style: GoogleFonts.roboto(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: primaryBG,
                                          ),
                                        ),
                                        if (planSaveDate != null)
                                          Text(
                                            'Selected on $planSaveDate',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: primaryBG.withOpacity(0.8),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/workoutPlanningRoute');
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryBG,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Change Workout Plan',
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
                        
                        // Settings & Options
                        Text(
                          'Account',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingItem(
                          title: 'About & Support',
                          icon: Icons.help_rounded,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, 
                              backgroundColor: Colors.transparent,
                              builder: (context) => const AboutSupportSheet(),
                            );
                          },
                        ),
                        _buildSettingItem(
                          title: 'Sign Out',
                          icon: Icons.logout_rounded,
                          isDestructive: true,
                          onTap: () async {
                            firebaseServices.sign_out();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/loginRoute',
                              (_) => false,
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive ? Colors.red.withOpacity(0.2) : primaryBG,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isDestructive ? Colors.red : accentMain,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.roboto(
              color: isDestructive ? Colors.red : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: Colors.white70,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}