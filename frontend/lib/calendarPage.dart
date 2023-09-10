import 'package:flutter/material.dart';
import 'weekdayswidget.dart';
import 'dart:core';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? dDayDate;
  String? dDayText;

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

  @override
  Widget build(BuildContext context) {
    final dDay = calculateDDay(dDayDate); // 디데이 계산

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
              SizedBox(height: 16),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  height: 400, // CrCalendar Container의 원하는 높이 설정
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
                  child: Center(
                    child: CalendarWidget(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openDDayPage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: DDayPage(
            onDDaySet: (date, text) { // 수정된 부분: date와 text 모두 전달
              Navigator.pop(context); // 모달을 먼저 닫습니다.
              setState(() {
                dDayDate = date; // 디데이 값을 설정합니다.
                dDayText = text; // 텍스트를 설정합니다.
              });
            },
          ),
        );
      },
    );
  }
}

class DDayPage extends StatefulWidget {
  final Function(DateTime, String?) onDDaySet; // 수정된 부분: String?을 추가

  DDayPage({required this.onDDaySet});

  @override
  _DDayPageState createState() => _DDayPageState();
}

class _DDayPageState extends State<DDayPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController textController = TextEditingController(); // 텍스트 입력 컨트롤러 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "디데이 날짜 설정",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
                "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textController, // 텍스트 입력 필드에 컨트롤러 할당
              decoration: InputDecoration(
                labelText: '텍스트 입력', // 입력 필드 라벨
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final text = textController.text; // 입력한 텍스트 가져오기
                widget.onDDaySet(selectedDate, text); // 날짜와 텍스트 모두 전달
              },
              child: Text("설정"),
            ),
          ],
        ),
      ),
    );
  }
}