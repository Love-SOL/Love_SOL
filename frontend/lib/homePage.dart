import 'package:flutter/material.dart';
import 'coupleSettingPage.dart';
import 'calendarPage.dart';
import 'petPage.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;

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
            icon: Image.asset('personicon.png'),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('bellicon.png'),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF7F7F7),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex : 1,
              child:
                  GestureDetector(
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
              flex:2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0046FF),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '개인',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex : 3,
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
                        '빈공간',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color : Colors.white,
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
              // 아이콘을 눌렀을 때 수행할 작업 추가
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

class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showConfirmationDialog() {
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

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        height: 150,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7), // 배경색
          borderRadius: BorderRadius.circular(10), // 박스 모양 설정
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 그림자 색상
              spreadRadius: 2, // 그림자 확장 정도
              blurRadius: 5, // 그림자 흐릿한 정도
              offset: Offset(0, 2), // 그림자 위치 (x, y)
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 수직 정렬을 가운데로 변경
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 텍스트를 왼쪽, 버튼을 오른쪽 정렬
              children: [
                Text(
                  '개인통장',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showConfirmationDialog, // 확인 창을 띄우는 함수 호출
                  icon: Icon(Icons.arrow_forward), // 아이콘 추가
                  label: Text(''), // 텍스트 없이 공백으로 설정
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '100,000원',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouplePage extends StatelessWidget {
  // 공통으로 사용하는 컨테이너 생성 함수
  Widget buildContainer(String title, Color color, Function()? onPressed) {
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
          // 이 컨테이너에 대한 추가 디자인 요소 추가
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          buildContainer('커플통장', Color(0xFFF7F7F7), null), // 첫 번째 컨테이너
          SizedBox(height: 3),
          buildContainer(
            'Calender',
            Color(0xFFF7F7F7),
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CalendarPage(), // CalenderPage로 이동
                ),
              );
            },
          ),
          SizedBox(height: 3),
          buildContainer(
            'Pet',
            Color(0xFFF7F7F7),
            () {
              // Calender 페이지로 이동하는 코드
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PetPage(), // CalenderPage로 이동
                ),
              );
            },
          ), // 두 번째 컨테이너 (버튼 추가) // 세 번째 컨테이너 (예시)
        ],
      ),
    );
  }
}
