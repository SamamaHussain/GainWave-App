import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:gain_wave_app/utillities/widgets/CustomWidgets.dart';
import 'package:google_fonts/google_fonts.dart';


class email_verify extends StatefulWidget {
  const email_verify({super.key});

  @override
  State<email_verify> createState() => _email_verifyState();
}

class _email_verifyState extends State<email_verify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBG,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('Verify your email',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -2,
                ),
                ),
                SizedBox(height: 10),
                Text('Click the button below to get verification email.',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 17,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -0.5,
                ),
                ),
                SizedBox(height: 30),
                SizedBox( width: double.infinity, 
              child: ElevatedButton( onPressed: ()async { 
                  firebaseServices.sendEmail();
                  verifymessage(context);
                }, 
                style: ElevatedButton.styleFrom( padding: EdgeInsets.symmetric(vertical: 25.0), backgroundColor: Color(0xFF9dff3b), 
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12.0), ), ), 
                child: Text( 'Verify Email',
                
                style:GoogleFonts.roboto(color: secondaryBG, fontSize: 17, fontWeight: FontWeight.w500,letterSpacing: -0.5,), ), ),),
                Spacer(),
                Center(
                child: RichText( 
                  text: TextSpan( 
                  text: "Verified your email? ", 
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                  ),
                  children: [ 
                    TextSpan( text: 'Log in', 
                    style: GoogleFonts.roboto(
                    color: accentMain,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = ()async {
                    firebaseServices.GetCurrentUserID();
                  if(firebaseServices.user!=null){
                    firebaseServices.sign_out();
                  }
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
    );
  }
}

