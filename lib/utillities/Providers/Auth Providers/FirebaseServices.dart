// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:gain_wave_app/main.dart';

class FirebaseServices extends ChangeNotifier {
  String? errorCodeLogin;
  String? errorCodeSignup;
  User? user;
  bool? isEmailVerified;
  UserCredential? userCredential;
  String? uid;
  String? FirstName;
  String? LastName;
  bool isLoading = true;

     final TextEditingController EmailController=TextEditingController();
   final TextEditingController PasswordController=TextEditingController();
   final TextEditingController FirstNameController=TextEditingController();
   final TextEditingController LastNameController=TextEditingController();

  void GetCurrentUserID() {
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    // if(userCredential!=null){
    //   uid=userCredential!.user!.uid;
    // }
     notifyListeners();
  }

  Future<void> getUserData() async {
    isLoading = true;
     notifyListeners();
      user= FirebaseAuth.instance.currentUser;
      uid=user?.uid;
      log('Uid from GetUserData: $uid');
    Map<String, String>? userData = await firestoreFuncs.getUser(uid);
    if (userData != null) {
      FirstName = userData['firstName'];
      log('getUserData: $FirstName');
      LastName = userData['lastName'];
       notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  void login(String email,String password,BuildContext Context) async {
    try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      user= FirebaseAuth.instance.currentUser;
      uid=user?.uid;
      log('From login Func: $uid');
      isEmailVerified = user!.emailVerified;
       notifyListeners();
      if(user!=null){
      if (isEmailVerified == true) {
        getUserData();
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
      log(e.code);
      if (e.code == 'invalid-email') {
        errorCodeLogin = e.code;
        log('Your Email is Invalid');
      } else if (e.code == 'invalid-credential') {
        errorCodeLogin = e.code;
        log('invalid-credential');
      } else if (e.code == 'wrong-password') {
        log('Incorrect Password');
      } else if (e.code == 'user-not-found') {
        log('This Email is Not registered');
      } else {
        log('Something Went Wrong');
      }
    }
  }

  void sign_out () async{
    await FirebaseAuth.instance.signOut();
  }

    Future<void> signup(BuildContext Context)async{
    try{
     userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: EmailController.text, 
      password: PasswordController.text,
      );
      if (userCredential?.user != null) {
   uid = userCredential!.user!.uid;
  log('User UID: $uid');
  firestoreFuncs.saveUser(uid, FirstNameController.text, LastNameController.text, EmailController.text);
} else {
  log('User creation failed.');
}
      Navigator.of(Context).pushNamed('/emailVerifyRoute');
    }
    on FirebaseAuthException catch(e){
      if (e.code == 'invalid-email') {
        errorCodeSignup ='invalid-email';
        log('Your Email is Invalid');
      }if (e.code == 'weak-password') {
    log('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    log('The account already exists for that email.');
  }
    }

  }


  void sendEmail () async{
    final user =FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }
}
