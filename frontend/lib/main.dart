import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/homePage.dart';
import 'loginPage.dart'; // 로그인 페이지 임포트
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _saveFcmData(String fcmToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcmToken', fcmToken);
  print(fcmToken);
}

// Firebase 메시지 백그라운드 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('FCM 메시지 (백그라운드) 받음: ${message.notification?.title}');
  print('FCM 메시지 (백그라운드) 내용: ${message.notification?.body}');
}


Future<void> shareCouple(String receiver, String senderId, int check) async {
  try {
    print(receiver);
    print(senderId);
    print(check);
    print("sadasdadas");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/couple/share/$senderId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'subOnwerId': receiver,
        'check': check,
      }),
    );

    Map<String, dynamic> responseData = json.decode(response.body);
    int statusCode = responseData['statusCode'];

    if (statusCode == 200) {
      print("수락 혹은 반대 성공");
    } else {
      print(statusCode);
      // 로그인 실패 처리
    }
  } catch (e) {
    print("에러발생 $e");
  }
}

// Firebase 및 FCM 초기화 함수
Future<void> initializeFirebase() async {
  final FirebaseOptions firebaseOptions = DefaultFirebaseOptions.currentPlatform;

  Future<void> _saveCoupleData(int coupleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coupleId', coupleId);
  }

  Future<void> _showConfirmationDialog(String receiver, String senderId, String coupleId) async {
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return AlertDialog(
          title: Text('러브박스'),
          content: Text('러브박스 초대를 수락하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await shareCouple(receiver, senderId, 0);
                await _saveCoupleData(coupleId as int);
                Navigator.of(context).pop();
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () async {
                await shareCouple(receiver, senderId, 1);
                Navigator.of(context).pop();
              },
              child: Text('아니오'),
            ),
          ],
        );
      },
    );
  }
  try {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    print('Firebase initialized');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  final fcmToken = await FirebaseMessaging.instance.getToken();

  // 백그라운드에서 FCM 메시지 처리 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 앱이 실행 중일 때 FCM 메시지 처리 핸들러 등록
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final kind = message.data["kind"];
    if (kind == "0") {
      print(message.data);
      _showConfirmationDialog(message.data["receiverId"], message.data["senderId"], message.data["coupleId"]);
    }
    // FCM 메시지를 푸시 알림으로 표시
    FlutterLocalNotification.showNotification(
        message.notification?.title ?? 'Notification Title',
        message.notification?.body ?? 'Notification Body');
  });
  // 앱이 백그라운드에서 실행 중일 때 FCM 메시지 처리 핸들러 등록
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('FCM 메시지 (앱이 백그라운드에서 실행) 받음: ${message.notification?.title}');
    print('FCM 메시지 (앱이 백그라운드에서 실행) 내용: ${message.notification?.body}');
    FlutterLocalNotification.showNotification(
        message.notification?.title ?? 'Notification Title',
        message.notification?.body ?? 'Notification Body');
    final kind = message.data["kind"];
    if (kind == "0") {
      print(message.data);
      _showConfirmationDialog(message.data["receiverId"], message.data["senderId"], message.data["coupleId"]);
    }
  });

  print(fcmToken);
  _saveFcmData(fcmToken!);
}

void main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebase();
    FlutterLocalNotification.init();
    runApp(MyApp());
  }catch(e){
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love SOL',
      theme: ThemeData(
        fontFamily: "Shinhan",
      ),
      navigatorKey: navigatorKey,
      home: LoginPage(), // 처음 실행되는 페이지 설정 (예: 로그인 페이지)
    );
  }
}
//
// class LoginPage2 extends StatelessWidget {
//   LoginPage2() {
//     _showConfirmationDialog(); // 클래스가 생성되면 바로 다이얼로그 표시
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // 다른 작업 수행
//           },
//           child: Text('Switch to Joint Account'),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showConfirmationDialog() async {
//     return showDialog(
//       context: navigatorKey.currentState!.overlay!.context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('러브박스'),
//           content: Text('러브박스 초대를 수락하시겠습니까?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('예'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('아니오'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
