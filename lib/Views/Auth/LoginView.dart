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
     final TextEditingController _emailController=TextEditingController();
    final TextEditingController _passwordController=TextEditingController();

@override
  void dispose() {
    // TODO: implement dispose
    _passwordController.clear();
    _passwordController.clear();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
       
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: LayoutBuilder(
          builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
            child: IntrinsicHeight(
              child: Padding(
                padding:const  EdgeInsets.fromLTRB(16, 30, 16, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Login to your \nGain Wave',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: textMain,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -2,
                      ),
                      ),
                      const SizedBox(height: 30),
                      Text('Email',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: textMain,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                     const  SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      style:const  TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    enabledBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white, width: 1.0), borderRadius: BorderRadius.circular(12.0), ),
                    contentPadding:const  EdgeInsets.symmetric(vertical: 25.0,horizontal: 12),
                    hintText: 'johndoel@mail.com',
                    hintStyle: GoogleFonts.roboto(color:const  Color(0xFFC1C1C1),letterSpacing: -0.5,), 
                    filled: false,
                  ),
                    ),
                   const  SizedBox(height: 15),
                    Text('Password',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: textMain,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                      
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      style:const  TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    enabledBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white, width: 1.0), borderRadius: BorderRadius.circular(12.0), ),
                    contentPadding:const  EdgeInsets.symmetric(vertical: 25.0,horizontal: 16),
                    hintText: '*******',
                    hintStyle: GoogleFonts.roboto(color:const  Color(0xFFC1C1C1),letterSpacing: -0.5,), 
                    filled: false,
                  ),
                    ),
                   const  SizedBox(height: 25),
                    SizedBox( width: double.infinity, 
                    //Login Button TODO
                    child: ElevatedButton( onPressed: () {
                      firebaseServices.login(_emailController.text,_passwordController.text,context);
                      //  if(firebaseServices.errorCodeLogin=='invalid-email'){
                      //   showSnackBar(context, 'Wrong email or password');
                      // }
                      log('From LoginButoon: ${firebaseServices.FirstName}');
              
                     
                      }, 
                      style: ElevatedButton.styleFrom( padding:const  EdgeInsets.symmetric(vertical: 25.0), backgroundColor:accentMain, 
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12.0), ), ), 
                      child: Text( 'Login', 
                      
                      style:GoogleFonts.roboto(color: secondaryBG, fontSize: 17, fontWeight: FontWeight.w500,letterSpacing: -0.5,), ), ),),
                    Spacer(),
                    Center(
                      child: RichText( 
                        text: TextSpan( 
                        text: "Don't have an account? ", 
                        style: GoogleFonts.roboto(
                          color: textMain,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                        children: [ 
                          TextSpan( text: 'Sign up', 
                          style: GoogleFonts.roboto(
                          color: accentMain,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
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
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pushNamedAndRemoveUntil('/registerRoute', (_) => false);
                    //   }, 
                    // child: const Text('Not Register Yet? Register Here!'))
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
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.clear();
//     _passwordController.clear();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // final screenSize = MediaQuery.of(context).size;
    
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
//                            Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // const SizedBox(height: 24),
//                               Text(
//                                 'Welcome to\nGain Wave',
//                                 style: GoogleFonts.roboto(
//                                   color: textMain,
//                                   fontSize: 36,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: -1,
//                                   height: 1.1,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Text(
//                                 'Login to continue your fitness journey',
//                                 style: GoogleFonts.roboto(
//                                   color: textMain.withOpacity(0.7),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
                        
//                         const SizedBox(height: 30),
                        
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
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: secondaryBG,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
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
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(color: accentMain, width: 1.5),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: secondaryBG, width: 1.0),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//                               hintText: 'johndoe@mail.com',
//                               hintStyle: GoogleFonts.roboto(
//                                 color: Colors.white.withOpacity(0.5),
//                                 letterSpacing: -0.5,
//                               ),
//                               filled: true,
//                               fillColor: secondaryBG,
//                             ),
//                           ),
//                         ),
                        
//                         const SizedBox(height: 20),
                        
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
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: secondaryBG,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
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
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                                   color: Colors.white.withOpacity(0.7),
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
//                                 borderSide: BorderSide(color: secondaryBG, width: 1.0),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//                               hintText: '••••••••',
//                               hintStyle: GoogleFonts.roboto(
//                                 color: Colors.white.withOpacity(0.5),
//                                 letterSpacing: -0.5,
//                               ),
//                               filled: true,
//                               fillColor: secondaryBG,
//                             ),
//                           ),
//                         ),
                        
//                         Container(
//                           margin: const EdgeInsets.only(top: 12, bottom: 30),
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               // Functionality can be added here
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
//                           // height: 50,
//                           width: double.infinity,
//                           child: ElevatedButton(
//                           onPressed: () {
//                             firebaseServices.login(_emailController.text,
//                                 _passwordController.text, context);
//                             log('From LoginButton: ${firebaseServices.FirstName}');
//                           },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 22.0),
//                               backgroundColor: accentMain,
//                               disabledBackgroundColor: accentMain.withOpacity(0.6),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               elevation: 2,
//                             ),
//                             child: _isLoading
//                                 ? const SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: CircularProgressIndicator(
//                                       color: primaryBG,
//                                       strokeWidth: 3,
//                                     ),
//                                   )
//                                 : Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         'Login',
//                                         style: GoogleFonts.roboto(
//                                           color: primaryBG,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
                                     
//                                     ],
//                                   ),
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