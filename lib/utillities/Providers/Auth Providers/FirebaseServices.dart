// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/widgets/CustomWidgets.dart';

class FirebaseServices extends ChangeNotifier {
  String? errorCodeLogin;
  String? errorCodeSignup;
  User? user;
  bool? isEmailVerified;
  UserCredential? userCredential;
  String? uid;
  String? FirstName;
  String? LastName;
  String? Age;
  String? Height;
  String? Weight;
  bool isLoading = true;

  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController FirstNameController = TextEditingController();
  final TextEditingController LastNameController = TextEditingController();
  final TextEditingController AgeController = TextEditingController();
  final TextEditingController HeightController = TextEditingController();
  final TextEditingController WeightController = TextEditingController();

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
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    log('Uid from GetUserData: $uid');
    Map<String, String>? userData = await firestoreFuncs.getUser(uid);
    if (userData != null) {
      FirstName = userData['firstName'];
      log('getUserData: $FirstName');
      LastName = userData['lastName'];
      log('getUserData: $FirstName');
      Age = userData['Age'];
      log('getUserData: $Age');
      Height = userData['height'];
      log('getUserData: $Height');
      Weight = userData['weight'];
      log('getUserData: $Weight');

      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  void login(String email, String password, BuildContext Context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = FirebaseAuth.instance.currentUser;
      uid = user?.uid;
      log('From login Func: $uid');
      isEmailVerified = user!.emailVerified;
      notifyListeners();
      if (user != null) {
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
        showSnackBar(Context, 'The email address is invalid');
      }
      if (e.code == 'invalid-credential') {
        showSnackBar(Context, 'Wrong email or password');
      }
      if (e.code == 'wrong-password') {
        showSnackBar(Context, 'Wrong password');
      }
      if (e.code == 'user-not-found') {
        showSnackBar(Context, 'This Email is Not registered');
      }
      if (e.code == 'user-disabled') {
        showSnackBar(Context, 'This account has been disabled');
      } 
      // else {
      //   showSnackBar(Context, 'Something Went Wrong');
      // }
    }
    notifyListeners();
  }

  void sign_out() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signup(BuildContext Context) async {
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: EmailController.text,
        password: PasswordController.text,
      );
      if (userCredential?.user != null) {
        uid = userCredential!.user!.uid;
        log('User UID: $uid');
        firestoreFuncs.saveUser(uid, FirstNameController.text,
            LastNameController.text, EmailController.text,AgeController.text, HeightController.text, WeightController.text);
      } else {
        log('User creation failed.');
      }
      Navigator.of(Context).pushNamedAndRemoveUntil('/emailVerifyRoute',(route) => false,);
    } on FirebaseAuthException catch (e) {
       if (e.code == 'invalid-email') {
        showSnackBar(Context, 'The email address is invalid');
      }
       if (e.code == 'weak-password') {
        showSnackBar(Context, 'Password is too weak');
      }
       if (e.code == 'email-already-in-use') {
        showSnackBar(Context, 'This email is already in use');
      }
    }
  }

  void sendEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  Future<void> refreshUserData() async {
  try {
    // Show loading state
    // _isLoading = true;
    notifyListeners();
    
    // Fetch updated user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get();
    
    if (userDoc.exists) {
      // Update local variables with fresh data
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      // Update user information
      FirstName = userData['FirstName'];
      LastName = userData['LastName'];
      
      // Update any other user fields you're storing
      // Example: userWeight = userData['Weight'];
      // Example: userHeight = userData['Height'];
    }
  } catch (e) {
    print('Error refreshing user data: $e');
  } finally {
    // End loading state
    // _isLoading = false;
    notifyListeners();
  }
}


Future<void> resetPassword(String email) async {
  if (email.isEmpty) {
    throw Exception('Email is empty');
  }
  
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

}
}
