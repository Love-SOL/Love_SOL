import 'package:flutter/material.dart';
import 'weekdayswidget.dart';
import 'dart:core';
import './widget/DiaryWidget.dart';
import './widget/CalendarWidget.dart';
import './widget/DdayWidget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? dDayDate;
  String? dDayText;
  bool showCalendar = true;
  bool showDiary = false;
  bool showAlbum = false;

  @override
  void initState() {
    super.initState();
    dDayText = "디데이 설정 전"; // 초기 텍스트 설정
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
    final dDay = calculateDDay(dDayDate); // 디데이 계산

    return Scaffold(
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
                            Text(
                              '디데이',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '$dDay', // 디데이 계산 결과를 표시
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
                          '$dDayText',
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

                    // DiaryWidget를 표시하거나 숨깁니다.
                    if (showDiary)
                      Container(
                        width: double.infinity,
                        decoration: commonBoxDecoration, // 공통 스타일 적용
                        child: DiaryWidget(),
                      ),

                    if (showAlbum)
                      Container(
                        width: double.infinity,
                        decoration: commonBoxDecoration, // 공통 스타일 적용
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
            onDDaySet: (date, text) {
              Navigator.pop(context);
              setState(() {
                dDayDate = date;
                dDayText = text;
              });
            },
          ),
        );
      },
    );
  }
}


