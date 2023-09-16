import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyAccountPage extends StatefulWidget {
  final String accountNumber;

  MyAccountPage({required this.accountNumber});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  Map<String, dynamic> accountData = {};
  String accountNumber = '';
  List<GetTransactionResponseDto> transactions = [];



  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchData();
  }

  String userId = '';
  Future<void> _loadUserDataAndFetchData() async {
    await _loadUserData(); // 사용자 데이터 로드를 기다립니다.
    await fetchAccountData(widget.accountNumber); //
    await fetchTransactionData(widget.accountNumber);
  }
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('userId') ?? '').toString();
  }

  Future<void> fetchAccountData(String accountNumber) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/account/"+ accountNumber + "/info"));

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

  Future<void> fetchTransactionData(String accountNumber) async{
    print(accountNumber);
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/account/transaction/$accountNumber/0'), // 스키마를 추가하세요 (http 또는 https)
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
        setState(() {
          transactions = data.map((model) => GetTransactionResponseDto.fromJson(model)).toList();
        });
        print(transactions);

      } else {
        print(statusCode);
        // 실패
      }
    } catch (e) {
      print("에러발생 $e");
    }
  }

  String formatLocalDateTime(String localDateTimeStr) {
    DateTime parsedDate = DateTime.parse(localDateTimeStr.replaceAll('T', ' '));
    return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";
  }

  String formatCurrency(String amountStr) {
    int amount = int.parse(amountStr);
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'ko_KR'); // locale에 따라 적절한 포맷을 선택할 수 있습니다.
    return formatCurrency.format(amount).substring(1); // '₩' 기호 제거
  }

  String removeSosu(String amount){
    return amount.substring(0, amount.length-2);
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
          "거래내역조회",
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
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE4ECFF),
                    borderRadius: BorderRadius.circular(0),
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
                                padding: const EdgeInsets.all(0),
                                child: Image.asset(
                                  'assets/shinhanlogo.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${accountData['type'] == 0 ? "주 계좌" : "커플 통장" }", // Display account type here
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Text(
                                      '${accountData["accountNumber"] == null ? "0" : formatAccountNumber(accountData["accountNumber"])}',
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
                                  '${accountData["balance"] == null ? "" : formatCurrency(removeSosu(accountData["balance"].toString()))} 원',
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
            Expanded(
              flex: 5,
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(0),
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
                          '거래 내역',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final transaction = transactions[index];

                              Color transactionColor;
                              String transactionSign;

                              if (transaction.transactionType == 0) {
                                transactionColor = Colors.red;
                                transactionSign = '-';
                              } else {
                                transactionColor = Colors.blue;
                                transactionSign = '+';
                              }

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 8),
                                          Text(
                                            transaction.content,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$transactionSign${formatCurrency(transaction.transactionAmount.toString())}원',  // 거래액 앞에 +/- 기호 동적 추가
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: transactionColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 8),
                                      Text(
                                        formatLocalDateTime(transaction.transactionAt.toString()),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
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
                        )
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemBuilder: (BuildContext context, int index) {
                        //       return Column(
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   SizedBox(width: 8),
                        //                   Text(
                        //                     '가게이름',
                        //                     style: TextStyle(
                        //                       fontSize: 18,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: Colors.black,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Text(
                        //                 '원',
                        //                 style: TextStyle(
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.normal,
                        //                   color: Colors.black,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Divider(
                        //             color: Colors.grey,
                        //             thickness: 1,
                        //           ),
                        //           SizedBox(height:16),
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),
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
}

class GetTransactionResponseDto {
  final String content;
  final int transactionType;
  final int transactionAmount;
  final String transactionAt; // LocalDateTime을 Dart에서는 String으로 처리

  GetTransactionResponseDto({
    required this.content,
    required this.transactionType,
    required this.transactionAmount,
    required this.transactionAt,
  });

  factory GetTransactionResponseDto.fromJson(Map<String, dynamic> json) {
    return GetTransactionResponseDto(
      content: json['content'],
      transactionType: json['transactionType'],
      transactionAmount: json['transactionAmount'],
      transactionAt: json['transactionAt'],
    );
  }
}