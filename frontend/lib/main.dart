import 'package:flutter/material.dart';
import 'loginPage.dart'; // 로그인 페이지 임포트
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveFcmData(String fcmToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcmToken', fcmToken);
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
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  FlutterLocalNotification.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love SOL',
      home: LoginPage(), // 처음 실행되는 페이지 설정 (예: 로그인 페이지)
    );
  }
}
