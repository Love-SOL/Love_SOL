import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class DiaryWidget extends StatefulWidget {
  @override
  _DiaryWidgetState createState() => _DiaryWidgetState();
}

class _DiaryWidgetState extends State<DiaryWidget> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<DiaryEvent>> events = {};
  String selectedCategory = 'MAIN_OWNER_SCHEDULE'; // 기본 카테고리를 'MAIN_OWNER_SCHEDULE'로 설정

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(),
        SizedBox(height: 30),
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
              _showEventsForDiary(eventDate);
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

  void _showEventsForDiary(DateTime eventDate) {
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
                TextButton(
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {}); // 이미지를 업데이트하기 위해 setState 호출
                  },
                  child: Text('사진 추가'),
                ),
                _buildImageWidget(), // 이미지를 표시하는 위젯 추가
                TextField(
                  decoration: InputDecoration(labelText: '내용'),
                ),
                // 카테고리 선택 버튼
                ElevatedButton(
                  onPressed: () {

                    final event = DiaryEvent(
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
                    _showEventsForDiary(eventDate); // 일정을 추가한 후에 해당 날짜의 이벤트 표시
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
}


class DiaryEvent {
  final String title;
  final String description;
  final Color color;
  final DateTime startDate;
  final String category; // 일정 카테고리 추가

  DiaryEvent({
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.category, // 카테고리 필드 추가
  });
}