import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyConsumePage extends StatelessWidget {

  final Map<String, int> expenditureData = {
    '식비': 150000,
    '쇼핑': 50000,
    '여가': 20000,
    '생활': 100000,
  };

  final Map<String, IconData> categoryIcons = {
    '식비': Icons.restaurant,   // 식비 아이콘
    '쇼핑': Icons.shopping_cart, // 쇼핑 아이콘
    '여가': Icons.beach_access,  // 여가 아이콘
    '생활': Icons.home,         // 생활 아이콘
  };

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
          "내 소비",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                    color: Color(0xFFE4ECFF),
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
                            color: Colors.black,
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
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      value: 25,
                                      title: '항목1',
                                      radius: 50,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.red,
                                      value: 30,
                                      title: '항목2',
                                      radius: 50,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.green,
                                      value: 15,
                                      title: '항목3',
                                      radius: 50,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orange,
                                      value: 30,
                                      title: '항목4',
                                      radius: 50,
                                    ),
                                  ],
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
    );
  }
}