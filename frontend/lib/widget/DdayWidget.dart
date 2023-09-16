import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DDayPage extends StatefulWidget {
  final Function(int, String? , DateTime?) onDDaySet; // 수정된 부분: String?을 추가

  DDayPage({required this.onDDaySet});

  @override
  _DDayPageState createState() => _DDayPageState();
}

class _DDayPageState extends State<DDayPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController textController = TextEditingController(); // 텍스트 입력 컨트롤러 추가
  String userId = '';
  String coupleId = '';

  void initState() {
    super.initState();
    _loadUserDataAndFetchData();
  }

  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  void registCustomDDay(String title) async {
    print('registCustomDDay');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/couple/dday'),
        // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'coupleId': coupleId,
          'title': title,
          'targetDay': "${selectedDate.year}-${selectedDate.month.toString()
              .padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}"
        }),
      );
      var decode = utf8.decode(response.bodyBytes);
      Map<String, dynamic> responseBody = json.decode(decode);
      int statusCode = responseBody['statusCode'];

      // 필요한 작업 수행
      if (statusCode == 200) {
        // 성공
        DDayResponseDto dday = DDayResponseDto.fromJson(responseBody['data']);
        widget.onDDaySet(dday.remainingDay, dday.title, dday.date);
      } else {
        print(statusCode);
        // 실패

      }
    } catch (e) {
      print("에러발생 $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), // Adjust the radius as needed
              topRight: Radius.circular(10.0), // Adjust the radius as needed
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "디데이 날짜 설정",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate
                      .day}일",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: '내용을 입력하세요',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final text = textController.text;
                  registCustomDDay(text);
                },
                child: Text("설정"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class DDayResponseDto {
  final int coupleId;
  final String title;
  final int remainingDay;
  final DateTime date;

  DDayResponseDto({required this.coupleId, required this.title, required this.remainingDay , required this.date});

  // JSON -> DDayResponseDto
  factory DDayResponseDto.fromJson(Map<String, dynamic> json) {
    return DDayResponseDto(
      coupleId: json['coupleId'],
      title: json['title'],
      remainingDay: json['remainingDay'],
      date : DateTime.parse(json['date'])
    );
  }
}