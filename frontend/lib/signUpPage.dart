import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatelessWidget {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  bool isAuth = false;

  onTap1WonTransfer(String accountNumber, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/account'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'accountNumber': accountNumber,
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];

      // 필요한 작업 수행
      if (statusCode == 200) {
        //1원 이체 성공


      } else {
        print(statusCode);
        // 1원 이체 실패
        // 1원 이체 실패 실패 시의 처리를 수행
      }
    }
    catch (e) {
      print("에러발생 $e");
    }
  }

  onTapAuth1WonTransfer(String accountNumber,String authNumber ,BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/account/auth'), // 스키마를 추가하세요 (http 또는 https)
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
      } else {
        print(statusCode);
        // 인증 실패

      }
    }
    catch (e) {
      print("에러발생 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String birthAt = '';
    String personalAccount = '';
    String authNumber ='';
    return Scaffold(
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
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildInputBox('이름', '이름을 입력하세요', onChanged: (value) {name = value;}),
                    SizedBox(height: 20),
                    buildInputBox('생년월일', '숫자 6자리 입력', controller: birthdateController, onChanged: (value) {birthAt = value;}),
                    SizedBox(height: 20),
                    buildInputBox('계좌번호', '12자리 입력', controller: accountNumberController, onChanged: (value) {personalAccount = value;}),
                    GestureDetector(
                      onTap: () {
                        onTap1WonTransfer(personalAccount,context);
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       title: Text('인증번호 보내기'),
                        //       content: Text('여기에 인증번호 보내기 내용을 입력하세요.'),
                        //       actions: [
                        //         TextButton(
                        //           onPressed: () {
                        //             Navigator.of(context).pop();
                        //           },
                        //           child:
                        //           Text('닫기'), // TextButton에 child 매개변수를 추가
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
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
                    buildInputBox('인증번호', '숫자 6자리 입력', controller: verificationCodeController,onChanged: (value) {authNumber = value;}),
                    GestureDetector(
                      onTap: () {
                        onTapAuth1WonTransfer(personalAccount,authNumber ,context);
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(120, 48),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (name.isNotEmpty && birthAt.isNotEmpty && personalAccount.isNotEmpty && isAuth){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage2(name: name, birthAt: birthAt, persnalAccount: personalAccount,),
                        ));
                      }else{
                        print('');
                      }
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(120, 48),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInputBox(String label, String hintText,
      {TextEditingController? controller, Function(String)? onChanged}) {
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
              if (label == '계좌번호' || label == '생년월일')
                LengthLimitingTextInputFormatter(label == '계좌번호' ? 12 : 8),
              if (label == '계좌번호' || label == '생년월일')
                FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
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

  onTapSignUp(String id, String password, String name, String birthAt, String persnalAccount, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/signup'), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "id": id,
          "password": password,
          "simplePassword": "123456",
          "name": name,
          "phoneNumber": "01012341234",
          "birthAt": '${birthAt.substring(0, 4)}-${birthAt.substring(4, 6)}-${birthAt.substring(6, 8)}',
          "personalAccount": persnalAccount
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      // 필요한 작업 수행
      if (statusCode == 200) {
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

  final String name;
  final String birthAt;
  final String persnalAccount;
  SignUpPage2({required this.name, required this.birthAt, required this.persnalAccount});
  @override
  Widget build(BuildContext context) {
    String id = ''; // 아이디를 저장할 변수 초기화
    String password = ''; // 비밀번호를 저장할 변수 초기화
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
                  buildInputBox('아이디', '아이디를 입력하세요', onChanged: (value) {id = value;}),
                  SizedBox(height: 20),
                  buildInputBox('비밀번호', '비밀번호를 입력해주세요', onChanged: (value) {password = value;}),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(120, 48),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onTapSignUp(id, password, name, birthAt, persnalAccount, context);
                          },
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
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
      {TextEditingController? controller, Function(String)? onChanged}) {
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