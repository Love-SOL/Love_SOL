import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final titleController = TextEditingController();
  String userId = '';
  String coupleId = '';
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<CalendarEvent>> events = {};
  String selectedCategory = 'MAIN_OWNER_SCHEDULE'; // 기본 카테고리를 'MAIN_OWNER_SCHEDULE'로 설정

  void initState() {
    super.initState();
    _loadUserDataAndFetchData();
  }

  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchScheduleData(DateTime
        .now()
        .year
        .toString(), DateTime
        .now()
        .month
        .toString());
  }

  Future<void> fetchScheduleData(String year, String month) async {
    Color eventColor = Colors.blue;

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/schedule/' + coupleId + '?year=' + year +
                '&&month=' + month), // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      var decode = utf8.decode(response.bodyBytes);
      print(decode);
      Map<String, dynamic> responseBody = json.decode(decode);

      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseBody['statusCode'];
      // 필요한 작업 수행
      if (statusCode == 200) {
        // 성공
        List<dynamic> data = responseBody['data'];
        List<ScheduleResponseDto> scheduleList = data.map((data) =>
            ScheduleResponseDto.fromJson(data as Map<String, dynamic>))
            .toList();

        for (var schedule in scheduleList) {
          print(schedule.content); // 예: 일정 내용만 출력

          if (schedule.scheduleType == 'MAIN_OWNER_SCHEDULE') {
            eventColor = Color(0xFF0046FF);
          } else if (schedule.scheduleType == 'SUB_OWNER_SCHEDULE') {
            eventColor = Color(0xFFF90000);
          } else {
            eventColor = Color(0xFF9E00FF);
          }
          DateTime dateTime = DateTime.parse(schedule.startAt);

          final event = CalendarEvent(
            title: schedule.content,
            color: eventColor,
            startDate: dateTime,
            category: schedule.scheduleType, // 선택한 카테고리 저장
          );


          setState(() {
            if (events.containsKey(dateTime)) {
              events[dateTime]!.add(event);
            } else {
              events[dateTime] = [event];
            }
          });
        }
      } else {
        print(statusCode);
        // 실패
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<bool> createSchedule(CalendarEvent event) async {
    int scheduleType = 0;
    if (selectedCategory == 'MAIN_OWNER_SCHEDULE') {
      scheduleType = 1;
    } else if (selectedCategory == 'SUB_OWNER_SCHEDULE') {
      scheduleType = 2;
    } else {
      scheduleType = 0;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/schedule/' + coupleId),
        // 스키마를 추가하세요 (http 또는 https)
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'coupleId': 1,
          'content': event.title,
          'scheduleType': scheduleType,
          'startAt': DateFormat('yyyy-MM-dd').format(event.startDate),
          'endAt': DateFormat('yyyy-MM-dd').format(event.startDate),
        }),
      );
      // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
      Map<String, dynamic> responseData = json.decode(response.body);
      // 파싱한 데이터에서 필드에 접근
      int statusCode = responseData['statusCode'];
      // 필요한 작업 수행
      if (statusCode == 200) {
        // 성공
        print(responseData['data']);

        return true;
      } else {
        print(statusCode);
        // 실패
        return false;
      }
    } catch (e) {
      print("에러발생 $e");
      return false;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(),
        _buildWeekDays(),
        SizedBox(height: 20),
        Expanded(
          child: _buildCalendar(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month - 1,
                  selectedDate.day,
                );
                events = {};
                fetchScheduleData(selectedDate.year.toString(),
                    selectedDate.month.toString());
              });
            },
          ),
          Text(
            DateFormat('yyyy년 MM월').format(selectedDate), // 원하는 형식으로 날짜 포맷
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month + 1,
                  selectedDate.day,
                );
                events = {};
                fetchScheduleData(selectedDate.year.toString(),
                    selectedDate.month.toString());
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final List<String> weekDayAbbreviations = ['Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'];

    return Padding(
      padding: EdgeInsets.only(left:20, right:20, bottom:10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDayAbbreviations.map((day) {
          return Text(
            day,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month,
      1,
    );
    final weekDayOfFirstDay = firstDayOfMonth.weekday;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < weekDayOfFirstDay - 1 ||
            index >= daysInMonth + weekDayOfFirstDay - 1) {
          return Container();
        } else {
          final day = index - (weekDayOfFirstDay - 1) + 1;
          final isToday = now.year == selectedDate.year &&
              now.month == selectedDate.month &&
              now.day == day;

          final eventDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            day,
          );

          // 해당 날짜의 이벤트 리스트를 가져옴
          final eventsForDate = events[eventDate];

          return GestureDetector(
            onTap: () {
              _showEventsForDate(eventDate);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.black : Color(0xFF69695D),
                    ),
                  ),
                  if (eventsForDate != null) // 해당 날짜에 이벤트가 있는 경우
                    ...eventsForDate.map((event) {
                      return Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: event.color, // 이벤트의 색상 적용
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        }
      },
      itemCount: 7 * 6,
    );
  }

  void _showEventsForDate(DateTime eventDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            DateFormat('yyyy년 MM월 dd일').format(eventDate),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (events.containsKey(eventDate) &&
                    events[eventDate]!.isNotEmpty)
                  ...events[eventDate]!.map((event) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 8,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: event.color,
                            ),
                          ),
                          Expanded(child: Text(event.title)),
                        ],
                      ),
                    );
                  }).toList()
                else
                  Text('일정이 없습니다.'),
                SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showCategoryDialog(eventDate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0466FF),
                shadowColor: Colors.grey,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('+ 일정을 추가하세요'),
            ),

            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Future<void> _showAddEventDialog(DateTime eventDate) async {
    Color eventColor = Colors.blue; // 이벤트의 기본 색상 설정

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          // title: Text(
          //   DateFormat('yyyy년 MM월 dd일').format(eventDate),
          //   style: TextStyle(fontSize: 16),
          // ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: '할 일을 입력하세요'),
                ),
                SizedBox(height:10),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == 'MAIN_OWNER_SCHEDULE') {
                      eventColor = Color(0xFF0046FF);
                    } else if (selectedCategory == 'SUB_OWNER_SCHEDULE') {
                      eventColor = Color(0xFFF90000);
                    } else {
                      eventColor = Color(0xFF9E00FF);
                    }
                    final event = CalendarEvent(
                      title: titleController.text,
                      color: eventColor,
                      startDate: eventDate,
                      category: selectedCategory, // 선택한 카테고리 저장
                    );

                    if (await createSchedule(event)) {
                      setState(() {
                        if (events.containsKey(eventDate)) {
                          events[eventDate]!.add(event);
                        } else {
                          events[eventDate] = [event];
                        }
                      });
                      _showEventsForDate(eventDate); // 일정을 추가한 후에 해당 날짜의 이벤트 표시
                    }

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0466FF),
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('일정 추가'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryDialog(DateTime eventDate) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = 'MAIN_OWNER_SCHEDULE';
                  });
                  _showAddEventDialog(eventDate);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.circle,
                        color: Color(0xFF0046FF),
                      )
                    ),
                    SizedBox(width: 10),
                    Text('주 관리자'),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = 'SUB_OWNER_SCHEDULE';
                  });
                  _showAddEventDialog(
                      eventDate);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.circle,
                        color: Color(0xFFF90000),
                      )
                    ),
                    SizedBox(width: 10),
                    Text('부 관리자'),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = '공동';
                  });
                  _showAddEventDialog(eventDate); // 모달 bottom sheet 닫기
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child:
                          Icon(
                        Icons.circle,
                        color: Color(0xFF9E00FF),
                      )
                    ),
                    SizedBox(width: 10),
                    Text('공동'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class CalendarEvent {
  final String title;
  final Color color;
  final DateTime startDate;
  final String category; // 일정 카테고리 추가

  CalendarEvent({
    required this.title,
    required this.color,
    required this.startDate,
    required this.category, // 카테고리 필드 추가
  });
}

class ScheduleResponseDto {
  final int scheduleId;
  final String content;
  final String scheduleType;
  final String startAt;
  final String endAt;

  ScheduleResponseDto({required this.scheduleId, required this.content, required this.scheduleType, required this.startAt, required this.endAt});

  factory ScheduleResponseDto.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseDto(
      scheduleId: json['scheduleId'],
      content: json['content'],
      scheduleType: json['scheduleType'],
      startAt: json['startAt'],
      endAt: json['endAt'],
    );
  }
}