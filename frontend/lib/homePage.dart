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
import 'package:intl/intl.dart';
import './widget/BottomNav.dart';


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
  List<PieChartSectionData> sectionList = [];



  String userId = "";
  String coupleId = "";

  Map<String, Color> categoryColors = {
    '식당': Color(0xFF0245AC),
    '쇼핑': Colors.red,
    '커피숍': Colors.green,
    '온라인': Colors.yellow,
    '기타': Colors.deepPurple
  };

  void initState(){
    super.initState();
    _loadUserDataAndFetchData();
  }
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
    await fetchTransactionCategoryData(accountData["accountNumber"]);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> fetchAccountData() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/main/$userId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      setState(() {
        accountData = Map<String, dynamic>.from(responseBody['data']);
      });
      print(accountData);
    } else {
      throw Exception('API 요청 실패');
    }
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
        print('실행');
        print(dataList);
        setState(() {
          sectionList = createPieChartSections(dataList);
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

  List<PieChartSectionData> createPieChartSections(List<GetTransactionByCategoryResponseDto> data) {
    return data.map((item) {
      print(item);
      return PieChartSectionData(
        color: categoryColors[item.category] ?? Colors.grey, // 카테고리에 맞는 색상, 없으면 회색으로 설정
        value: item.rate.toDouble(), // amount를 double로 변환
        title: item.category,
        radius: 50,
      );
    }).toList();
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
        padding: EdgeInsets.all(15),
        child:
        Column(
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
                      builder: (context) => MyAccountPage(accountNumber: accountData["accountNumber"]),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE4ECFF),
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
                    padding: const EdgeInsets.only(top: 24, bottom: 24, left: 10, right: 10),
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
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  'assets/shinhanlogo.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                children: [
                                  Text(
                                    "주 계좌",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text(
                                      '${accountData["accountNumber"] == null ? "" : accountData["accountNumber"]}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
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
                                  '${accountData["balance"] == null ? "0" : formatCurrency(removeSosu(accountData["balance"].toString()))} 원',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
                                  primary: Color(0xFF0046FF),
                                ),
                                child: Text('이체'),
                              ),
                              SizedBox(width: 16), // Add spacing between buttons
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF0046FF),
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
                      builder: (context) => MyConsumePage(accountNumber: accountData["accountNumber"]),
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
                              child: sectionList.isNotEmpty
                                  ? PieChart(
                                PieChartData(
                                  sections: sectionList,
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                ),
                              )
                                  : Center(child: Text("소비 내역이 없습니다", style: TextStyle(fontSize: 20))),
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
      bottomNavigationBar: buildBottomNavigationBar(context, 2)
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
        bottomNavigationBar: buildBottomNavigationBar(context, 0)
    );
  }
}

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<Map<String, dynamic>> accountData = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await fetchAccountData(); // 초기 데이터 로드
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
  }

  Future<void> fetchAccountData() async {

    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/account/$userId'));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      setState(() {
        accountData = List<Map<String, dynamic>>.from(responseBody['data']);
      });
      print(accountData);
    } else {
      throw Exception('API 요청 실패');
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      ListView.builder(
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

  return Container(
    width: double.infinity,
    // height: 150.0,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/shinhanlogo.png', // 이미지 파일 경로
                  width: 30.0, // 이미지의 너비
                  height: 30.0, // 이미지의 높이
                ),
                SizedBox(width: 8.0), // 이미지와 텍스트 사이의 간격 조절
                Text(
                  accountInfo['accountNumber'], // accountNumber를 표시
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                _showConfirmationDialog(accountInfo); // 해당 데이터로 다이얼로그 표시
              },
              icon: Icon(
                Icons.list,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            '${formatCurrency(removeSosu(accountInfo["balance"].toString()))}원', // balance를 표시
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0046FF),
              ),
              child: Text('이체'),
            ),
            SizedBox(width: 16), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0046FF),
              ),
              child: Text('결제'),
            ),
          ],
        ),
      ],
    ),
  );
}

String formatCurrency(String amountStr) {
  int amount = int.parse(amountStr);
  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'ko_KR'); // locale에 따라 적절한 포맷을 선택할 수 있습니다.
  return formatCurrency.format(amount).substring(1); // '₩' 기호 제거
}

String removeSosu(String amount){
  return amount.substring(0, amount.length-2);
}

class CouplePage extends StatefulWidget {
  @override
  _CouplePageState createState() => _CouplePageState();
}

