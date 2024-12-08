 import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gain_wave_app/utillities/colors.dart';

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
      content: Text(message),
      backgroundColor: Colors.red, 
      action: SnackBarAction( 
        label: 'OK', 
        textColor: textMain, 
        onPressed: () {  

        },
         ), 
        ); 
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }