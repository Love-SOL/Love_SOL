import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'simplePasswordPage.dart';
import 'homePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  bool isAuth = false;

  onTap1WonTransfer(String accountNumber, String phoneNumber, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/account'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'accountNumber': accountNumber,
          'phoneNumber': phoneNumber,
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];

      // 필요한 작업 수행
      if (statusCode == 200) {
        // 1원 이체 성공
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text('성공적으로 인증번호를 발송하였습니다.'),
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
      } else {
        print(statusCode);
        // 1원 이체 실패
        // 1원 이체 실패 실패 시의 처리를 수행
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  onTapAuth1WonTransfer(String accountNumber, String authNumber, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/account/auth'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'accountNumber': accountNumber,
          'authNumber': authNumber,
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];

      // 필요한 작업 수행
      if (statusCode == 200) {
        // 인증 성공
        isAuth = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('성공'),
              content: Text('인증에 성공하셨습니다.'),
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
      } else {
        print(statusCode);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('실패'),
              content: Text('인증에 실패하셨습니다. 다시 한번 확인해주세요.'),
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
    } catch (e) {
      print("에러발생 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String birthAt = '';
    String phoneNumber = '';
    String personalAccount = '';
    String authNumber = '';

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: Color(0XFF0046FF),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildInputBox('이름', '이름을 입력하세요', controller: nameController, onChanged: (value) {
                      name = value;
                    }),
                    SizedBox(height: 10),
                    buildInputBox('생년월일', '숫자 8자리 입력', controller: birthdateController, onChanged: (value) {
                      birthAt = value;
                    }),
                    SizedBox(height: 10),
                    buildInputBox('계좌번호', '12자리 입력', controller: accountNumberController, onChanged: (value) {
                      personalAccount = value;
                    }),
                    SizedBox(height: 10),
                    buildInputBox('휴대폰 번호', '휴대폰 번호를 입력하세요', controller: phoneNumberController, onChanged: (value) {
                      phoneNumber = value;
                    }),
                    GestureDetector(
                      onTap: () {
                        onTap1WonTransfer(accountNumberController.text, phoneNumberController.text, context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '인증번호 보내기 >',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    buildInputBox('인증번호', '숫자 6자리 입력', controller: verificationCodeController, onChanged: (value) {  }),
                    GestureDetector(
                      onTap: () {
                        onTapAuth1WonTransfer(accountNumberController.text, verificationCodeController.text, context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '인증번호 인증',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              flex: 2,
              child: Row(
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
                      minimumSize: Size(100, 48),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (name.isNotEmpty && birthAt.isNotEmpty && phoneNumber.isNotEmpty && personalAccount.isNotEmpty && isAuth) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage2(name: name, birthAt: birthAt, phoneNumber: phoneNumber, persnalAccount: personalAccount,),
                        ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림'),
                              content: Text('이름, 생년월일, 휴대폰번호, 계좌번호 입력과 인증을 모두 마치셔야합니다.'),
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
                      minimumSize: Size(100, 48),
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

  Widget buildInputBox(String label, String hintText, {TextEditingController? controller, required Null Function(dynamic value) onChanged}) {
    TextInputType keyboardType = TextInputType.number; // 기본적으로 숫자 키보드 설정

    if (label == '이름') {
      keyboardType = TextInputType.text;
    }

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
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                label == '계좌번호' ? 12 : (label == '휴대폰 번호' ? 11 : (label == '생년월일' ? 8 : 6)),
              ),
            ],
            keyboardType: keyboardType, // 위에서 설정한 키보드 타입 적용
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
      appBar: AppBar(
        backgroundColor: Color(0XFF0046FF),
        elevation: 0,
      ),

      body: Container(

        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(20),


        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
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
            SizedBox(height: 20),
            Expanded(
              flex: 6,
              child:
              Column(
                children: [
                  buildInputBox('아이디', '아이디를 입력하세요', false ,  controller: idController, onChanged: (value) {
                    id = value;
                  }),
                  SizedBox(height: 20),
                  buildInputBox('비밀번호', '비밀번호를 입력해주세요', true ,controller: passwordController, onChanged: (value) {
                    password = value;
                  }),
                  SizedBox(height: 20),
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
                            minimumSize: Size(100, 48),
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

  Widget buildInputBox(String label, String hintText, bool isPassword ,
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
            obscureText: isPassword == true ? true : false,
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