// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class FirebaseServices {
  String? errorCodeLogin;
  String? errorCodeSignup;
  User? user;
  bool? isEmailVerified;

  void GetCurrentUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  void login(String email,String password,BuildContext Context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      user = FirebaseAuth.instance.currentUser;
      isEmailVerified = user!.emailVerified;
      if(user!=null){
      if (isEmailVerified == true) {
      Navigator.of(Context).pushNamedAndRemoveUntil(
        '/homeRoute',
        (route) => false,
      );
    } else {
      Navigator.of(Context).pushNamedAndRemoveUntil(
        '/emailVerifyRoute',
        (_) => false,
      );
    }
}
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        errorCodeLogin = e.code;
        print('Your Email is Invalid');
      } else if (e.code == 'invalid-credential') {
        errorCodeLogin = e.code;
        print('invalid-credential');
      } else if (e.code == 'wrong-password') {
        print('Incorrect Password');
      } else if (e.code == 'user-not-found') {
        print('This Email is Not registered');
      } else {
        print('Something Went Wrong');
      }
    }
  }

  void sign_out () async{
    await FirebaseAuth.instance.signOut();
  }

    Future signup(String email,String password,BuildContext Context)async{
    try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: email,
      );
      Navigator.of(Context).pushNamed('/emailVerifyRoute');
    }
    on FirebaseAuthException catch(e){
      if (e.code == 'invalid-email') {
        errorCodeSignup ='invalid-email';
        print('Your Email is Invalid');
      }if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
    }

  }


  void sendEmail () async{
    final user =FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }
}
