import 'package:flutter/material.dart';
import 'package:semechu/screens/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFF9417),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '메뉴선택잘해',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 20,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30), // 간격을 위한 SizedBox
              const Text(
                '세 메 추',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // const SizedBox(height: 10), // 간격을 위한 SizedBox
              Text(
                '종대      뉴      천',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 20,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
