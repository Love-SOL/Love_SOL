import 'package:flutter/material.dart';

class SimplePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('simplePasswordPage'),
      ),
      body: Center(
        child: Text(
          'simplePasswordPage',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
