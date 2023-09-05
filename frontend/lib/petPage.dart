import 'package:flutter/material.dart';

class PetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Page'), // 페이지 제목
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pet Page Contents', // 페이지 내용 (더미 텍스트)
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 다른 원하는 위젯 또는 콘텐츠 추가 가능
          ],
        ),
      ),
    );
  }
}