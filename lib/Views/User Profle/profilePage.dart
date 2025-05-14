// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
// import 'package:gain_wave_app/utillities/colors.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch user data when the profile page loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final firebaseServices = Provider.of<FirebaseServices>(context, listen: false);
//       firebaseServices.getUserData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FirebaseServices>(
//       builder: (context, firebaseServices, child) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: primaryBG,
//             appBar: AppBar(
//               backgroundColor: primaryBG,
//               elevation: 0,
//               title: Text(
//                 'Profile',
//                 style: GoogleFonts.roboto(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               centerTitle: true,
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.logout_rounded, color: Colors.white),
//                   onPressed: () {
//                     _showLogoutConfirmation(context, firebaseServices);
//                   },
//                 ),
//               ],
//             ),
//             body: firebaseServices.isLoading
//                 ? const Center(child: CircularProgressIndicator(color: Colors.white))
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildProfileHeader(context, firebaseServices),
//                         const SizedBox(height: 30),
//                         _buildProfileInfo(context, firebaseServices),
//                         const SizedBox(height: 20),
//                         _buildAccountActions(context),
//                       ],
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildProfileHeader(BuildContext context, FirebaseServices firebaseServices) {
//     return Center(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               color: accentMain.withOpacity(0.3),
//               shape: BoxShape.circle,
//             ),
//             child: CircleAvatar(
//               radius: 50,
//               backgroundColor: const Color.fromARGB(255, 41, 61, 23),
//               child: Text(
//                 _getInitials(firebaseServices.FirstName, firebaseServices.LastName),
//                 style: GoogleFonts.roboto(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: accentMain,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             '${firebaseServices.FirstName ?? ''} ${firebaseServices.LastName ?? ''}',
//             style: GoogleFonts.roboto(
//               fontSize: 28,
//               fontWeight: FontWeight.w800,
//               color: accentMain,
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             firebaseServices.user?.email ?? '',
//             style: GoogleFonts.roboto(
//               fontSize: 16,
//               color: Colors.white70,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileInfo(BuildContext context, FirebaseServices firebaseServices) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       color: secondaryBG,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 41, 61, 23),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.person_outline_rounded, 
//                     size: 35, 
//                     color: accentMain
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Text(
//                   'Account Information',
//                   style: GoogleFonts.roboto(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(
//               color: Colors.white24,
//               height: 40,
//             ),
//             _infoRow(
//               icon: Icons.person_outline_rounded,
//               title: 'First Name',
//               value: firebaseServices.FirstName ?? 'Not set',
//             ),
//             _infoRow(
//               icon: Icons.person_outline_rounded,
//               title: 'Last Name',
//               value: firebaseServices.LastName ?? 'Not set',
//             ),
//             _infoRow(
//               icon: Icons.email_outlined,
//               title: 'Email',
//               value: firebaseServices.user?.email ?? 'Not set',
//             ),
//             _infoRow(
//               icon: Icons.verified_outlined,
//               title: 'Email Verified',
//               value: (firebaseServices.isEmailVerified ?? false) ? 'Yes' : 'No',
//             ),
//             _infoRow(
//               icon: Icons.calendar_today,
//               title: 'Member Since',
//               value: _formatDate(firebaseServices.user?.metadata.creationTime),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoRow({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.white70),
//           const SizedBox(width: 12),
//           Expanded(
//             flex: 2,
//             child: Text(
//               title,
//               style: GoogleFonts.roboto(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: GoogleFonts.roboto(
//                 fontSize: 16,
//                 color: Colors.white70,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAccountActions(BuildContext context) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       color: secondaryBG,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 41, 61, 23),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.settings_outlined, 
//                     size: 35, 
//                     color: accentMain
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Text(
//                   'Account Options',
//                   style: GoogleFonts.roboto(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(
//               color: Colors.white24,
//               height: 40,
//             ),
//             _actionTile(
//               context,
//               icon: Icons.edit_rounded,
//               title: 'Edit Profile',
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Edit profile functionality coming soon')),
//                 );
//               },
//             ),
//             const Divider(color: Colors.white12, height: 1),
//             _actionTile(
//               context,
//               icon: Icons.lock_outline_rounded,
//               title: 'Change Password',
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Change password functionality coming soon')),
//                 );
//               },
//             ),
//             const Divider(color: Colors.white12, height: 1),
//             _actionTile(
//               context,
//               icon: Icons.settings_outlined,
//               title: 'App Settings',
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Settings functionality coming soon')),
//                 );
//               },
//             ),
//             const Divider(color: Colors.white12, height: 1),
//             _actionTile(
//               context,
//               icon: Icons.help_outline_rounded,
//               title: 'Help & Support',
//               onTap: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Help & Support functionality coming soon')),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _actionTile(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: accentMain),
//       title: Text(
//         title,
//         style: GoogleFonts.roboto(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white70),
//       onTap: onTap,
//     );
//   }

//   void _showLogoutConfirmation(BuildContext context, FirebaseServices firebaseServices) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: secondaryBG,
//           title: Text(
//             'Logout',
//             style: GoogleFonts.roboto(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: GoogleFonts.roboto(color: Colors.white),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'CANCEL',
//                 style: GoogleFonts.roboto(color: Colors.white70),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 firebaseServices.sign_out();
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   '/loginRoute',
//                   (route) => false,
//                 );
//               },
//               child: Text(
//                 'LOGOUT',
//                 style: GoogleFonts.roboto(color: accentMain),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _getInitials(String? firstName, String? lastName) {
//     String initials = '';
//     if (firstName != null && firstName.isNotEmpty) {
//       initials += firstName[0].toUpperCase();
//     }
//     if (lastName != null && lastName.isNotEmpty) {
//       initials += lastName[0].toUpperCase();
//     }
//     return initials.isEmpty ? '?' : initials;
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Not available';
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

import 'package:flutter/material.dart';
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
          content: Text('Profile updated successfully'),
          backgroundColor: accentMain,
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
                  SliverAppBar(
                    backgroundColor: primaryBG,
                    expandedHeight: 80,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Profile',
                          style: GoogleFonts.roboto(
                            color: textMain,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
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
                          decoration: BoxDecoration(
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
                                  color: accentMain,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${firebaseServices.FirstName?[0] ?? ''}${firebaseServices.LastName?[0] ?? ''}',
                                    style: GoogleFonts.roboto(
                                      color: primaryBG,
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
                        
                        // Settings List
                        _buildSettingItem(
                          title: 'Privacy Settings',
                          icon: Icons.privacy_tip_rounded,
                          onTap: () {
                            // Navigate to privacy settings
                          },
                        ),
                        _buildSettingItem(
                          title: 'Notifications',
                          icon: Icons.notifications_rounded,
                          onTap: () {
                            // Navigate to notifications settings
                          },
                        ),
                        _buildSettingItem(
                          title: 'Help & Support',
                          icon: Icons.help_rounded,
                          onTap: () {
                            // Navigate to help & support
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: secondaryBG,
        borderRadius: BorderRadius.circular(12),
      ),
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
    );
  }
}