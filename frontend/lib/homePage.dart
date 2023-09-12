import 'package:flutter/material.dart';
import 'coupleSettingPage.dart';
import 'calendarPage.dart';
import 'petPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'myConsumePage.dart';
import 'myAccountPage.dart';


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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  Map<String, dynamic> accountData = {};
  void initState(){
    super.initState();
    _loadUserDataAndFetchData();
  }
  String userId = '';
  Future<void> _sendFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = prefs.getString('fcmToken');
    final userId = prefs.getInt("userId");

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/user/token'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userId': userId.toString(),
          'fcmToken': fcmToken.toString(),
        }),
      );

      if (response.statusCode == 200) {
        // 성공적인 응답 처리
        print('API 요청 성공');
        print('응답 데이터: ${response.body}');
      } else {
        // 실패한 경우 오류 처리
        print('API 요청 실패');
        print('상태 코드: ${response.statusCode}');
        print('오류 메시지: ${response.body}');
      }
    } catch (e) {
      // 예외 처리
      print('API 요청 중 오류 발생: $e');
    }
  }

  Future<void> _loadUserDataAndFetchData() async {
    _sendFcmToken();
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchAccountData(); // 초기 데이터 로드를 기다립니다.
  }
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
  }
  Future<void> fetchAccountData() async {
    print(userId);
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/user/account/$userId"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final data = responseData['data'];
      setState(() {
        accountData = Map<String, dynamic>.from(data);
      });
      print(accountData);
    } else {
      throw Exception('API 요청 실패');
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          "홈",
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {},
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          '내 계좌',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
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
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 4,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyAccountPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF0046FF),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child:
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/purple2.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                children: [
                                  Text(
                                    "accountType", // Display account type here
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.7, // Adjust the opacity as needed
                                    child: Text(
                                      '${accountData["personalAccount"]}', // Your smaller text here
                                      style: TextStyle(
                                        fontSize: 12, // Adjust the font size as needed
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '잔액: ${accountData["amount"]} 원',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFE4ECFF),
                                ),
                                child: Text('이체'),
                              ),
                              SizedBox(width: 16), // Add spacing between buttons
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFE4ECFF),
                                ),
                                child: Text('결제'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyConsumePage(),
                    ),
                  );
                },
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
                    padding: const EdgeInsets.all(24.0),
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
          ],
        ),
      ),
    );
  }

  Widget buildBox(double width, Color color, Map<String, dynamic> accountData, double height) {
    return GestureDetector(
      onTap: () {
      },
      // child: Container(
      //   width: width,
      //   height: height,
      //   decoration: BoxDecoration(
      //     color: color,
      //     borderRadius: BorderRadius.circular(20.0),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey,
      //         offset: Offset(0, 2),
      //         blurRadius: 4.0,
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         '계좌번호: ${accountData["personalAccount"]}',
      //         style: TextStyle(
      //           fontSize: 18,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //       Text(
      //         '잔액: ${accountData["amount"]}',
      //         style: TextStyle(
      //           fontSize: 16,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
          "홈",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(24),
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
                          ? Colors.grey
                          : Color(0xFF0046FF),
                    ),
                    child: Text(
                      '개인',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedPageIndex == 0
                            ? Colors.white
                            : Colors.white,
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
                          ? Colors.grey
                          : Color(0xFF0046FF),
                    ),
                    child: Text(
                      '커플',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedPageIndex == 1
                            ? Colors.white
                            : Colors.white,
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
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/account/1'));

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
Widget? buildAccountCard(Map<String, dynamic> accountInfo, BuildContext context) {
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
                Navigator.of(context).pop();
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

  Widget buildContainer(String title, Color color, Function()? onPressed) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
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
          if (onPressed != null)
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text('버튼'),
              ),
            ),
        ],
      ),
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
              '개인통장',
              Color(0xFFF7F7F7),
                  () {
                _showConfirmationDialog(context);
              },
            ),
          ),
          SizedBox(height: 3),
          Expanded(
            flex: 1,
            child: buildContainer(
              '개인통장',
              Color(0xFFF7F7F7),
                  () {
                _showConfirmationDialog(context);
              },
            ),
          ),
          SizedBox(height: 3),
          Expanded(
            flex: 1,
            child: buildContainer(
              '개인통장',
              Color(0xFFF7F7F7),
                  () {
                _showConfirmationDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CouplePage extends StatefulWidget {
  @override
  _CouplePageState createState() => _CouplePageState();
}

class _CouplePageState extends State<CouplePage> {
  String petName = '';

  Widget buildContainer(String title, Color color, Function()? onPressed, String? centerText, Function()? onCenterTextPressed) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
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
                    color: Colors.black,
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


