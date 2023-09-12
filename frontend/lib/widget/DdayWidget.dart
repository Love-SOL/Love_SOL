import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DDayPage extends StatefulWidget {
  final Function(DateTime, String?) onDDaySet; // 수정된 부분: String?을 추가

  DDayPage({required this.onDDaySet});

  @override
  _DDayPageState createState() => _DDayPageState();
}

class _DDayPageState extends State<DDayPage> {
  DateTime selectedDate = DateTime.now();
  TextEditingController textController = TextEditingController(); // 텍스트 입력 컨트롤러 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "디데이 날짜 설정",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textController, // 텍스트 입력 필드에 컨트롤러 할당
              decoration: InputDecoration(
                labelText: '텍스트 입력', // 입력 필드 라벨
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final text = textController.text; // 입력한 텍스트 가져오기
                widget.onDDaySet(selectedDate, text); // 날짜와 텍스트 모두 전달
              },
              child: Text("설정"),
            ),
          ],
        ),
      ),
    );
  }
}