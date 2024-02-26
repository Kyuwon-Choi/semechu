import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:semechu/screens/start_screen.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'ad8dfa60ab73d914f8b68ee6447a5bf1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartScreen(),
    );
  }
}
