import 'package:flutter/material.dart';
import 'authSimplePasswordPage.dart';
import 'signUpPage.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  Future<void> _saveUserData(int userId, int coupleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setInt('coupleId', coupleId);
  }

  onTapLogin(String id, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'password': password,
        }),
      );

      Map<String, dynamic> responseData = json.decode(response.body);
      int statusCode = responseData['statusCode'];

      if (statusCode == 200) {
        Map<String, dynamic> userData = responseData["data"];
        print("로그인 성공");
        print(userData);
        await _saveUserData(userData["userId"], userData["coupleId"]);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      } else {
        print(statusCode);
        // 로그인 실패 처리
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = "";
    String password = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            'assets/loginbackground.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logincenterbox.png',
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 50),
                  Container(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Image.asset(
                          'assets/loginidinput.png',
                        ),
                        Positioned(
                          left: 50,
                          child: SizedBox(
                            width: 250,
                            child: TextField(
                              onChanged: (value) {
                                id = value;
                              },
                              decoration: InputDecoration(
                                hintText: '아이디',
                                hintStyle: TextStyle(
                                  color: Color(0xFF979797),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Image.asset(
                          'assets/loginpasswordinput.png',
                        ),
                        Positioned(
                          left: 50,
                          child: SizedBox(
                            width: 230,
                            child: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: '영문자,숫자,특수문자 혼용(8~15자)',
                                hintStyle: TextStyle(
                                  color: Color(0xFF979797),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              onTapLogin(id, password, context);
                            },
                            child: Container(
                              width: 270,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF0046FF),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
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
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ));
                                },
                                child: Text(
                                  '회원가입',
                                  style: TextStyle(
                                    color: Color(0xFF979797),
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(width: 60),
                            ],
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AuthSimplePasswordPage(userId: 1),
                              ));
                            },

                            child: Text(
                              '간편로그인',
                              style: TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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