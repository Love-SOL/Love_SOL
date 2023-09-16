import 'package:flutter/material.dart';
import 'coupleSettingPage.dart';
import 'calendarPage.dart';
import 'petPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'myConsumePage.dart';
import 'loginPage.dart';
import 'myAccountPage.dart';
import 'package:intl/intl.dart';
import './widget/BottomNav.dart';
import './widget/Appbar.dart';


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
  List<NoticeResDto> noticeList = [];


  String userId = "";
  String coupleId = "";

  Map<String, Color> categoryColors = {
    '식당': Color(0xFF7928FF),
    '쇼핑': Color(0xFF914FFF),
    '커피숍': Color(0xFFA47DE5),
    '온라인': Color(0xFFCFBEED),
    '기타': Color(0xFFE6EDFF),
  };

  void initState() {
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
    await fetchNoticeData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = await (prefs.getInt('userId') ?? '').toString();
    coupleId = await (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> fetchAccountData() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/account/main/$userId"));

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

  Future<void> fetchTransactionCategoryData(String accountNumber) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/account/transaction/category/' +
            accountNumber + '?year=2023&&month=9'),
        // 스키마를 추가하세요 (http 또는 https)
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
        List<GetTransactionByCategoryResponseDto> dataList = data.map((data) =>
            GetTransactionByCategoryResponseDto.fromJson(
                data as Map<String, dynamic>)).toList();

        setState(() {
          sectionList = createPieChartSections(dataList);
        });
        sectionList.forEach((sectionData) {
          print('Color: ${sectionData.color}, Value: ${sectionData
              .value}, Title: ${sectionData.title}, Radius: ${sectionData
              .radius}');
        });
      } else {
        print(statusCode);
        // 실패
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  Future<void> fetchNoticeData() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/notice/$userId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      List<dynamic> data = responseBody['data'];
      List<NoticeResDto> dataList = data.map((data) =>
          NoticeResDto.fromJson(data as Map<String, dynamic>)).toList();

      setState(() {
        noticeList = dataList;
      });
    } else {
      throw Exception('API 요청 실패');
    }
  }

  List<PieChartSectionData> createPieChartSections(
      List<GetTransactionByCategoryResponseDto> data) {
    return data.map((item) {
      print(item);
      return PieChartSectionData(
        color: categoryColors[item.category] ?? Colors.grey,
        // 카테고리에 맞는 색상, 없으면 회색으로 설정
        value: item.rate.toDouble(),
        // amount를 double로 변환
        title: item.category,
        radius: 50,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        )
      );
    }).toList();
  }

  String formatAccountNumber(String accountNumber) {
    if (accountNumber.length != 12) {
      return "Invalid account number";
    }

    return accountNumber.substring(0, 3) + '-' +
        accountNumber.substring(3, 6) + '-' +
        accountNumber.substring(6, 12);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFF7F7F7),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0XFFA47DE5),
          ),
          actions: [
            IconButton(
              icon: Image.asset('assets/personicon.png'),
              onPressed: () {
                _showOptionsDialog(context);
              },
            ),
            IconButton(
              icon: Image.asset('assets/bellicon.png'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: Text('알림'),
                      content: Container(
                        width: double.maxFinite,
                        height: 300,
                        child: ListView.builder(
                          itemCount: noticeList.length,
                          itemBuilder: (context, index) {
                            final notice = noticeList[index];
                            return ListTile(
                              title: Text(notice.title),
                              subtitle: Text(notice.body),
                            );
                          },
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFA47DE5),
                          ),
                          child: Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/lovesollogo.png',
                width: 180.0, // Adjust the width to your desired size
                height: 100.0, // Adjust the height to your desired size
                fit: BoxFit.contain, // Adjust the fit as needed
              ),
              SizedBox(width: 0), // Adjust the amount of space between the logo and other items
            ],
          ),
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
                      borderRadius: BorderRadius.circular(20.0),
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
                                builder: (context) => PersonalPage(),
                              ));
                            },
                            child: Text(
                              '전체보기 >',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFA47DE5),
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
                        builder: (context) =>
                            MyAccountPage(
                                accountNumber: accountData["accountNumber"]),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFA47DE5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, left: 10, right: 10),
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
                                    'assets/pet5.gif',
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // Align text to the left
                                  children: [
                                    Text(
                                      "주 계좌",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.4,
                                      child: Text(
                                        '${accountData["accountNumber"] == null
                                            ? ""
                                            : formatAccountNumber(
                                            accountData["accountNumber"])}',
                                        style: TextStyle(
                                          fontSize: 16,
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
                                    '${accountData["balance"] == null
                                        ? "0"
                                        : formatCurrency(removeSosu(
                                        accountData["balance"].toString()))} 원',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFFFFFF),
                                  ),
                                  child: Text('입금',
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFA47DE5)
                                  ),
                                ),
                                ),
                                SizedBox(width: 16),
                                // Add spacing between buttons
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFFFFFF),
                                  ),
                                  child: Text('결제',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFA47DE5)
                                  ),),
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
                        builder: (context) =>
                            MyConsumePage(
                                accountNumber: accountData["accountNumber"]),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
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
                              alignment: Alignment.center,
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
                                    : Center(child: Text("소비 내역이 없어요!",
                                    style: TextStyle(fontSize: 20))),
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

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('My Page'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFA47DE5),
                ),
                child: Text('로그아웃'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFA47DE5),
                ),
                child: Text('해지하기'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<Map<String, dynamic>> accountData = [];
  Map<String, dynamic> loveBoxData = {};
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await fetchAccountData(); // 초기 데이터 로드
    await fetchLoveBoxData();
  }

  Future<void> fetchLoveBoxData() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/couple/" + userId));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    print(responseBody);
    print("여기서 체크");
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      setState(() {
        loveBoxData = Map<String, dynamic>.from(responseBody['data'][0]);
      });
      print(loveBoxData);
    } else {
      throw Exception('API 요청 실패');
    }
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
      appBar: CustomAppBar(
        title: "내 계좌",
      ),
      body: Container(
        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height:10),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyAccountPage(accountNumber: loveBoxData['accountNumber']),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFA47DE5),
                    borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '러브박스',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height:10),
                        if (loveBoxData.isNotEmpty)
                          buildAccountCard(loveBoxData, context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    child: ListView.builder(
                      itemCount: accountData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            buildAccountCard(accountData[index], context),
                            SizedBox(height: 10.0),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),

      bottomNavigationBar: buildBottomNavigationBar(context, 0),
    );

  }
}

