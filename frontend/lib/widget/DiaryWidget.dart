import 'dart:convert';

import 'package:dio/src/multipart_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class DiaryWidget extends StatefulWidget {
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
                dateLogSet = {};
                fetchScheduleData(selectedDate.year.toString() , selectedDate.month.toString());
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
          if (isDate) {
            // isDate가 true인 경우 해당 날짜의 dateLogId를 찾아서 저장
            dateLogId = dateLogSet
                .firstWhere((dto) =>
            dto.dateAt.year == eventDate.year &&
                dto.dateAt.month == eventDate.month &&
                dto.dateAt.day == eventDate.day)
                .dateLogId;
          }
          return GestureDetector(
            onTap: isDate ? () {
              print("Container clicked!");
              _showEventsForDiary(eventDate,dateLogId);
            } : null, // isClickable이 false일 경우 onTap을 null로 설정하여 클릭 이벤트를 비활성화합니다.
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDate ? Colors.blue : Colors.transparent,
              ),
              child: Column(
                children: [
                  Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF69695D),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      itemCount: 7 * 6,
    );
  }

  void _showEventsForDiary(DateTime eventDate, dateLogId) {
    print(dateLogId);
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
                  _showAddEventDialog(eventDate, dateLogId);
                },
                child: Text('일정 추가'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddEventDialog(DateTime eventDate, int dateLogId) async {
    final picker = ImagePicker();
    File? _image;
    String content = "";
    Color eventColor = Colors.blue; // 이벤트의 기본 색상 설정
    print(dateLogId);
    Widget _buildImageWidget() {
      if (_image != null) {
        // XFile을 File로 변환하여 이미지 표시
        return Image.file(File(_image!.path));
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
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _image = File(image.path);
                      }); // 이미지를 업데이트하기 위해 setState 호출
                    }
                  },
                  child: Text('사진 추가'),
                ),
                _buildImageWidget(), // 이미지를 표시하는 위젯 추가
                TextField(
                  onChanged: (value) {
                    // 사용자가 입력한 값을 id 변수에 저장
                    content = value;
                  },
                  decoration: InputDecoration(labelText: '내용'),
                ),
                // 카테고리 선택 버튼
                ElevatedButton(
                  onPressed: () {
                    if (_image != null) {
                      uploadImage(dateLogId, _image!, content);
                      print("이미지 추가해야함");
                      return;
                    }


                    // final event = DiaryEvent(
                    //   title: '일정 제목',
                    //   description: '일정 내용',
                    //   color: eventColor,
                    //   startDate: eventDate,
                    //   category: selectedCategory, // 선택한 카테고리 저장
                    // );
                    //
                    // setState(() {
                    //   if (events.containsKey(eventDate)) {
                    //     events[eventDate]!.add(event);
                    //   } else {
                    //     events[eventDate] = [event];
                    //   }
                    // });

                    Navigator.of(context).pop();
                    _showEventsForDiary(eventDate, dateLogId); // 일정을 추가한 후에 해당 날짜의 이벤트 표시
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

class DateLogForCalendarResponseDto {
  final int dateLogId;
  final DateTime dateAt;

  DateLogForCalendarResponseDto({required this.dateLogId, required this.dateAt});

  factory DateLogForCalendarResponseDto.fromJson(Map<String, dynamic> json) {
    return DateLogForCalendarResponseDto(
      dateLogId: json['dateLogId'],
      dateAt: DateTime.parse(json['dateAt']),
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