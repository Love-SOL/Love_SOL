import 'package:flutter/material.dart';
import 'dart:core';
import 'calendar_page.dart';
import 'package:cr_calendar/src/cr_calendar.dart';



class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CrCalendarController _controller = CrCalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        elevation: 0,
        title: Text(
          "캘린더",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Image.asset('personicon.png'), // 사람 모양 아이콘
            onPressed: () {
              // 아이콘을 눌렀을 때 수행할 작업 추가
            },
          ),
          IconButton(
            icon: Image.asset('bellicon.png'), // 알림(종 모양) 아이콘
            onPressed: () {
              // 아이콘을 눌렀을 때 수행할 작업 추가
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 디데이를 포함하는 Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
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
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            children:[
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '+240',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]
                          )
                        ],
                      ),
                      Text(
                        '처음만난날',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // CrCalendar를 포함하는 다른 Container
              Container(
                width: double.infinity,
                height: 400, // CrCalendar Container의 원하는 높이 설정
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
                child: Center(
                  child: Calendar(
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}