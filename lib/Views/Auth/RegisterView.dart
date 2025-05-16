import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gain_wave_app/main.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscurePassword = true;

  @override
  void dispose() {
    firebaseServices.EmailController.clear();
    firebaseServices.PasswordController.clear();
    firebaseServices.LastNameController.clear();
    firebaseServices.FirstNameController.clear();
    firebaseServices.AgeController.clear();
    firebaseServices.HeightController.clear();
    firebaseServices.WeightController.clear();
    super.dispose();
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create your new\naccount',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Join Gain Wave and start your fitness journey',
                        style: GoogleFonts.roboto(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),


                      Text(
                        'First Name',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
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
                          controller: firebaseServices.FirstNameController,
                          style: const TextStyle(color: Colors.white),
                          // Only allow letters for first name
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            hintText: 'John',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color(0xFFC1C1C1),
                              letterSpacing: -0.5,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2a2a2a),
                            errorText: null,
                            helperText: 'Letters only',
                            helperStyle: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Last Name Field
                      Text(
                        'Last Name',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
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
                          controller: firebaseServices.LastNameController,
                          style: const TextStyle(color: Colors.white),
                          // Only allow letters for last name
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            hintText: 'Doe',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color(0xFFC1C1C1),
                              letterSpacing: -0.5,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF2a2a2a),
                            errorText: null,
                            helperText: 'Letters only',
                            helperStyle: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      Text(
                        'Email',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
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
                          controller: firebaseServices.EmailController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
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
                            fillColor: const Color(0xFF2a2a2a),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      Text(
                        'Password',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
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
                          controller: firebaseServices.PasswordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
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
                            fillColor: const Color(0xFF2a2a2a),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
  children: [
    // Age TextField
    
    Expanded(
      child: Container(
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
          controller: firebaseServices.AgeController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.cake_outlined,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: 'Age',
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFFC1C1C1),
              letterSpacing: -0.5,
            ),
            filled: true,
            fillColor: const Color(0xFF2a2a2a),
          ),
        ),
      ),
    ),
    const SizedBox(width: 12),

    // Height TextField
    Expanded(
      child: Container(
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
          controller: firebaseServices.HeightController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.height,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: 'Height (m)',
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFFC1C1C1),
              letterSpacing: -0.5,
            ),
            filled: true,
            fillColor: const Color(0xFF2a2a2a),
          ),
        ),
      ),
    ),
    const SizedBox(width: 12),

    // Weight TextField
    Expanded(
      child: Container(
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
          controller: firebaseServices.WeightController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.monitor_weight_outlined,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF9dff3b), width: 1.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            hintText: 'Weight (kg)',
            hintStyle: GoogleFonts.roboto(
              color: const Color(0xFFC1C1C1),
              letterSpacing: -0.5,
            ),
            filled: true,
            fillColor: const Color(0xFF2a2a2a),
          ),
        ),
      ),
    ),
  ],
),

                      const SizedBox(height: 32),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (firebaseServices.FirstNameController.text.isEmpty ||
                                firebaseServices.LastNameController.text.isEmpty ||
                                firebaseServices.EmailController.text.isEmpty ||
                                firebaseServices.PasswordController.text.isEmpty
                                || firebaseServices.AgeController.text.isEmpty ||
                                firebaseServices.HeightController.text.isEmpty ||
                                firebaseServices.WeightController.text.isEmpty) {
                              showSnackBar(context, 'Fill all the fields!');
                            } else if (firebaseServices.AgeController.text.isEmpty ||
                                   int.tryParse(firebaseServices.AgeController.text) == null ||
                                   int.parse(firebaseServices.AgeController.text) < 15) {
                              showSnackBar(context, 'Age must be at least 15 years');
                            } else if (firebaseServices.HeightController.text.isEmpty ||
                                   double.tryParse(firebaseServices.HeightController.text) == null ||
                                   double.parse(firebaseServices.HeightController.text) < 1.4) {
                              showSnackBar(context, 'Height must be at least 1.4 meters');
                            } else if (firebaseServices.WeightController.text.isEmpty ||
                                   double.tryParse(firebaseServices.WeightController.text) == null ||
                                   double.parse(firebaseServices.WeightController.text) < 30) {
                              showSnackBar(context, 'Weight must be at least 30 kg');
                            } else {
                              firebaseServices.signup(context);
                              log('from press func: ${firebaseServices.uid}');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            backgroundColor: const Color(0xFF9dff3b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign up',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF2a2a2a),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Login link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Log in',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF9dff3b),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamedAndRemoveUntil('/loginRoute', (_) => false);
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
        }),
      ),
    );
  }
}



