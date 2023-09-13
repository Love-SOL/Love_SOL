import 'dart:convert';

import 'package:flutter/material.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;

class SimplePasswordPage extends StatefulWidget {
  final int userId;

  SimplePasswordPage({required this.userId});

  @override
  _SimplePasswordPageState createState() => _SimplePasswordPageState();
}

class _SimplePasswordPageState extends State<SimplePasswordPage> {
  String pin = "";
  int maxPinLength = 6;
  List<Color> circleColors = List.generate(6, (index) => Color(0XFFD9D9D9));

  Future<bool> sendToBackend(int userId, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/user/simple-password'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'simplePassword' : pin
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];

      // 필요한 작업 수행
      if (statusCode == 200) {
        // 간편 비밀번호 설정 성공
        return true;

      } else {
        print(statusCode);
        return false;
        // 간편 비밀번호 설정 실패
      }
    }
    catch (e) {
      print("에러발생 $e");
    }
    return false;
  }

  void onKeyboardTap(String value) {
    setState(() async {
      if (pin.length < maxPinLength) {
        setState((){
          pin += value;
          circleColors[pin.length - 1] = Colors.grey;});

        if (pin.length == maxPinLength) {
          //여기서 API쏴서
          if(await sendToBackend(widget.userId, pin)){
            print('성공');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
          }else{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('알림'),
                  content: Text('간편 비밀번호 설정에 실패하였습니다.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Alert 창 닫기
                      },
                    ),
                  ],
                );
              },
            );
          }

        }
      }
    });
  }

  void onBackspaceTap() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
        circleColors[pin.length] = Color(0XFFD9D9D9);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0046FF),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/spbackground.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1, // 위아래 여백을 화면 높이의 10%로 설정// 좌우 여백을 화면 너비의 15%로 설정
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                '간편비밀번호',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01), // 이 부분은 이전 답변에서 제거하세요.
              Text(
                '비밀번호를 입력해주세요',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCircle(circleColors[0]),
                  buildCircle(circleColors[1]),
                  buildCircle(circleColors[2]),
                  buildCircle(circleColors[3]),
                  buildCircle(circleColors[4]),
                  buildCircle(circleColors[5]),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '간편비밀번호 입력',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardButton("1"),
                  buildKeyboardButton("2"),
                  buildKeyboardButton("3"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardButton("4"),
                  buildKeyboardButton("5"),
                  buildKeyboardButton("6"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardButton("7"),
                  buildKeyboardButton("8"),
                  buildKeyboardButton("9"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardButton(""),
                  buildKeyboardButton("0"),
                  buildBackspaceButton(),
                ],
              ),
              SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  },
                  child: Text(
                    '다른 방법으로 로그인 >',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 18,
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

  Widget buildCircle(Color color) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      margin: EdgeInsets.all(4),
    );
  }

  Widget buildKeyboardButton(String value) {
    return ElevatedButton(
      onPressed: () {
        onKeyboardTap(value);
      },
      child: Text(
        value,
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary : Colors.transparent,
        onPrimary: Colors.transparent,
        minimumSize: Size(80, 80),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget buildBackspaceButton() {
    return ElevatedButton(
      onPressed: () {
        onBackspaceTap();
      },
      child: Icon(
        Icons.backspace,
        size: 24,
        color: Colors.black,
      ),
      style: ElevatedButton.styleFrom(
        primary : Colors.transparent,
        onPrimary: Colors.transparent,
        minimumSize: Size(80, 80),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
