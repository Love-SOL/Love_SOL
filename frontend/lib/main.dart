import 'package:flutter/material.dart';
import 'loginPage.dart'; // 로그인 페이지 임포트


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love SOL',
      home: LoginPage(), // 처음 실행되는 페이지 설정 (예: 로그인 페이지)
    );
  }
}