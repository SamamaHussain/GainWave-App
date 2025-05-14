 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

void verifymessage(BuildContext content){
  showDialog(context: content, builder: (BuildContext context){
    return AlertDialog(
      title: const Text("Email Sent!"),
      content: const Text('A Link to verify your account is sent on your Email click that link to verify your email'),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text('OK'))
      ],
    );
  },
  );
 }

   void showSnackBar(BuildContext context,String message) { 
    final snackBar = SnackBar(
  content: Text(
    message,
    style: GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  backgroundColor: Colors.red,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  elevation: 6,
  action: SnackBarAction(
    label: 'OK',
    textColor: textMain,
    onPressed: () {
      // Your action here
    },
  ),
);

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }