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

  Future<void> doFareWall() async {
    final response = await http.post(Uri.parse("http://10.0.2.2:8080/api/couple/farewall/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    print(statusCode);
    if (statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("coupleId");
      coupleId = (prefs.getInt('coupleId') ?? '').toString();
      print('헤어져');
      print(coupleId);

    } else {
      throw Exception("API 요청 실패");
    }
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Options'),
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
                  primary: Color(0xFFA47DE5),
                ),
                child: Text('로그아웃'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  doFareWall();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFA47DE5),
                ),
                child: Text('해지하기'),
              ),
            ],
          ),
        );
      },
    );
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
          color: Color(0XFFA47DE5),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/Filled.png'),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
          IconButton(
            icon: Image.asset('assets/bellicon.png'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFA47DE5),
                        ),
                        child: Text('닫기'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/lovesollogo.png',
              width: 180.0, // Adjust the width to your desired size
              height: 100.0, // Adjust the height to your desired size
              fit: BoxFit.contain, // Adjust the fit as needed
            ),
            SizedBox(width: 0), // Adjust the amount of space between the logo and other items
          ],
        ),
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
}