class _CouplePageState extends State<CouplePage> {
  String petName = '';
  int petType = 0;
  String dday = '0';
  String schedule = '일정이 없어요';
  String scheduleDDay = '';
  Map<String, dynamic> petData = {};
  Map<String, dynamic> scheduleData = {
    'content': '일정 없음',  // String 값
    'remainingDay': 0,              // int 값
    'date': DateTime.now()           // DateTime 객체
  };
  bool isPaid = false;
  void initState(){
    super.initState();
    _loadAnniversaryData();
    _loadScheduleData();
    _loadPetData();
  }

  Future<void> _loadAnniversaryData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    print('커플 페이지');
    print(coupleId);
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/couple/anniversary/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      // 성공
      setState(() {
        dday = responseBody['data'].toString();
      });
    } else {
      print(statusCode);
      // 실패
    }

  }
  Future<void> _loadScheduleData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/schedule/recent/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      setState(() {
        scheduleData = Map<String, dynamic>.from(responseBody['data']);
      });
    } else {
      print(statusCode);
      // 실패
    }

  }

  Future<void> _isPaid() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    print("이것이 나와야 함");
    print(coupleId);
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/transaction/$coupleId"));
    // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
    Map<String, dynamic> responseData = json.decode(response.body);
    // 파싱한 데이터에서 필드에 접근
    int result = responseData["data"];
    // 필요한 작업 수행
    print("결제내역조회완료");
    if (result != 0) {
      setState(() {
        isPaid = true;
        petType = result;
      });
      print(isPaid);
    }
  }

  Future<void> _loadPetData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    print(coupleId);
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/pet/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      setState(() {
        petData = Map<String, dynamic>.from(responseBody['data']);
      });
      print(petData);
    } else {
      print('펫 요청 실패');
      _isPaid();
    }
  }
  Widget buildContainer(String title, Color color, Function()? onPressed, String? centerText, Function()? onCenterTextPressed, bool isSchedule , bool isPet) {
    return GestureDetector(
      onTap: onPressed, // 위젯을 클릭했을 때 onPressed 함수 실행
      child: Container(
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
            if(isSchedule)
              Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 100.0),
                          Text("+" + dday, style: TextStyle(color: Colors.white , fontSize: 18)),
                        ],
                      ),
                      SizedBox(width: 15), // 이미지와 텍스트 사이 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheduleData["content"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '다음 일정까지: ${scheduleData["remainingDay"]}일 남았습니다', // Exp 텍스트 추가
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 5),
            if (isPet)
              Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/pet${petData["kind"]}.gif",
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            petData["name"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'EXP: ${petData["exp"]}', // Exp 텍스트 추가
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _setPetName(BuildContext context) {
    Future<void> _registPet() async {
      final prefs = await SharedPreferences.getInstance();
      final coupleId = prefs.getInt("coupleId");
      try {
        print("펫을 등록합니다.");
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/pet/$coupleId'),
          headers: <String, String>{'Content-Type': 'application/json',},
          body: jsonEncode(<String, dynamic>{'name': petName,'kind': petType}),
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final data = responseData['data'];
          setState(() {
            petData = Map<String, dynamic>.from(data);
          });
          print(petData);
        } else {
          throw Exception('API 요청 실패');
        }
      } catch (e) {
        // 예외 처리
        print('API 요청 중 오류 발생: $e');
      }
    }

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
                _registPet();
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCalendarPage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CalendarPage()),
    );
    
    if (result == 'update') {
      _loadScheduleData();
    }
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
      body:
      Align(
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
                  false,
                  false
              ),
            ),
            SizedBox(height: 3),
            Expanded(
              flex: 1,
              child: buildContainer(
                'Calendar',
                Color(0xFFF7F7F7),
                    () {
                  _navigateToCalendarPage();
                },
                null,
                null,
                true,
                false,
              ),
            ),
            SizedBox(height: 3),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  petData.isEmpty
                      ? (isPaid
                      ? buildContainer(
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
                      false,
                      false// true로 변경
                  )
                      : buildContainer(
                      'Pet',
                      Color(0xFFF7F7F7),
                      null,
                      '무엇이 태어날까요?',
                      null,
                      false,
                      false
                  )
                  )
                      :
                  buildContainer(
                    "Pet",
                    Color(0xFFF7F7F7),
                        () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PetPage(),
                        ),
                      );
                    },
                    null,
                    null,
                    false,
                    true,
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 4),
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

