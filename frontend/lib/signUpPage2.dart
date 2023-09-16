import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'simplePasswordPage.dart';

class SignUpPage2 extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  onTapSignUp(String id, String password, String name, String birthAt,String phoneNumber, String persnalAccount, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/user/signup'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "id": id,
          "password": password,
          "simplePassword": "123456",
          "name": name,
          "phoneNumber": phoneNumber ,
          "birthAt": '${birthAt.substring(0, 4)}-${birthAt.substring(4, 6)}-${birthAt.substring(6, 8)}',
          "personalAccount": persnalAccount
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      int userId = responseData['data'];
      // 필요한 작업 수행
      if (statusCode == 200) {
        print("성공");
        // 아이디 비밀번호 입력 후 간편 비밀번호 설정 페이지로 이동
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SimplePasswordPage(userId: userId),
        ));

      } else {
        print(statusCode);
        // 회원가입 실패
      }
    }
    catch (e) {
      print("에러발생 $e");
    }
  }

  final String name;
  final String birthAt;
  final String persnalAccount;
  final String phoneNumber;
  SignUpPage2({required this.name, required this.birthAt,required this.phoneNumber, required this.persnalAccount});

  @override
  Widget build(BuildContext context) {
    String id = "";
    String password = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0XFFFFFFFF),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/ottbar2.png',
              width: 80,
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.all(20),


        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child:
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '유의사항',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '- 비밀번호는 영문자, 숫자, 특수문자 혼용(8~15)로 설정해주세요',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 70),
            Expanded(
              flex: 6,
              child:
              Column(
                children: [
                  buildInputBox('아이디', '아이디를 입력하세요',controller: idController, onChanged: (value) {
                    id = value;
                  }),
                  SizedBox(height: 20),
                  buildInputBox('비밀번호', '비밀번호를 입력해주세요',controller: passwordController, onChanged: (value) {
                    password = value;
                  }),
                  SizedBox(height: 50),
                  Expanded(
                    flex: 1,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '이전',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDADADA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(120, 48),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onTapSignUp(id, password, name, birthAt, phoneNumber , persnalAccount, context);
                          },
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0046FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(120, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputBox(String label, String hintText,
      {TextEditingController? controller, TextInputType? keyboardType, required Null Function(dynamic value) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType, // keyboardType 설정 추가
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.0),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}