import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';


// Import your app colors
import 'package:gain_wave_app/utillities/colors.dart';

class AboutSupportSheet extends StatelessWidget {
  const AboutSupportSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.65, // Initial height (65% of screen)
      minChildSize: 0.2, // Minimum height when collapsed
      maxChildSize: 0.9, // Maximum height when expanded
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: secondaryBG,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'About & Support',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: accentMain,
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // App Description
                    _buildAppSection(
                      context,
                      'GainWave',
                      _buildAppDescription(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Project Info
                    _buildSection(
                      context,
                      'Project',
                      Icons.school_rounded,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Type', 'Final Year Project (FYP)'),
                          _buildInfoRow('Department', 'Computer Science'),
                          _buildInfoRow('University', 'COMSATS University, Wah Campus'),
                          _buildInfoRow('Year', '2025'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Developers Info
                    _buildSection(
                      context,
                      'Developers',
                      Icons.people_alt_rounded,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDeveloperInfo(
                            'Samama Hussain',
                            'Developer',
                            'mailto:samama@example.com',
                          ),
                          const SizedBox(height: 16),
                          _buildDeveloperInfo(
                            'Muhammad Hassan',
                            'Developer',
                            'mailto:hassan@example.com',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // App Features
                    _buildSection(
                      context,
                      'Key Features',
                      Icons.stars_rounded,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFeatureItem('AI-powered workout recommendations'),
                          _buildFeatureItem('Mesocycle planning and tracking'),
                          _buildFeatureItem('Volume and progressive overload tracking'),
                          _buildFeatureItem('Recovery monitoring tools'),
                          _buildFeatureItem('Workout analytics and insights'),
                          _buildFeatureItem('Personalized workout plans'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Technical Info
                    _buildSection(
                      context,
                      'Technical Info',
                      Icons.code_rounded,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Version', '1.0.0'),
                          _buildInfoRow('Framework', 'Flutter'),
                          _buildInfoRow('Backend', 'Firebase'),
                          _buildInfoRow('Last Updated', DateFormat('MMM d, yyyy').format(DateTime.now())),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Support Section
                    _buildSection(
                      context,
                      'Support',
                      Icons.help_outline_rounded,
                      Column(
                        children: [
                          _buildSupportButton(
                            context,
                            'Report an Issue',
                            Icons.bug_report_rounded,
                            () => _launchURL('mailto:samamahussain23@gmail.com?subject=Issue%20Report'),
                          ),
                          const SizedBox(height: 12),
                          _buildSupportButton(
                            context,
                            'Suggest a Feature',
                            Icons.lightbulb_outline_rounded,
                            () => _launchURL('mailto:samamahussain23@gmail.com?subject=Feature%20Suggestion'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Credits & Acknowledgements
                    _buildSection(
                      context,
                      'Acknowledgements',
                      Icons.favorite_rounded,
                      Text(
                        'Special thanks to our project supervisor and all participants in user testing who helped shape this application.',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    // Copyright
                    Container(
                      margin: const EdgeInsets.only(top: 32, bottom: 16),
                      alignment: Alignment.center,
                      child: Text(
                        '© ${DateTime.now().year} GainWave - All Rights Reserved',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GainWave is a comprehensive hypertrophy-focused fitness application designed to optimize muscle building through scientific principles and intelligent tracking.',
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Built with a focus on progressive overload, recovery management, and volume optimization, GainWave provides all the essential tools needed to maximize muscle growth while minimizing injury risk and overtraining.',
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 14),
          height: 1,
          color: Colors.white12,
        ),
        content,
      ],
    );
  }


   Widget _buildAppSection(
    BuildContext context,
    String title,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 14),
          height: 1,
          color: Colors.white12,
        ),
        content,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo(String name, String role, String email) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              name.substring(0, 1),
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: accentMain,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                role,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: accentMain,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: primaryBG,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: accentMain,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
