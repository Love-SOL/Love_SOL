import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/homePage.dart';
import 'loginPage.dart'; // 로그인 페이지 임포트
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


// Firebase 및 FCM 초기화 함수
Future<void> initializeFirebase() async {
  final FirebaseOptions firebaseOptions = DefaultFirebaseOptions.currentPlatform;

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

    if(kind == "0"){
      navigatorKey.currentState?.push(MaterialPageRoute(builder:(context) => LoginPage2()));
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
      home: LoginPage(),
      // 처음 실행되는 페이지 설정 (예: 로그인 페이지)
    );
  }
}

class LoginPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showConfirmationDialog(context); // Show confirmation dialog
          },
          child: Text('Switch to Joint Account'),
        ),
      ),
    );
  }
}


Future<void> _showConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('러브박스'),
        content: Text('러브박스 초대를 수락하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('예'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('아니오'),
          ),
        ],
      );
    },
  );
}