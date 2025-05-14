import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/main.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


    @override
  void dispose() {
    firebaseServices.EmailController.clear();
    firebaseServices.PasswordController.clear();
    firebaseServices.LastNameController.clear();
    firebaseServices.FirstNameController.clear();
    super.dispose();
  }

void showSnackBar(BuildContext context,String message) {
    final snackBar = SnackBar( 
      content: Text(message),
      backgroundColor: Colors.red, 
      action: SnackBarAction( 
        label: 'OK', 
        textColor: Colors.white, 
        onPressed: () {  

        },
         ), 
        ); 
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:const  Color(0xFF212121),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
            child: IntrinsicHeight(
              child: Padding(
                padding:const  EdgeInsets.fromLTRB(16, 30, 16, 30),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create your new \naccount',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -2,
                      ),
                      ),
                    const   SizedBox(height: 30),
                    Text('First Name',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                    const   SizedBox(height: 10),
                    TextField(
                      controller: firebaseServices.FirstNameController,
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    // borderSide: BorderSide(color: Colors.white),
                    // ),
                    enabledBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white, width: 1.0), borderRadius: BorderRadius.circular(12.0), ),
                    contentPadding:const  EdgeInsets.symmetric(vertical: 25.0,horizontal: 16),
                    hintText: 'John',
                    hintStyle: GoogleFonts.roboto(color:const  Color(0xFFC1C1C1),letterSpacing: -0.5,), 
                    filled: false,
                  ),
                    ),
                   const  SizedBox(height: 15),
                    Text('Last Name',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                     const  SizedBox(height: 10),
                    TextField(
                      controller: firebaseServices.LastNameController,
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    // borderSide: BorderSide(color: Colors.white),
                    // ),
                    enabledBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white, width: 1.0), borderRadius: BorderRadius.circular(12.0), ),
                    contentPadding:const  EdgeInsets.symmetric(vertical: 25.0,horizontal: 16),
                    hintText: 'Doel',
                    hintStyle: GoogleFonts.roboto(color:const  Color(0xFFC1C1C1),letterSpacing: -0.5,), 
                    filled: false,
                  ),
                    ),
                   const  SizedBox(height: 15),
                      Text('Email',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                     const   SizedBox(height: 10),
                    TextField(
                      controller: firebaseServices.EmailController,
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    // borderSide: BorderSide(color: Colors.white),
                    // ),
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                      ),
                    const   SizedBox(height: 10),
                    TextField(
                      controller: firebaseServices.PasswordController,
                      decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12.0), ),   
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    // borderSide: BorderSide(color: Colors.white),
                    // ),
                    enabledBorder: OutlineInputBorder( borderSide:const  BorderSide(color: Colors.white, width: 1.0), borderRadius: BorderRadius.circular(12.0), ),
                    contentPadding:const  EdgeInsets.symmetric(vertical: 25.0,horizontal: 16),
                    hintText: '*******',
                    hintStyle: GoogleFonts.roboto(color:const  Color(0xFFC1C1C1),letterSpacing: -0.5,), 
                    filled: false,
                  ),
                    ),
                   const  SizedBox(height: 25),
                    SizedBox( width: double.infinity, 
                    child: ElevatedButton( onPressed: () async{ 
                      if (firebaseServices.FirstNameController.text.isEmpty || firebaseServices.LastNameController.text.isEmpty || firebaseServices.EmailController.text.isEmpty || firebaseServices.PasswordController.text.isEmpty) {
                        showSnackBar(context, 'Fill all the fields!');
                      }
                      else{
                        firebaseServices.signup(context);
                      log('from press func: ${firebaseServices.uid}');
                      // firestoreFuncs.saveUser(firebaseServices.uid, FirstNameController.text, LastNameController.text, EmailController.text);
                      } 
                      }, 
                      style: ElevatedButton.styleFrom( padding:const  EdgeInsets.symmetric(vertical: 25.0), backgroundColor:const  Color(0xFF9dff3b), 
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12.0), ), ), 
                      child: Text( 'Sign up', 
                      
                      style:GoogleFonts.roboto(color: const Color(0xFF2a2a2a), fontSize: 17, fontWeight: FontWeight.w500,letterSpacing: -0.5,), ), ),),
                    Spacer(),
                    Center(
                      child: RichText( 
                        text: TextSpan( 
                        text: "Already have an account? ", 
                        style: GoogleFonts.roboto(
                          color:const  Color.fromARGB(255, 255, 255, 255),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                        children: [ 
                          TextSpan( text: 'Log in', 
                          style: GoogleFonts.roboto(
                          color:const  Color(0xFF9dff3b),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
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
          ),
                );
        }
        ),
        ),
    );
  }
}

