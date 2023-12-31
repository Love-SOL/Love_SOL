import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:core';
import './widget/DiaryWidget.dart';
import './widget/CalendarWidget.dart';
import './widget/DdayWidget.dart';
import './widget/AlbumWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'widget/BottomNav.dart';
import 'widget/Appbar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? dDayDate;
  DateTime? targetDate = DateTime.now();
  String? dDayText = '';
  int? dDay = 0;
  bool showCalendar = true;
  bool showDiary = false;
  bool showAlbum = false;
  String userId = '';
  String coupleId = '';
  int dateLogId = 0;

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
      dateLogId = 0;
    });
  }

  void _showDiary() {
    setState(() {
      showCalendar = false;
      showDiary = true;
      showAlbum = false;
      dateLogId = 0;
    });
  }

  void _showAlbum() {
    setState(() {
      showCalendar = false;
      showDiary = false;
      showAlbum = true;
      dateLogId = 0;
    });
  }

  void _changeShowDiary(int dateLogId) {
    setState(() {
      showDiary = false;
      showAlbum = true;
      this.dateLogId = dateLogId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final dDay = calculateDDay(dDayDate); // 디데이 계산
    return WillPopScope(
      onWillPop: _onBackPressed, // 뒤로 가기 버튼을 눌렀을 때 실행될 함수
      child : Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
          title: "캘린더",
          ),
          body:Center(
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
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFA47DE5), // 시작 색상
                          Color(0xFFEEE1FF), // 종료 색상
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(20), // 박스 모양 설정
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
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat('yyyy.MM.dd').format(targetDate!), // 디데이 계산 결과를 표시
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            dDayText != '' ? '$dDayText (D-$dDay)' : "연인과 일정을 계획해보세요",
                            style: TextStyle(
                              fontSize: (dDayText != '' ? 20 : 15),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                        primary: showCalendar ? Color(0xFFA47DE5) : Color(0xFFFFFFFF),
                        onPrimary: showCalendar ? Colors.white : Color(0xFFA47DE5), // Text color based on condition
                      ),
                      child: Text("일정"),
                    ),
                    ElevatedButton(
                      onPressed: _showDiary,
                      style: ElevatedButton.styleFrom(
                        primary: showDiary ? Color(0xFFA47DE5) : Color(0xFFFFFFFF),
                        onPrimary: showDiary ? Colors.white : Color(0xFFA47DE5),
                      ),
                      child: Text("일기"),
                    ),
                    ElevatedButton(
                      onPressed: _showAlbum,
                      style: ElevatedButton.styleFrom(
                        primary: showAlbum ? Color(0xFFA47DE5) : Color(0xFFFFFFFF),
                        onPrimary: showAlbum ? Colors.white : Color(0xFFA47DE5),
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
                          child: DiaryWidget(
                            onShowDiaryChanged: _changeShowDiary, // 콜백 함수를 전달
                          ),
                        ),
                      if (showAlbum)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6DFFF), // 배경색을 보라색으로 설정
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AlbumWidget(dateLogId: dateLogId),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
          bottomNavigationBar: buildBottomNavigationBar(context, 1)
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    // API 호출 및 데이터 갱신 로직
    Navigator.pop(context, 'update'); // A 페이지로 'update' 결과를 반환
    return true; // B 페이지를 종료하고 뒤로 가기 동작을 허용
  }

  BoxDecoration commonBoxDecoration = BoxDecoration(
    color: Colors.white, // 배경색
    borderRadius: BorderRadius.circular(20), // 박스 모양 설정
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), // 왼쪽 위 모서리 둥글게 설정
              topRight: Radius.circular(20.0), // 오른쪽 위 모서리 둥글게 설정
            ),
            color: Colors.white, // 배경색 설정
          ),
          padding: EdgeInsets.all(16),
          child: DDayPage(
            onDDaySet: (date, text, target) {
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
      backgroundColor: Colors.transparent, // 배경을 투명으로 설정
    );
  }
}

