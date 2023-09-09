import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController verificationCodeController =
  TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    buildInputBox('이름', '이름을 입력하세요'),
                    SizedBox(height: 20),
                    buildInputBox('생년월일', '숫자 6자리 입력', controller: birthdateController),
                    SizedBox(height: 20),
                    buildInputBox('계좌번호', '12자리 입력', controller: accountNumberController),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('인증번호 보내기'),
                              content: Text('여기에 인증번호 보내기 내용을 입력하세요.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
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
                    buildInputBox('인증번호', '숫자 6자리 입력', controller: verificationCodeController),
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpPage2(),
                      ));
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
      {TextEditingController? controller}) {
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(label == '계좌번호' ? 12 : 6),
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
  @override
  Widget build(BuildContext context) {
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
                  buildInputBox('아이디', '아이디를 입력하세요'),
                  SizedBox(height: 20),
                  buildInputBox('비밀번호', '비밀번호를 입력해주세요'),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
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
      {TextEditingController? controller}) {
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