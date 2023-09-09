import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'coupleSettingPage.dart';
import 'calendarPage.dart';
import 'petPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        elevation: 0,
        title: Text(
          "홈",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Image.asset('personicon.png'), // 사람 모양 아이콘
            onPressed: () {
              // 아이콘을 눌렀을 때 수행할 작업 추가
            },
          ),
          IconButton(
            icon: Image.asset('bellicon.png'), // 알림(종 모양) 아이콘
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('알림'),
                    content: Container(
                      width: double.maxFinite,
                      height: 300, // 알림 목록의 높이 조절
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
                          // 여기에 추가적인 알림 항목을 추가하세요
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
      ),
      body: Container(
        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                // "내 계좌" 박스
                GestureDetector(
                  onTap: () {
                    // "내 계좌"를 누를 때 수행할 작업 추가
                  },
                  child: Container(
                    width: screenWidth - 40, // 화면 가로 크기에서 여백 20을 뺀 크기
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽에 정렬
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '내 계좌',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // "전체보기"를 누를 때 다른 화면으로 이동
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage2(),
                              ));
                            },
                            child: Text(
                              '전체보기 >',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0046FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 추가 박스 1
            buildBox(
              screenWidth - 40,
              Color(0xFF0046FF),
              '개인\n111-111-1111\n여백',
              70,
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 3,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget buildBox(double width, Color color, String text, double height) {
    return GestureDetector(
      onTap: () {
        // 각 박스를 누를 때 수행할 작업 추가
      },
      child: Container(
        width: width,
        height: 50.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        elevation: 0,
        title: Text(
          "홈",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Image.asset('personicon.png'), // 사람 모양 아이콘
            onPressed: () {
              // 아이콘을 눌렀을 때 수행할 작업 추가
            },
          ),
          IconButton(
            icon: Image.asset('bellicon.png'), // 알림(종 모양) 아이콘
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('알림'),
                    content: Container(
                      width: double.maxFinite,
                      height: 300, // 알림 목록의 높이 조절
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
                          // 여기에 추가적인 알림 항목을 추가하세요
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
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => _selectPage(0),
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // 그림자 크기
                      primary: _selectedPageIndex == 0
                          ? Colors.grey // 선택된 상태의 색상 (GREY)
                          : Color(0xFF0046FF), // 선택되지 않은 상태의 색상 (0046FF)
                    ),
                    child: Text(
                      '개인',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedPageIndex == 0
                            ? Colors.white // 선택된 상태의 텍스트 색상
                            : Colors.white, // 선택되지 않은 상태의 텍스트 색상
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // 버튼 사이 간격 조절
                Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => _selectPage(1),
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // 그림자 크기
                      primary: _selectedPageIndex == 1
                          ? Colors.grey // 선택된 상태의 색상 (GREY)
                          : Color(0xFF0046FF), // 선택되지 않은 상태의 색상 (0046FF)
                    ),
                    child: Text(
                      '커플',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedPageIndex == 1
                            ? Colors.white // 선택된 상태의 텍스트 색상
                            : Colors.white, // 선택되지 않은 상태의 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedPageIndex == 0 ? PersonalPage() : CouplePage(),
          ),
        ],
      ),
    );
  }
}

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<Map<String, dynamic>> accountData = []; // 서버에서 받아온 계좌 정보를 저장할 리스트

  @override
  void initState() {
    super.initState();
    fetchAccountData(); // 초기 데이터 로드
  }

  Future<void> fetchAccountData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/account/1'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      setState(() {
        accountData = List<Map<String, dynamic>>.from(data);
      });
      print(accountData);
    } else {
      throw Exception('API 요청 실패');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('개인통장 정보'),
      ),
      body: ListView.builder(
        itemCount: accountData.length,
        itemBuilder: (BuildContext context, int index) {
          return buildAccountCard(accountData[index], context);
        },
      ),
    );
  }
}
Widget buildAccountCard(Map<String, dynamic> accountInfo, BuildContext context) {
  void _showConfirmationDialog(accountInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('커플통장으로 전환하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('예'),
              onPressed: () {
                // 커플통장으로 전환하는 작업을 여기에 추가
                // 예를 눌렀을 때 실행할 코드를 작성하세요
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // Couplesettingpage로 이동
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Couplesettingpage(),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }
  return Container(
    width: double.infinity,
    height: 150.0,
    margin: EdgeInsets.all(16.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              accountInfo['accountNumber'], // accountNumber를 표시
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showConfirmationDialog(accountInfo); // 해당 데이터로 다이얼로그 표시
              },
              icon: Icon(Icons.arrow_forward),
              label: Text(''),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Text(
          '${accountInfo["balance"]}원', // balance를 표시
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class CouplePage extends StatefulWidget {
  @override
  _CouplePageState createState() => _CouplePageState();
}

class _CouplePageState extends State<CouplePage> {
  String petName = ''; // 펫 이름을 저장하는 변수

  // 공통으로 사용하는 컨테이너 생성 함수
  Widget buildContainer(String title, Color color, Function()? onPressed, String? centerText, Function()? onCenterTextPressed) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
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
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          if (centerText != null) // 가운데 텍스트 추가
            InkWell(
              onTap: onCenterTextPressed, // 클릭 이벤트 추가
              child: Center(
                child: Text(
                  centerText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // 텍스트 색상을 원하는 색상으로 설정하세요.
                  ),
                ),
              ),
            ),
          SizedBox(height: 5),
          if (onPressed != null)
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text('버튼'), // 버튼 텍스트 설정
              ),
            ),
        ],
      ),
    );
  }

  // 다이얼로그 창을 열어서 펫 이름을 설정하는 함수
  void _setPetName(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('펫 이름 설정'),
          content: TextField(
            decoration: InputDecoration(hintText: '펫 이름을 입력하세요'),
            onChanged: (value) {
              setState(() {
                petName = value; // 입력한 펫 이름을 저장
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 여기서 필요한 작업을 수행하고 펫 이름을 저장할 수 있습니다.
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: buildContainer(
              '커플통장',
              Color(0xFFF7F7F7),
              null,
              '가운데에 표시할 텍스트',
              null,
            ),
          ),
          SizedBox(height: 3),
          Expanded(
            flex: 1,
            child: buildContainer(
              'Calendar',
              Color(0xFFF7F7F7),
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(),
                  ),
                );
              },
              null,
              null,
            ),
          ),
          SizedBox(height: 3),
          Expanded(
            flex: 1,
            child: buildContainer(
              'Pet',
              Color(0xFFF7F7F7),
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PetPage(),
                  ),
                );
              },
              '펫 이름을 설정해주세요',
                  () {
                _setPetName(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
