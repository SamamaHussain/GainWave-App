import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Auth/AuthView.dart';
import 'package:gain_wave_app/Views/Auth/EmailVerificationView.dart';
import 'package:gain_wave_app/Views/Auth/LoginView.dart';
import 'package:gain_wave_app/Views/Auth/RegisterView.dart';
import 'package:gain_wave_app/PageControlNav.dart';
import 'package:gain_wave_app/Views/Muscle%20Volume/muscleVolume.dart';
import 'package:gain_wave_app/Views/Workout%20Planning/workoutPlanning.dart';
import 'package:gain_wave_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gain_wave_app/utillities/FirebaseServices/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/FirebaseServices/FirestoreFuncs.dart';
import 'package:provider/provider.dart';

    FirebaseServices firebaseServices= FirebaseServices();
    FirestoreFuncs firestoreFuncs= FirestoreFuncs();
void main() async {
  dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<FirebaseServices>(
        create: (context) => firebaseServices,
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GainWave App',
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: false,
      ),
      home: const auth_view(),
      
      routes: {
          '/loginRoute': (context) => const login_view(),
          '/registerRoute': (context) => const register_view(),
          '/homeRoute': (context) => const page_control_nav(),
          '/emailVerifyRoute': (context) => const email_verify(),
        },
    ),
    
    );
  }
}

