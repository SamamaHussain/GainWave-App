import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/Views/ChatApp/ChatAppView.dart';
import 'package:gain_wave_app/Views/Home/HomePageView.dart';
import 'package:gain_wave_app/Views/Performance/UI/exerciseLibraryPage.dart';
import 'package:gain_wave_app/Views/User%20Profle/profilePage.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PageNavController extends StatefulWidget {
  const PageNavController({super.key});
  @override
  State<PageNavController> createState() => _PageNavControllerState();
}

class _PageNavControllerState extends State<PageNavController> {
  var index = 0;

  final totalScreens = const [
    home_page_view(),
    // ExerciseLibraryPage(),
    ExerciseLibraryPage(),
    GymChatBot(),
    ProfilePage(),
  ];

    _getUserData(){
     firebaseServices.getUserData();
    setState(() {
      log('From NavControl: ${firebaseServices.FirstName}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    super.initState();
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBG,
      body: totalScreens[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                constraints:const BoxConstraints.tightFor(height: 80),
                decoration: const BoxDecoration(
                  color: secondaryBG,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: GNav(
                      selectedIndex: index,
                      onTabChange: (value) {
                        setState(() {
                          index = value;
                        });
                        log('$index');
                      },
                      tabActiveBorder: Border.all(color: accentMain),
                      backgroundColor: secondaryBG,
                      color: textMain,
                      activeColor: accentMain,
                      gap: 8,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      duration: const Duration(milliseconds: 350),
                      tabs: [
                        GButton(icon: Icons.home, text: 'Home',),
                        GButton(
                            icon: Icons.query_stats_rounded, text: 'Exercise'),
                        GButton(
                          icon: Icons.question_answer,
                          text: 'AskChat',
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => GymChatBot(),));
                          },
                        ),
                        GButton(icon: Icons.person, text: 'Profile'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
