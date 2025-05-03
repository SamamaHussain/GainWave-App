import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:gain_wave_app/utillities/widgets/CustomWidgets.dart';
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
                      log(_emailController.text);
                      log(_passwordController.text);
                      log('From LoginButoon: ${firebaseServices.FirstName}');
              
                      if(firebaseServices.errorCodeLogin=='invalid-credential'){
                        showSnackBar(context, 'Wrong email or password');
                      }
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