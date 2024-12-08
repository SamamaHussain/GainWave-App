import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Auth/LoginView.dart';
import 'package:gain_wave_app/PageControlNav.dart';

class auth_view extends StatelessWidget {
  const auth_view({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
          return const page_control_nav();
          }
          else{
            return login_view();
          //  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
          }
        },
      ); 
  }
}