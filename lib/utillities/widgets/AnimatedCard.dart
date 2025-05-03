import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gain_wave_app/utillities/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class JumpingMotivationCard extends StatefulWidget {
  const JumpingMotivationCard({super.key});

  @override
  State<JumpingMotivationCard> createState() => _JumpingMotivationCardState();
}

class _JumpingMotivationCardState extends State<JumpingMotivationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _jumpAnimation;
  bool _isUp = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _jumpAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _isUp ? _controller.reverse() : _controller.forward();
        _isUp = !_isUp;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _jumpAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _jumpAnimation.value),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle Glow behind the card
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: accentMain.withOpacity(0.10),
                  blurRadius: 40,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Actual Card with white border
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color:accentMain, width: 1),
            ),
            color: secondaryBG,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 41, 61, 23),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt, color: accentMain, size: 38),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Push Yourself Because No One Else Will."',
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: accentMain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Every rep takes you one step closer to your goal. Let’s get stronger!',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
