import 'package:flutter/material.dart';
import 'simplePasswordPage.dart'; // 간편비밀번호 페이지 임포트
import 'signUpPage.dart'; // 회원가입 페이지 임포트
import 'homePage.dart'; // 홈페이지 임포트


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Image.asset(
            'loginbackground.png',
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
                    'logincenterbox.png',
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
                          'loginidinput.png',
                          width: 250, // 이미지 크기 조절
                        ),
                        Positioned(
                          left: 50, // 입력 상자를 오른쪽으로 이동
                          child: SizedBox(
                            width: 250, // 입력 상자의 너비 조절
                            child: TextField(
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
                          'loginpasswordinput.png',
                          width: 250, // 이미지 크기 조절
                        ),
                        Positioned(
                          left: 50, // 입력 상자를 오른쪽으로 이동
                          child: SizedBox(
                            width: 250, // 입력 상자의 너비 조절
                            child: TextField(
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('loginclick.png'),
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
                  SizedBox(height: 20), // "회원가입" 텍스트와 "간편비밀번호" 텍스트 사이의 간격 조절
                  GestureDetector(
                    onTap: () {
                      // "간편비밀번호" 텍스트를 누를 때 다른 페이지로 이동
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SimplePasswordPage(),
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