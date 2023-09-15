import 'package:flutter/material.dart';
import './widget/ChatbotWidget.dart';
import './widget/BottomNav.dart';

class PetPage extends StatefulWidget {
  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  String chatBotResponse = '안녕! 난 petName이야, 데이트 장소 추천해줄게!';

  void updateChatBotResponse(String response) {
    setState(() {
      chatBotResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        elevation: 0,
        title: Text(
          "펫",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/personicon.png'),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Image.asset('assets/bellicon.png'),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
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
                              'assets/bear1.gif',
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