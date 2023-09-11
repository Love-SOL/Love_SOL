import 'package:flutter/material.dart';
import 'authSimplePasswordPage.dart'; // 간편비밀번호 페이지 임포트
import 'signUpPage.dart'; // 회원가입 페이지 임포트
import 'homePage.dart'; // 홈페이지 임포트

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  Future<String?> _loadFcmData() async {
    final prefs = await SharedPreferences.getInstance();
    String? fcmToken = prefs.getString('fcmToken');
    return fcmToken;
  }

  sendFcmToken(int userId) async {
    try {
      final fcmToken = await _loadFcmData();
      print(fcmToken);
      if (fcmToken != null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/user/token'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'userId': userId.toString(),
            'fcmToken': fcmToken,
          }),
        );
      } else {
        print("fcmToken이 널입니다.");
      }
    } catch (e) {
      print("fcmToken 전송 실패");
    }
  }

  Future<void> _saveUserData(int userId, int coupleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setInt('coupleId', coupleId);
  }
  onTapLogin(String id, String password, BuildContext context) async {
    try {

      final response = await http.post(

        Uri.parse('http://10.0.2.2:8080/api/user/login'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'password': password,
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      // 필요한 작업 수행
      if (statusCode == 200) {
        Map<String, dynamic> userData = responseData["data"];
        print(userData);
        _saveUserData(userData["userId"], userData["coupleId"]);
        sendFcmToken(userData["userId"]);
        // 로그인 성공 후 페이지 이동
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));

      } else {
        print(statusCode);
        // 로그인 실패
        // 여기에서 로그인 실패 시의 처리를 수행하세요.
      }
    }
    catch (e) {
      print("에러발생 $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    String id = "";
    String password = "";
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Image.asset(
            'assets/loginbackground.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 100, // "Welcome" 글자의 수직 위치 조절
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 20), // "Welcome" 글자와 이미지 박스 사이의 간격 조절
                  Image.asset(
                    'assets/logincenterbox.png',
                    fit: BoxFit.contain,
                    width: 250, // 이미지 크기 조절
                  ),
                  SizedBox(height: 20), // 이미지 박스와 입력 상자 사이의 간격 조절
                  // 첫 번째 입력 상자 (ID 입력)
                  Container(
                    width: 250, // 입력 상자의 너비 조절
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Image.asset(
                          'assets/loginidinput.png',
                          width: 250, // 이미지 크기 조절
                        ),
                        Positioned(
                          left: 50, // 입력 상자를 오른쪽으로 이동
                          child: SizedBox(
                            width: 250, // 입력 상자의 너비 조절
                            child: TextField(
                              onChanged: (value) {
                                // 사용자가 입력한 값을 id 변수에 저장
                                id = value;
                              },
                              decoration: InputDecoration(
                                hintText: '아이디',
                                hintStyle: TextStyle(
                                  color: Color(0xFF979797), // 힌트 텍스트를 투명으로 설정
                                ),
                                border: InputBorder.none, // 입력 상자의 테두리를 제거하여 투명하게 만듦
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10), // 입력 상자와 입력 상자 사이의 간격 조절
                  // 두 번째 입력 상자 (비밀번호 입력)
                  Container(
                    width: 250, // 입력 상자의 너비 조절
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Image.asset(
                          'assets/loginpasswordinput.png',
                          width: 250, // 이미지 크기 조절
                        ),
                        Positioned(
                          left: 50, // 입력 상자를 오른쪽으로 이동
                          child: SizedBox(
                            width: 250, // 입력 상자의 너비 조절
                            child: TextField(
                              onChanged: (value) {
                                // 사용자가 입력한 값을 id 변수에 저장
                                password = value;
                              },
                              obscureText: true, // 비밀번호 필드로 설정
                              decoration: InputDecoration(
                                hintText: '영문자,숫자,특수문자 혼용(8~15자)',
                                hintStyle: TextStyle(
                                  color: Color(0xFF979797), // 힌트 텍스트를 투명으로 설정
                                ),
                                border: InputBorder.none, // 입력 상자의 테두리를 제거하여 투명하게 만듦
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 로그인 버튼 및 회원가입, 간편비밀번호 옵션 추가
          Positioned(
            bottom: 30, // 버튼의 수직 위치 조절
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // 로그인 버튼을 누를 때 다른 페이지로 이동
                      onTapLogin(id, password, context);
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/loginclick.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5), // 원하는 만큼 상단 여백 조절
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // 로그인 버튼과 다음 버튼 사이의 간격 조절
                  GestureDetector(
                    onTap: () {
                      // "회원가입" 텍스트를 누를 때 다른 페이지로 이동 (여기에서는 SignUpPage로 가정)
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ));
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 16,
                        decoration: TextDecoration.underline, // 밑줄 추가
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // "간편비밀번호" 텍스트를 누를 때 다른 페이지로 이동
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AuthSimplePasswordPage(userId: 1),
                      ));
                    },
                    child: Text(
                      '간편비밀번호',
                      style: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 16,
                        decoration: TextDecoration.underline, // 밑줄 추가
                      ),
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