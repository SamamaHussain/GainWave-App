import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/FirebaseServices/FirebaseServices.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _showLogoutConfirmation(context, firebaseServices);
                },
              ),
            ],
          ),
          body: firebaseServices.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context, firebaseServices),
                      const SizedBox(height: 24),
                      _buildProfileInfo(firebaseServices),
                      const SizedBox(height: 24),
                      _buildAccountActions(context),
                    ],
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
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Text(
              _getInitials(firebaseServices.FirstName, firebaseServices.LastName),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${firebaseServices.FirstName ?? ''} ${firebaseServices.LastName ?? ''}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            firebaseServices.user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(FirebaseServices firebaseServices) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _infoRow(
              icon: Icons.person_outline,
              title: 'First Name',
              value: firebaseServices.FirstName ?? 'Not set',
            ),
            _infoRow(
              icon: Icons.person_outline,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _actionTile(
            context,
            icon: Icons.edit,
            title: 'Edit Profile',
            onTap: () {
              // Navigate to edit profile page
              // Navigator.of(context).pushNamed('/editProfileRoute');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile functionality coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _actionTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // Navigate to change password page
              // Navigator.of(context).pushNamed('/changePasswordRoute');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change password functionality coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _actionTile(
            context,
            icon: Icons.settings_outlined,
            title: 'App Settings',
            onTap: () {
              // Navigate to settings page
              // Navigator.of(context).pushNamed('/settingsRoute');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings functionality coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _actionTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help page
              // Navigator.of(context).pushNamed('/helpRoute');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support functionality coming soon')),
              );
            },
          ),
        ],
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
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context, FirebaseServices firebaseServices) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                firebaseServices.sign_out();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/loginRoute',
                  (route) => false,
                );
              },
              child: const Text('LOGOUT'),
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