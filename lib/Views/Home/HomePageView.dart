import 'package:flutter/material.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class home_page_view extends StatelessWidget {
  const home_page_view({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBG,
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
          child: Row(
            children: [
              Text(
                'Home',
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                  color: textMain,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -2,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    firebaseServices.sign_out();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/loginRoute',
                      (_) => false,
                    );
                  },
                  child: Icon(Icons.logout_rounded))
            ],
          ),
        ),
      ),
    );
  }
}
