import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';

class Couplesettingpage extends StatefulWidget {
  @override
  _CouplesettingpageState createState() => _CouplesettingpageState();
}

class _CouplesettingpageState extends State<Couplesettingpage> {
  bool isAutoTransferEnabled = false;

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
            SizedBox(height: 20),
            Column(
              children: [
                buildInputBox('상대방 ID', '아이디를 입력해주세요'),
                SizedBox(height: 10),
                buildInputBox('기념일', '기념일을 입력해주세요'),
                SizedBox(height: 10),
                buildInputBox('자동이체 날짜', '날짜를 선택해주세요'),
                SizedBox(height: 20),
                buildInputBox('자동이체 금액', '금액을 선택해주세요'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage2(),
                        ));
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0XFF0046FF), // 버튼 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: Size(120, 48), // 버튼 크기 설정
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputBox(String label, String hintText, {TextEditingController? controller}) {
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


class Couplesettingpage2 extends StatelessWidget {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController(); // 계좌번호 컨트롤러 추가

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
                            Navigator.of(context).pop(); // 대화 상자를 닫음
                          },
                          child: Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Align(
                alignment: Alignment.centerRight, // 텍스트를 오른쪽으로 정렬
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
            SizedBox(height: 20),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the previous page (MainPage)
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '이전',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFDADADA), // 버튼 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(120, 48), // 버튼 크기 설정
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to SignUpPage2
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage2(),
                    ));
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0XFF0046FF), // 버튼 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(120, 48), // 버튼 크기 설정
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputBox(String label, String hintText, {TextEditingController? controller}) {
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
              LengthLimitingTextInputFormatter(label == '계좌번호' ? 12 : 6), // 최대 길이 설정
              FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
            ],
            keyboardType: TextInputType.number, // 숫자 키보드 설정
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