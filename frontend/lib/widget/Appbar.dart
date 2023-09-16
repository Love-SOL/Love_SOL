import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../loginPage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;

  CustomAppBar({required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<NoticeResDto> noticeList = [];
  String userId = '';
  String coupleId = '';

  @override
  void initState() {
    super.initState();
    print('알림함!!');
    _loadUserDataAndFetchData();
  }

  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchNoticeData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> fetchNoticeData() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/notice/$userId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    print(statusCode);
    if (statusCode == 200) {
      List<dynamic> data = responseBody['data'];
      List<NoticeResDto> dataList = data.map((data) => NoticeResDto.fromJson(data as Map<String, dynamic>)).toList();

      setState(() {
        noticeList = dataList;
      });
      print(noticeList[0].title);

    } else {
      throw Exception('API 요청 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
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
                      child: ListView.builder(
                        itemCount: noticeList.length,
                        itemBuilder: (context, index) {
                          final notice = noticeList[index];
                          return ListTile(
                            title: Text(notice.title),
                            subtitle: Text(notice.body),
                          );
                        },
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
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            widget.title,  // widget을 사용하여 title에 접근
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}

class NoticeResDto {
  final String kind;
  final String title;
  final String body;
  final DateTime createAt;
  final String senderName;

  NoticeResDto({
    required this.kind,
    required this.title,
    required this.body,
    required this.createAt,
    required this.senderName,
  });

  // JSON에서 NoticeResDto로 변환하는 팩토리 생성자
  factory NoticeResDto.fromJson(Map<String, dynamic> json) {
    return NoticeResDto(
      kind: json['kind'],
      title: json['title'],
      body: json['body'],
      createAt: DateTime.parse(json['createAt']),
      senderName: json['senderName'],
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('My Page'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0046FF),
                ),
                child: Text('로그아웃'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0046FF),
                ),
                child: Text('정산하기'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationDialog(BuildContext context) {
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
  }
}