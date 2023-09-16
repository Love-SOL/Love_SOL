import 'package:flutter/material.dart';
import '../homePage.dart';
import '../calendarPage.dart';
import '../petPage.dart';

BottomNavigationBar buildBottomNavigationBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(color: Colors.white),
    unselectedLabelStyle: TextStyle(color: Colors.white),
    selectedItemColor: Color(0xFF0046fF),
    unselectedItemColor: Colors.grey,
    elevation: 10,
    currentIndex: currentIndex,
    onTap: (int index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalPage()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (index == 3 ) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetPage()),
        );
      } else if (index == 4 ) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CouplePage()),
    );
  }

    },
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.wallet),
        label: '내 계좌',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_note),
        label: '캘린더',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.sms),
        label: '챗봇',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: '커플',
      ),
    ],
  );
}