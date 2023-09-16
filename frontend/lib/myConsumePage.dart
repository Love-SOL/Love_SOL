import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './widget/BottomNav.dart';
import './widget/Appbar.dart';

class MyConsumePage extends StatefulWidget {
  final String accountNumber;

  MyConsumePage({required this.accountNumber});

  @override
  _MyConsumePage createState() => _MyConsumePage();
}


class _MyConsumePage extends State<MyConsumePage> {
  String coupleId = '';
  String accountNumber = '';

  int currentIndex = 0;
  List<PieChartSectionData> sectionList = [];
  final Map<String, int> expenditureData = {};

  final Map<String, IconData> categoryIcons = {
    '식당': Icons.restaurant,   // 식비 아이콘
    '쇼핑': Icons.shopping_cart, // 쇼핑 아이콘
    '커피숍': Icons.local_cafe,  // 여가 아이콘
    '온라인': Icons.cloud,         // 생활 아이콘
    '기타' : Icons.music_note
  };

  Map<String, Color> categoryColors = {
    '식당': Color(0xFF7928FF),
    '쇼핑': Color(0xFF914FFF),
    '커피숍': Color(0xFFA47DE5),
    '온라인': Color(0xFFCFBEED),
    '기타': Color(0xFFE6EDFF),
  };

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchData(widget.accountNumber);
  }


  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> _loadUserDataAndFetchData(String accountNumber) async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchTransactionCategoryData(accountNumber);
  }

  Future<void> fetchTransactionCategoryData(String accountNumber) async{
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/account/transaction/category/' + accountNumber + '?year=2023&&month=9'), // 스키마를 추가하세요 (http 또는 https)
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
        List<GetTransactionByCategoryResponseDto> dataList = data.map((data) => GetTransactionByCategoryResponseDto.fromJson(data as Map<String, dynamic>)).toList();

        setState(() {
          sectionList = createPieChartSections(dataList);
          addDataListToMap(dataList);
        });
        sectionList.forEach((sectionData) {
          print('Color: ${sectionData.color}, Value: ${sectionData.value}, Title: ${sectionData.title}, Radius: ${sectionData.radius}');
        });

      } else {
        print(statusCode);
        // 실패
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  PieChartSectionData createPieChartSection(GetTransactionByCategoryResponseDto data) {
    return PieChartSectionData(
      color: categoryColors[data.category] ?? Colors.grey,
      value: data.rate.toDouble(),
      title: data.category,
      radius: 50,
    );
  }

  void addDataListToMap(List<GetTransactionByCategoryResponseDto> dtoList) {
    for (GetTransactionByCategoryResponseDto dto in dtoList) {
      expenditureData[dto.category] = dto.amount;
    }
  }

  List<PieChartSectionData> createPieChartSections(List<GetTransactionByCategoryResponseDto> data) {
    return data.map((item) {
      return PieChartSectionData(
        color: categoryColors[item.category] ?? Colors.grey,
        value: item.rate.toDouble(), // amount를 double로 변환
        title: item.category,
        radius: 50,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "내 소비",
      ),
      body:Container(
        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFA47DE5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '내 소비',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center, // 가운데 정렬
                            child: AspectRatio(
                              aspectRatio: 1.3,
                              child: PieChart(
                                PieChartData(
                                  sections: sectionList,
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height:15),
            Expanded(
              flex : 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '카테고리별 지출 내역',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height:50),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenditureData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category = expenditureData.keys.elementAt(index);
                            final amount = expenditureData.values.elementAt(index);
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          categoryIcons[category],
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$amount 원',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                SizedBox(height:16),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 2),
    );

  }
}

class GetTransactionByCategoryResponseDto {
  final String category;
  final int amount;
  final double rate;

  GetTransactionByCategoryResponseDto({
    required this.category,
    required this.amount,
    required this.rate,
  });

  factory GetTransactionByCategoryResponseDto.fromJson(Map<String, dynamic> json) {
    return GetTransactionByCategoryResponseDto(
      category: json['category'],
      amount: json['amount'],
      rate: json['rate'].toDouble(),
    );
  }
}
