import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request permission (iOS & Android 13+)
    await _fcm.requestPermission();

    // Get the device FCM token
    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
    });
  }
}
