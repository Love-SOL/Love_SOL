import 'package:flutter/material.dart';

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            },
          ),
        ],
        title: Text(
          "내 계좌",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '내 소비 페이지 내용',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
