import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;

class Couplesettingpage extends StatefulWidget {
  @override
  _CouplesettingpageState createState() => _CouplesettingpageState();
}

class _CouplesettingpageState extends State<Couplesettingpage> {
  bool isAutoTransferEnabled = false;
  String userId = "";
  String receiverId = "";
  String aniversary = "";
  String day = "";
  String amount = "";
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await _loadUserData();
    await createLoveBox();
  }

  Future<void> createLoveBox() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/couple'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'id': userId,
        }),
      );
    } catch (e) {
      return;
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
  }

  Future<void> sendCoupleNotice() async {
    try {
      print("userId를 찾는다");
      print(userId);
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/couple/connect'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'id': userId,
          "receiverId": receiverId,
          "aniversary": aniversary,
          "day": day,
          "amount": amount
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      print(responseData);
      print("안녕하세요우");
    } catch (e) {
      return;
    }
  }

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
                buildInputBox('상대방 ID', '아이디를 입력해주세요', onChanged: (value) {
                  receiverId = value;
                }),
                SizedBox(height: 10),
                buildInputBox('기념일', '기념일을 입력해주세요', onChanged: (value) {
                  aniversary = value;
                }),
                SizedBox(height: 10),
                buildInputBox('자동이체 날짜', '날짜를 선택해주세요', onChanged: (value) {
                  day = value;
                }),
                SizedBox(height: 20),
                buildInputBox('자동이체 금액', '금액을 선택해주세요', onChanged: (value) {
                  amount = value;
                }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print(receiverId);
                        print(aniversary);
                        print(day);
                        print(amount);
                        if (receiverId == "" || aniversary == "" || day == "" || amount == "") return;
                        await sendCoupleNotice();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CouplePage(),
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

  Widget buildInputBox(String label, String hintText, {TextEditingController? controller, required Null Function(dynamic value) onChanged}) {
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