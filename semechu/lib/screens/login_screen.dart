import 'dart:convert';
import 'dart:io';
import 'package:semechu/models/user_info.dart';
import 'package:semechu/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:semechu/platforms/login_platform.dart';
import 'package:semechu/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;
  ApiService _apiService = ApiService(); //

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      await _storeOAuthToken(token);
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());
      await _storeProfileInfo(profileInfo.toString());
      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      // 로그인이 성공하면 HomeScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }

     UserModel user = UserModel(
    oauthId: '12332ffegr32423812',
    email: 'test@example.com',
    name: 'Test User',
  );

  AuthResponse authResponse = await _apiService.getJwtToken(user);
  print('JWT Token: ${authResponse.authToken}');
  }
   

  


  Future<void> _storeProfileInfo(String profileInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileInfo', profileInfo);
  }

  Future<void> _storeOAuthToken(OAuthToken token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token.accessToken);
    print('accessToken: ${token.accessToken}'); // accessToken 값 출력

    // idToken도 저장
    if (token.idToken != null) {
      await prefs.setString('idToken', token.idToken!);
      print('idToken: ${token.idToken}'); // idToken 값 출력
    }

    if (token.refreshToken != null) {
      await prefs.setString('refreshToken', token.refreshToken!);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Opacity(
                opacity: 0.30,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '세',
                        style: TextStyle(
                          color: Color(0xFFFD0A0A),
                          fontSize: 50,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: '메',
                        style: TextStyle(
                          color: Color(0xFFFF9417),
                          fontSize: 50,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                      ),
                      TextSpan(
                        text: '추',
                        style: TextStyle(
                          color: Color(0xFF0038FF),
                          fontSize: 50,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30), // 간격을 위한 SizedBox
              const Text(
                'SeMeChu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 300), // 간격을 위한 SizedBox

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: IconButton(
                  icon: Image.asset(
                    "images/login/kakaoLogin.png",
                  ),
                  onPressed: () {
                    signInWithKakao();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
