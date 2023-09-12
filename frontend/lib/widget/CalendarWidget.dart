import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<CalendarEvent>> events = {};
  String selectedCategory = '주 관리자'; // 기본 카테고리를 '주 관리자'로 설정

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(),
        SizedBox(height: 30),
        _buildWeekDays(),
        Expanded(
          child: _buildCalendar(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
      padding: EdgeInsets.all(20),
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday ? Colors.red : Colors.transparent,
              ),
              child: Column(
                children: [
                  Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : Color(0xFF69695D),
                    ),
                  ),
                  if (eventsForDate != null) // 해당 날짜에 이벤트가 있는 경우
                    ...eventsForDate.map((event) {
                      return Container(
                        width: 10, // 이벤트 표시를 위한 작은 원
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
          title: Text(
            DateFormat('yyyy년 MM월 dd일').format(eventDate),
            style: TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (events.containsKey(eventDate) &&
                  events[eventDate]!.isNotEmpty)
                ...events[eventDate]!.map((event) {
                  return ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                  );
                }).toList()
              else
                Text('일정이 없습니다.'),
              ElevatedButton(
                onPressed: () {
                  _showAddEventDialog(eventDate);
                },
                child: Text('일정 추가'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddEventDialog(DateTime eventDate) async {
    final picker = ImagePicker();
    XFile? image;
    Color eventColor = Colors.blue; // 이벤트의 기본 색상 설정

    Widget _buildImageWidget() {
      if (image != null) {
        // XFile을 File로 변환하여 이미지 표시
        return Image.file(File(image!.path));
      } else {
        return SizedBox.shrink(); // 이미지가 없는 경우 빈 위젯 반환
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            DateFormat('yyyy년 MM월 dd일').format(eventDate),
            style: TextStyle(fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: '일정 제목'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: '일정 내용'),
                ),
                // 카테고리 선택 버튼
                ElevatedButton(
                  onPressed: () {
                    _showCategoryDialog(); // 카테고리 선택 다이얼로그 표시
                  },
                  child: Text('카테고리 선택'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategory == '주 관리자'){
                      eventColor = Color(0xFF0046FF);
                    }else if(selectedCategory =='부 관리자'){
                      eventColor = Color(0xFFF90000);
                    }else{
                      eventColor = Color(0xFF9E00FF);
                    }
                    final event = CalendarEvent(
                      title: '일정 제목',
                      description: '일정 내용',
                      color: eventColor,
                      startDate: eventDate,
                      category: selectedCategory, // 선택한 카테고리 저장
                    );

                    setState(() {
                      if (events.containsKey(eventDate)) {
                        events[eventDate]!.add(event);
                      } else {
                        events[eventDate] = [event];
                      }
                    });

                    Navigator.of(context).pop();
                    _showEventsForDate(eventDate); // 일정을 추가한 후에 해당 날짜의 이벤트 표시
                  },
                  child: Text('일정 추가'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  // 카테고리를 선택하는 다이얼로그를 표시하는 메소드
  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("카테고리 선택"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 주 관리자 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = '주 관리자';
                  });
                  Navigator.of(context).pop(); // 모달 다이얼로그 닫기
                },
                child: Text('주 관리자'),
              ),
              // 부 관리자 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = '부 관리자';
                  });
                  Navigator.of(context).pop(); // 모달 다이얼로그 닫기
                },
                child: Text('부 관리자'),
              ),
              // 공동 카테고리 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = '공동';
                  });
                  Navigator.of(context).pop(); // 모달 다이얼로그 닫기
                },
                child: Text('공동'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }
}


class CalendarEvent {
  final String title;
  final String description;
  final Color color;
  final DateTime startDate;
  final String category; // 일정 카테고리 추가

  CalendarEvent({
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.category, // 카테고리 필드 추가
  });
}