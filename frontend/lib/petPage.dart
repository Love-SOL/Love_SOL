import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widget/ChatbotWidget.dart';
import './widget/BottomNav.dart';
import 'package:http/http.dart' as http;
import './widget/Appbar.dart';

class PetPage extends StatefulWidget {
  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  String chatBotResponse = '안녕! 난 럽쏠이야, 데이트 장소 추천해줄게!';
  String petImage = "assets/bear4.gif";
  Map<String, dynamic> petData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadPetData();
  }

  Future<void> _loadPetData() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleId = prefs.getInt("coupleId");
    print(coupleId);
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/api/pet/$coupleId"));

    var decode = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseBody = json.decode(decode);
    int statusCode = responseBody['statusCode'];
    print(statusCode);
    print("펫 조회합니당");
    if (statusCode == 200) {
      setState(() {
        petData = Map<String, dynamic>.from(responseBody['data']);
        chatBotResponse = "안녕 난 ${petData['name']}이야, 데이트 장소 추천해줄게!";
        petImage = "assets/pet${petData['kind']}.gif";
      });
      print(petData);
    } else {
      print('펫 요청 실패');
    }
  }
  void updateChatBotResponse(String response) {
    setState(() {
      chatBotResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: CustomAppBar(
    title: "펫",
    ),
    body:Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded( // 이미지 영역
                            flex: 5,
                            child: Image.asset(
                              petImage,
                            ),
                          ),
                          Expanded( // 말풍선 영역
                            flex: 5,
                            child:
                            Container(
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Color(0xFF0466FF),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                ),
                              ),
                              child: Text(
                                chatBotResponse,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Container(
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
                        padding: const EdgeInsets.all(16.0),
                        child: ChatBotApp(
                          onMessageReceived: updateChatBotResponse,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

        bottomNavigationBar: buildBottomNavigationBar(context, 3)
    );
  }
}