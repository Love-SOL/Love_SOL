import 'package:flutter/material.dart';
import 'homePage.dart';
import 'loginPage.dart';

class SimplePasswordPage extends StatefulWidget {
  @override
  _SimplePasswordPageState createState() => _SimplePasswordPageState();
}

class _SimplePasswordPageState extends State<SimplePasswordPage> {
  String pin = "";
  int maxPinLength = 6;
  List<Color> circleColors = List.generate(6, (index) => Color(0XFFD9D9D9));

  void onKeyboardTap(String value) {
    setState(() {
      if (pin.length < maxPinLength) {
        pin += value;
        circleColors[pin.length - 1] = Colors.grey;

        if (pin.length == maxPinLength) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
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
            'simplepasswordbackground.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '간편비밀번호',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 5),
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
                  '간편비밀번호 재등록',
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
        ],
      ),
    );
  }

  Widget buildCircle(Color color) {
    return Container(
      width: 16,
      height: 16,
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
        onPrimary: Colors.transparent,
        minimumSize: Size(80, 80),
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
        onPrimary: Colors.transparent,
        minimumSize: Size(80, 80),
      ),
    );
  }
}
