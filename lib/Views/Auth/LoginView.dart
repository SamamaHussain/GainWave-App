// import 'dart:developer';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:gain_wave_app/main.dart';
// import 'package:gain_wave_app/utillities/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: primaryBG,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header
//                         Text(
//                           'Login to your\nGain Wave',
//                           style: GoogleFonts.roboto(
//                             color: textMain,
//                             fontSize: 36,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: -1.5,
//                             height: 1.1,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Welcome back to your fitness journey',
//                           style: GoogleFonts.roboto(
//                             color: textMain.withOpacity(0.7),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
                        
//                         // Email Field
//                         Text(
//                           'Email',
//                           style: GoogleFonts.roboto(
//                             color: textMain,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _emailController,
//                             style: const TextStyle(color: Colors.white),
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.email_outlined,
//                                 color: textMain.withOpacity(0.7),
//                                 size: 20,
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(color: accentMain, width: 1.5),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                               hintText: 'johndoe@mail.com',
//                               hintStyle: GoogleFonts.roboto(
//                                 color: const Color(0xFFC1C1C1),
//                                 letterSpacing: -0.5,
//                               ),
//                               filled: true,
//                               fillColor: secondaryBG,
//                             ),
//                           ),
//                         ),
                        
//                         const SizedBox(height: 24),
                        
//                         // Password Field
//                         Text(
//                           'Password',
//                           style: GoogleFonts.roboto(
//                             color: textMain,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _passwordController,
//                             style: const TextStyle(color: Colors.white),
//                             obscureText: _obscurePassword,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.lock_outline,
//                                 color: textMain.withOpacity(0.7),
//                                 size: 20,
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                                   color: textMain.withOpacity(0.7),
//                                   size: 20,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(color: accentMain, width: 1.5),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                               hintText: '••••••••',
//                               hintStyle: GoogleFonts.roboto(
//                                 color: const Color(0xFFC1C1C1),
//                                 letterSpacing: -0.5,
//                               ),
//                               filled: true,
//                               fillColor: secondaryBG,
//                             ),
//                           ),
//                         ),
                        
//                         // Forgot Password
//                         Container(
//                           margin: const EdgeInsets.only(top: 12, bottom: 32),
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               // Functionality can be added later
//                             },
//                             child: Text(
//                               'Forgot Password?',
//                               style: GoogleFonts.roboto(
//                                 color: accentMain,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
                        
//                         // Login Button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               firebaseServices.login(_emailController.text, _passwordController.text, context);
//                               log('From LoginButton: ${firebaseServices.FirstName}');
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 18.0),
//                               backgroundColor: accentMain,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               elevation: 4,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Login',
//                                   style: GoogleFonts.roboto(
//                                     color: primaryBG,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                        
//                         const Spacer(),
                        
//                         // Sign up link
//                         Center(
//                           child: RichText(
//                             text: TextSpan(
//                               text: "Don't have an account? ",
//                               style: GoogleFonts.roboto(
//                                 color: textMain.withOpacity(0.8),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: 'Sign up',
//                                   style: GoogleFonts.roboto(
//                                     color: accentMain,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       Navigator.of(context).pushNamedAndRemoveUntil('/registerRoute', (_) => false);
//                                     }
//                                 ),
//                               ]
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//         ),
//       ),
//     );
//   }
// }


import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isResettingPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // Handle password reset functionality
  void _handleForgotPassword() {
    if (_emailController.text.isEmpty) {
      _showResetDialog(
        "Please enter your email address in the email field above.",
        isError: true
      );
      return;
    }
    
    setState(() {
      _isResettingPassword = true;
    });

    // Send password reset email using Firebase
    firebaseServices.resetPassword(_emailController.text).then((_) {
      setState(() {
        _isResettingPassword = false;
      });
      
      _showResetDialog(
        "Password reset email sent! Please check your inbox and follow the instructions.",
        isError: false
      );
    }).catchError((error) {
      setState(() {
        _isResettingPassword = false;
      });
      
      _showResetDialog(
        "Failed to send reset email. Please verify your email address and try again.",
        isError: true
      );
    });
  }
  
  // Show password reset dialog
  void _showResetDialog(String message, {required bool isError}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          isError ? "Reset Failed" : "Reset Email Sent",
          style: GoogleFonts.roboto(
            color: isError ? Colors.red : accentMain,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.roboto(
            color: textMain,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: GoogleFonts.roboto(
                color: accentMain,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'Login to your\nGain Wave',
                          style: GoogleFonts.roboto(
                            color: textMain,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.5,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome back to your fitness journey',
                          style: GoogleFonts.roboto(
                            color: textMain.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Email Field
                        Text(
                          'Email',
                          style: GoogleFonts.roboto(
                            color: textMain,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: textMain.withOpacity(0.7),
                                size: 20,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: accentMain, width: 1.5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              hintText: 'johndoe@mail.com',
                              hintStyle: GoogleFonts.roboto(
                                color: const Color(0xFFC1C1C1),
                                letterSpacing: -0.5,
                              ),
                              filled: true,
                              fillColor: secondaryBG,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Password Field
                        Text(
                          'Password',
                          style: GoogleFonts.roboto(
                            color: textMain,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: textMain.withOpacity(0.7),
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: textMain.withOpacity(0.7),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: accentMain, width: 1.5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              hintText: '••••••••',
                              hintStyle: GoogleFonts.roboto(
                                color: const Color(0xFFC1C1C1),
                                letterSpacing: -0.5,
                              ),
                              filled: true,
                              fillColor: secondaryBG,
                            ),
                          ),
                        ),
                        
                        // Forgot Password
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 32),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _isResettingPassword ? null : _handleForgotPassword,
                            child: _isResettingPassword 
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: accentMain,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.roboto(
                                    color: accentMain,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          ),
                        ),
                        
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              firebaseServices.login(_emailController.text, _passwordController.text, context);
                              log('From LoginButton: ${firebaseServices.FirstName}');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                              backgroundColor: accentMain,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: GoogleFonts.roboto(
                                    color: primaryBG,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Sign up link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.roboto(
                                color: textMain.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: GoogleFonts.roboto(
                                    color: accentMain,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamedAndRemoveUntil('/registerRoute', (_) => false);
                                    }
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}