Widget buildAccountCard(Map<String, dynamic> accountInfo, BuildContext context) {
  void _showConfirmationDialog(accountInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '커플통장으로 전환하시겠습니까?',
            style: TextStyle(
              fontSize: 18.0,  // 원하는 크기로 설정
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('예'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Couplesettingpage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA47DE5),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFDADADA),
              ),
              child: Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  String formatAccountNumber(String accountNumber) {
    if (accountNumber.length == 14) {
      return "";
    }
    if (accountNumber.length != 12) {
      return "Invalid account number";
    }

    return accountNumber.substring(0, 3) + '-' +
        accountNumber.substring(3, 6) + '-' +
        accountNumber.substring(6, 12);
  }

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyAccountPage(accountNumber: accountInfo['accountNumber'])), // 'YourNewPage'는 이동하려는 페이지의 클래스명을 나타냅니다.
      );
    },
    child: Container(
      width: double.infinity,
      // height: 150.0,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (accountInfo["accountNumber"] != null && accountInfo["accountNumber"].length != 14)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/pet5.gif', // 이미지 파일 경로
                      width: 30.0, // 이미지의 너비
                      height: 30.0, // 이미지의 높이
                    ),
                    SizedBox(width: 8.0), // 이미지와 텍스트 사이의 간격 조절
                    Text(
                      accountInfo["accountNumber"] == null ? "" : formatAccountNumber(accountInfo["accountNumber"]), // accountNumber를 표시
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              if (accountInfo["accountNumber"] != null && accountInfo["accountNumber"].length != 14)
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
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height:5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFFFFF),
                ),
                child: Text('입금',
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA47DE5)
                  ),
                ),
              ),
              SizedBox(width: 16), // Add spacing between buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFFFFF),
                ),
                child: Text('결제',
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA47DE5)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
  String userId = '';
  String coupleId = '';
  String schedule = '일정이 없어요';
  String scheduleDDay = '';
  Map<String, dynamic> petData = {};
  Map<String, dynamic> loveBoxData = {};
  Map<String, dynamic> scheduleData = {};
  bool isPaid = false;
  void initState(){
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await _loadAnniversaryData();
    await _loadScheduleData();
    await _loadPetData();
    await fetchLoveBoxData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
    coupleId = (prefs.getInt('coupleId') ?? '').toString();
  }

  Future<void> _refreshCoupleInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    final response = await http.post(Uri.parse("http://10.0.2.2:8080/api/couple/refresh/$coupleId"));
    _loadData();
  }

  Future<void> _loadAnniversaryData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
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

    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/transaction/$coupleId"));
    // 응답 데이터(JSON 문자열)를 Dart 맵으로 파싱
    Map<String, dynamic> responseData = json.decode(response.body);
    // 파싱한 데이터에서 필드에 접근
    int result = responseData["data"];
    // 필요한 작업 수행

    if (result != 0) {
      setState(() {
        isPaid = true;
        petType = result;
      });
    }
  }

  Future<void> _loadPetData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/pet/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];

    if (statusCode == 200) {
      if(responseBody['data'] == null){
        _isPaid();
      }else{
        setState(() {
          petData = Map<String, dynamic>.from(responseBody['data']);
        });
      }
    } else {
      print('펫 요청 실패');

    }
  }


  Widget buildContainer(String title, Color color, Function()? onPressed, String? centerText, Function()? onCenterTextPressed, bool isSchedule , bool isPet) {
    return GestureDetector(
      onTap: onPressed, // 위젯을 클릭했을 때 onPressed 함수 실행
      child:
      Container(
        height: 190,
        width: double.infinity,
        margin: EdgeInsets.only(left:16, right:16, top: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
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
            SizedBox(height: 10),
            if(isSchedule)
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE6DFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(width:5),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.favorite, color: Color(0xFFFF0000), size: 100.0),
                          Text(scheduleData.isNotEmpty ? "+" + dday : "ㅜ_ㅜ", style: TextStyle(color: Colors.white , fontSize: 18)),
                        ],
                      ),
                      SizedBox(width: 15), // 이미지와 텍스트 사이 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheduleData.isNotEmpty ? scheduleData["content"] : "아직 약속이 없어요",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            scheduleData.isNotEmpty ? '다음 약속까지 ${scheduleData["remainingDay"]}일 남았어요' : "이번 주말 데이트 어때요?", // Exp 텍스트 추가
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFA47DE5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 10),
            if (isPet)
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 200,
                        width: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE6DFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
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
        var decode = utf8.decode(response.bodyBytes);
        Map<String, dynamic> responseBody = json.decode(decode);
        int statusCode = responseBody['statusCode'];

        if (statusCode == 200) {
          setState(() {
            petData = Map<String, dynamic>.from(responseBody['data']);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: TextField(
            decoration: InputDecoration(
          hintText: '펫에게 이름을 지어주세요',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors
                .deepPurple),
          ),
            ),
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
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFDADADA),
              ),
              child: Text('취소',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA47DE5),
                ),),
            ),

            TextButton(
              onPressed: () {
                _registPet();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA47DE5),
              ),
              child: Text('확인',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),),
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

  Future<void> fetchLoveBoxData() async {
    print('fetchLoveBoxData');
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");
    print(userId);

    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/couple/" + userId.toString()));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];
    if (statusCode == 200) {
      setState(() {
        loveBoxData = Map<String, dynamic>.from(responseBody['data'][0]);
      });
      print(loveBoxData);
    } else {
      throw Exception('API 요청 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "러브박스",
      ),
      body:
      Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAccountPage(accountNumber: loveBoxData['accountNumber'])), // 'YourNewPage'는 이동하려는 페이지의 클래스명입니다.
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                  color: Color(0xFFA47DE5),
                    borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.only(left: 18), // Adjust left padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align to the start (left side)
                      mainAxisAlignment: MainAxisAlignment.start, // Align to the start (top side)
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우로 나란히 정렬
                          children: [
                            Image.asset(
                              'assets/lovebox.png',
                              width: 100,
                              height: 50,
                            ),
                            IconButton(
                              onPressed: () async {
                                await _refreshCoupleInfo();
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 27, // 아이콘 크기 조절
                                color: Colors.white, // 아이콘 색상 설정
                              ),
                            ),
                          ],
                        ),
                        if (loveBoxData.isNotEmpty)
                          buildAccountCard(loveBoxData, context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                      '펫에게 이름을 지어주세요',
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

class NoticeResDto {
  final String kind;
  final String title;
  final String body;
  final DateTime createAt;
  final String senderName;

  NoticeResDto({
    required this.kind,
    required this.title,
    required this.body,
    required this.createAt,
    required this.senderName,
  });

  // JSON에서 NoticeResDto로 변환하는 팩토리 생성자
  factory NoticeResDto.fromJson(Map<String, dynamic> json) {
    return NoticeResDto(
      kind: json['kind'],
      title: json['title'],
      body: json['body'],
      createAt: DateTime.parse(json['createAt']),
      senderName: json['senderName'],
    );
  }
}

