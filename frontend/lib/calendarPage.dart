import 'dart:convert';

import 'package:flutter/material.dart';
import 'weekdayswidget.dart';
import 'dart:core';
import './widget/DiaryWidget.dart';
import './widget/CalendarWidget.dart';
import './widget/DdayWidget.dart';
import './widget/AlbumWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? dDayDate;
  DateTime? targetDate = DateTime.now();
  String? dDayText = '일정 없음';
  int? dDay = 0;
  bool showCalendar = true;
  bool showDiary = false;
  bool showAlbum = false;
  String userId = '';
  String coupleId = '';

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchData();
  }

  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchDDayData();

  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> fetchDDayData() async{
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/couple/dday/' + coupleId), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      var decode = utf8.decode(response.bodyBytes);
      Map<String, dynamic> responseBody = json.decode(decode);

      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseBody['statusCode'];
      // 필요한 작업 수행
      if (statusCode == 200) {
        // 성공
        Map<String, dynamic> json = responseBody['data'];
        print(json);
        setState(() {
          dDay = json['remainingDay'];
          dDayText = json['title'];
          targetDate = DateTime.parse(json['date']);
        });
      } else {
        print(statusCode);
        // 실패
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  int calculateDDay(DateTime? dDayDate) {
    if (dDayDate == null) {
      return 0; // 디데이 날짜가 설정되지 않은 경우 0을 반환
    }

    final now = DateTime.now();
    final difference = dDayDate.difference(now);
    return difference.inDays; // 현재 날짜와 디데이 날짜의 차이를 일수로 반환
  }

  void _showCalendar() {
    setState(() {
      showCalendar = true;
      showDiary = false;
      showAlbum = false;
    });
  }

  void _showDiary() {
    setState(() {
      showCalendar = false;
      showDiary = true;
      showAlbum = false;
    });
  }

  void _showAlbum() {
    setState(() {
      showCalendar = false;
      showDiary = false;
      showAlbum = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final dDay = calculateDDay(dDayDate); // 디데이 계산
    return WillPopScope(
      onWillPop: _onBackPressed, // 뒤로 가기 버튼을 눌렀을 때 실행될 함수
      child :Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF7F7F7),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0XFF0046FF),
          ),
          actions: [
            IconButton(
              icon: Image.asset('assets/personicon.png'),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset('assets/bellicon.png'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Container(
                        width: double.maxFinite,
                        height: 300,
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text('알림 1'),
                              subtitle: Text('알림 내용 1'),
                            ),
                            ListTile(
                              title: Text('알림 2'),
                              subtitle: Text('알림 내용 2'),
                            ),
                          ],
                        ),
                      ),
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
            ),
          ],
          title: Text(
            "캘린더",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _openDDayPage();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7F7), // 배경색
                      borderRadius: BorderRadius.circular(10), // 박스 모양 설정
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // 그림자 색상
                          spreadRadius: 2, // 그림자 확장 정도
                          blurRadius: 5, // 그림자 흐릿한 정도
                          offset: Offset(0, 2), // 그림자 위치 (x, y)
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat('yyyy.MM.dd').format(targetDate!), // 디데이 계산 결과를 표시
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            '$dDayText (D-$dDay)',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _showCalendar,
                      style: ElevatedButton.styleFrom(
                        primary: showCalendar ? Color(0xFF0046FF) : Color(0xFFDADADA),
                      ),
                      child: Text("일정"),
                    ),
                    ElevatedButton(
                      onPressed: _showDiary,
                      style: ElevatedButton.styleFrom(
                        primary: showDiary ? Color(0xFF0046FF) : Color(0xFFDADADA),
                      ),
                      child: Text("일기"),
                    ),
                    ElevatedButton(
                      onPressed: _showAlbum,
                      style: ElevatedButton.styleFrom(
                        primary: showAlbum ? Color(0xFF0046FF) : Color(0xFFDADADA),
                      ),
                      child: Text("앨범"),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      if (showCalendar)
                        Container(
                          width: double.infinity,
                          decoration: commonBoxDecoration, // 공통 스타일 적용
                          child: CalendarWidget(),
                        ),

                      if (showDiary)
                        Container(
                          width: double.infinity,
                          decoration: commonBoxDecoration,
                          child: DiaryWidget(),
                        ),

                      if (showAlbum)
                        Container(
                          width: double.infinity,
                          decoration: commonBoxDecoration,
                          child: AlbumWidget(),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    // API 호출 및 데이터 갱신 로직
    Navigator.pop(context, 'update'); // A 페이지로 'update' 결과를 반환
    return true; // B 페이지를 종료하고 뒤로 가기 동작을 허용
  }

  BoxDecoration commonBoxDecoration = BoxDecoration(
    color: Color(0xFFE4ECFF), // 배경색
    borderRadius: BorderRadius.circular(10), // 박스 모양 설정
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // 그림자 색상
        spreadRadius: 2, // 그림자 확장 정도
        blurRadius: 5, // 그림자 흐릿한 정도
        offset: Offset(0, 2), // 그림자 위치 (x, y)
      ),
    ],
  );


  void _openDDayPage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: DDayPage(
            onDDaySet: (date, text , target) {
              Navigator.pop(context);
              setState(() {
                dDay = date;
                dDayText = text;
                targetDate = target;
              });
            },
          ),
        );
      },
    );
  }
}

