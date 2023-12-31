import 'dart:convert';

import 'package:dio/src/multipart_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:untitled1/widget/AlbumWidget.dart';

class DiaryWidget extends StatefulWidget {
  final Function(int) onShowDiaryChanged;
  DiaryWidget({required this.onShowDiaryChanged});
  @override
  _DiaryWidgetState createState() => _DiaryWidgetState();
}

class _DiaryWidgetState extends State<DiaryWidget> {
  String userId = '';
  String coupleId = '';
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<DiaryEvent>> events = {};
  String selectedCategory = 'MAIN_OWNER_SCHEDULE'; // 기본 카테고리를 'MAIN_OWNER_SCHEDULE'로 설정
  Set<DateLogForCalendarResponseDto> dateLogSet = {};


  void initState() {
    super.initState();
    _loadUserDataAndFetchData();
  }

  void _changeShowDiary(int dateLogId) {
    widget.onShowDiaryChanged(dateLogId);
  }
  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchScheduleData(DateTime.now().year.toString(), DateTime.now().month.toString());
  }

  void uploadImage(int dateLogId, File image, String content) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        "content": content
      });
      List<int> imageBytes = image.readAsBytesSync();

      MultipartFile multipartFile = MultipartFile.fromBytes(imageBytes, filename: "image.jpg");

      // String Content를 FormData에 추가
      formData.files.add(MapEntry('image', multipartFile));
      // Replace the URL with your API endpoint.
      var response = await dio.post('http://10.0.2.2:8080/api/date-log/$dateLogId', data: formData);
      // Handle the response as needed.
      print('Response: ${response.data}');
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  Future<void> fetchScheduleData(String year , String month) async{

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/date-log/calendar/' + coupleId + '?year=' + year + '&&month=' + month), // 스키마를 추가하세요 (http 또는 https)
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
        List<dynamic> data = responseBody['data'];
        List<DateLogForCalendarResponseDto> dateLogList =  data.map((data) => DateLogForCalendarResponseDto.fromJson(data as Map<String, dynamic>)).toList();

        for (var dateLog in dateLogList) {
          print(dateLog.dateAt);  // 예: 일정 날짜만 출력
          setState(() {
            dateLogSet.add(dateLog);
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

  bool isClickable() {
    return true;
  }

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
                dateLogSet = {};
                fetchScheduleData(selectedDate.year.toString() , selectedDate.month.toString());
              });
            },
          ),
          Text(
            DateFormat('yyyy년 MM월').format(selectedDate), // 원하는 형식으로 날짜 포맷
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
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
                dateLogSet = {};
                fetchScheduleData(selectedDate.year.toString() , selectedDate.month.toString());
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
              fontFamily: 'Lato',
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

          final eventDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            day,
          );

          int dateLogId = -1;
          // 이벤트 데이트가 datelog에 포함되면
          bool isDate = dateLogSet.any((dto) =>
          dto.dateAt.year == eventDate.year &&
              dto.dateAt.month == eventDate.month &&
              dto.dateAt.day == eventDate.day
          );


          String amount = "";

          if (isDate) {
            // isDate가 true인 경우 해당 날짜의 dateLogId를 찾아서 저장
            dateLogId = dateLogSet
                .firstWhere((dto) =>
            dto.dateAt.year == eventDate.year &&
                dto.dateAt.month == eventDate.month &&
                dto.dateAt.day == eventDate.day)
                .dateLogId;

            amount = dateLogSet
                .firstWhere((dto) =>
            dto.dateAt.year == eventDate.year &&
                dto.dateAt.month == eventDate.month &&
                dto.dateAt.day == eventDate.day).totalAmount;
          }

          return GestureDetector(
            onTap: isDate
                ? () {
              print("Container clicked!");
              _changeShowDiary(dateLogId);
            }
                : null,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "$day",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: isDate ? Color(0xFFA47DE5) : Color(0xFF69695D),
                      ),
                  ),
                  isDate
                      ? Text(
                    "-" + amount,
                    style: TextStyle(
                      fontSize:10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA47DE5),
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        }
      },
      itemCount: 7 * 6,
    );
  }
}

class DateLogForCalendarResponseDto {
  final int dateLogId;
  final DateTime dateAt;
  final String totalAmount;

  DateLogForCalendarResponseDto({required this.dateLogId, required this.dateAt , required this.totalAmount});

  factory DateLogForCalendarResponseDto.fromJson(Map<String, dynamic> json) {
    return DateLogForCalendarResponseDto(
      dateLogId: json['dateLogId'],
      dateAt: DateTime.parse(json['dateAt']),
      totalAmount: json['totalAmount'].toString()
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateLogForCalendarResponseDto &&
        other.dateLogId == dateLogId;
  }

  @override
  int get hashCode => dateLogId.hashCode;
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

class HeartShapeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Adjust the size as needed
      height: 100, // Adjust the size as needed
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            child: Icon(
              Icons.favorite,
              size: 100, // Adjust the size as needed
              color: Colors.red,
            ),
          ),
          Positioned(
            right: 0,
            child: Icon(
              Icons.favorite,
              size: 100, // Adjust the size as needed
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}