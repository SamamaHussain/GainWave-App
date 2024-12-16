import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gain_wave_app/Views/ChatApp/ChatAppView.dart';
import 'package:gain_wave_app/Views/Home/HomePageView.dart';
import 'package:gain_wave_app/main.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class page_control_nav extends StatefulWidget {
  const page_control_nav({super.key});
  @override
  State<page_control_nav> createState() => _page_control_navState();
}

class _page_control_navState extends State<page_control_nav> {
  var index = 0;

  final total_screens = [
    home_page_view(),
    Center(
      child: Text('Performance',style: TextStyle(color: textMain),),
    ),
    GymChatBot(),
    Center(
      child: Text('profile',style: TextStyle(color: textMain),),
    )
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
      body: total_screens[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                constraints: BoxConstraints.tightFor(height: 80),
                decoration: BoxDecoration(
                  color: secondaryBG,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    duration: Duration(milliseconds: 350),
                    tabs: [
                      GButton(icon: Icons.home, text: 'Home',),
                      GButton(
                          icon: Icons.query_stats_rounded, text: 'Performance'),
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
          ],
        ),
      ),
    );
  }
}
