import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Page'),
      ),
      body: Center(
        child: Text(
          'signuppage',
          style: TextStyle(
            fontSize: 24, // 원하는 글꼴 크기로 조정하세요.
            fontWeight: FontWeight.bold, // 원하는 글꼴 두께로 조정하세요.
          ),
        ),
      ),
    );
  }
}
