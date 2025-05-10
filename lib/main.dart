import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/Analysis%20and%20Reporting/workoutAnylsisScreen.dart';
import 'package:gain_wave_app/Views/Auth/AuthView.dart';
import 'package:gain_wave_app/Views/Auth/EmailVerificationView.dart';
import 'package:gain_wave_app/Views/Auth/LoginView.dart';
import 'package:gain_wave_app/Views/Auth/RegisterView.dart';
import 'package:gain_wave_app/PageControlNav.dart';
import 'package:gain_wave_app/Views/Daiy%20Workout/dailyWorkoutScreen.dart';
import 'package:gain_wave_app/Views/Daiy%20Workout/workoutDetailScreen.dart';
import 'package:gain_wave_app/Views/Feedback%20and%20Adjustment/feedbackScreen.dart';
import 'package:gain_wave_app/Views/Mesocycle/mesocycle.dart';
import 'package:gain_wave_app/Views/Recommendation/exerciseRecommender.dart';
import 'package:gain_wave_app/Views/Recovery/recoveryFormpage.dart';
import 'package:gain_wave_app/Views/Workout%20Planning/plannerScreen.dart';
import 'package:gain_wave_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirebaseServices.dart';
import 'package:gain_wave_app/utillities/Providers/Auth%20Providers/FirestoreFuncs.dart';
import 'package:provider/provider.dart';

    FirebaseServices firebaseServices= FirebaseServices();
    FirestoreFuncs firestoreFuncs= FirestoreFuncs();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home:    auth_view(),
      
      routes: {
          '/loginRoute': (context) => const LoginView(),
          '/registerRoute': (context) => const RegisterView(),
          '/homeRoute': (context) => const PageNavController(),
          '/emailVerifyRoute': (context) => const email_verify(),
          '/workoutPlanningRoute': (context) => const WorkoutPlannerScreen(),
          '/mesocycleRoute': (context) => const MesocycleTracker(),
          '/recommendarRoute': (context) => const ExerciseRecommendation(),
          '/dailyWorkoutRoute': (context) => const DailyWorkoutScreen(),
          '/analysisRoute': (context) => const WorkoutAnalysisScreen(),
          '/recoveryFormRoute': (context) => RecoveryFormPage(),
          '/workoutFeedbackRoute': (context) => const WorkoutFeedbackScreen(),
          '/WorkoutDetailRoute': (context) => const WorkoutDetailScreen(),
        },
    ),
    
    );
  }
}

