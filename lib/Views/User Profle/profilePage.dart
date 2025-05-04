import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the profile page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseServices = Provider.of<FirebaseServices>(context, listen: false);
      firebaseServices.getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseServices>(
      builder: (context, firebaseServices, child) {
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: () {
                    _showLogoutConfirmation(context, firebaseServices);
                  },
                ),
              ],
            ),
            body: firebaseServices.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileHeader(context, firebaseServices),
                        const SizedBox(height: 30),
                        _buildProfileInfo(context, firebaseServices),
                        const SizedBox(height: 20),
                        _buildAccountActions(context),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, FirebaseServices firebaseServices) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: accentMain.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 41, 61, 23),
              child: Text(
                _getInitials(firebaseServices.FirstName, firebaseServices.LastName),
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: accentMain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${firebaseServices.FirstName ?? ''} ${firebaseServices.LastName ?? ''}',
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: accentMain,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            firebaseServices.user?.email ?? '',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, FirebaseServices firebaseServices) {
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
                    Icons.person_outline_rounded, 
                    size: 35, 
                    color: accentMain
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Account Information',
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
            _infoRow(
              icon: Icons.person_outline_rounded,
              title: 'First Name',
              value: firebaseServices.FirstName ?? 'Not set',
            ),
            _infoRow(
              icon: Icons.person_outline_rounded,
              title: 'Last Name',
              value: firebaseServices.LastName ?? 'Not set',
            ),
            _infoRow(
              icon: Icons.email_outlined,
              title: 'Email',
              value: firebaseServices.user?.email ?? 'Not set',
            ),
            _infoRow(
              icon: Icons.verified_outlined,
              title: 'Email Verified',
              value: (firebaseServices.isEmailVerified ?? false) ? 'Yes' : 'No',
            ),
            _infoRow(
              icon: Icons.calendar_today,
              title: 'Member Since',
              value: _formatDate(firebaseServices.user?.metadata.creationTime),
            ),
          ],
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

  Widget _buildAccountActions(BuildContext context) {
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
                    Icons.settings_outlined, 
                    size: 35, 
                    color: accentMain
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Account Options',
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
            _actionTile(
              context,
              icon: Icons.edit_rounded,
              title: 'Edit Profile',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile functionality coming soon')),
                );
              },
            ),
            const Divider(color: Colors.white12, height: 1),
            _actionTile(
              context,
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password functionality coming soon')),
                );
              },
            ),
            const Divider(color: Colors.white12, height: 1),
            _actionTile(
              context,
              icon: Icons.settings_outlined,
              title: 'App Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings functionality coming soon')),
                );
              },
            ),
            const Divider(color: Colors.white12, height: 1),
            _actionTile(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support functionality coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: accentMain),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white70),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context, FirebaseServices firebaseServices) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryBG,
          title: Text(
            'Logout',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                firebaseServices.sign_out();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/loginRoute',
                  (route) => false,
                );
              },
              child: Text(
                'LOGOUT',
                style: GoogleFonts.roboto(color: accentMain),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String? firstName, String? lastName) {
    String initials = '';
    if (firstName != null && firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName != null && lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }
    return initials.isEmpty ? '?' : initials;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not available';
    return '${date.day}/${date.month}/${date.year}';
  }
}