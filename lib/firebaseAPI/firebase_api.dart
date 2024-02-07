import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    print(message.notification?.title);
  }

  void initLocalNotification() async {
    final InitializationSettings initializationSettings =
        //Tên icon của ứng dụng
        //copy icon vào 2 file drawable và drawable-v21
        //android>src>main>res>drawable
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/launcher_icon"));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) {
      // switch (notificationResponse.notificationResponseType) {
      //   case NotificationResponseType.selectedNotificationAction:
      //     selectNotificationStream.add(notificationResponse.payload);
      //     break;
      //   case NotificationResponseType.selectedNotification:
      //     if (notificationResponse.actionId == navigationActionId) {
      //       selectNotificationStream.add(notificationResponse.payload);
      //     }
      //     break;
      // }
      print("notificationResponse ${notificationResponse.payload}");
    });
  }

  initPushNotification() {
    _firebaseMessaging.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'Nguyen_Van_Hien', // id
      'Nguyen Van Hien Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: jsonEncode(message.toMap()),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/launcher_icon',
          ),
        ),
      );
    }
  }

  Future<String> getDeviceToken() async {
    return await _firebaseMessaging.getToken() ?? "";
  }

  initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("DEVIDE TOKEN: $fcmToken");
    await setupFlutterNotifications();
    initLocalNotification();
    initPushNotification();
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      String url = "https://fcm.googleapis.com/fcm/send";
      final headers = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAyZkQg8c:APA91bH8jM-lcGLxNk3_TItdtW7LVc95Qgt-CUQt7FDw1EqhjmObMRT_IpUrdTEemyWjkb0L7Ym532Yn-zDH7hda6vMq1GumCAk733bv602Ij80HnNTmqz5BlXHwgiBEAbsODy-11amC"
      };

      await http
          .post(Uri.parse(url),
              body: jsonEncode({
                "priority": "high",
                "data": <String, dynamic>{
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "status": "done",
                  "body": body,
                  "title": title,
                },
                "notification": <String, dynamic>{
                  "title": title,
                  "body": body,
                  "android_channel_id": "Nguyen_Van_Hien"
                },
                "to": token,
              }),
              headers: headers)
          .then((value) => {print("Message sent...")})
          .catchError((e) => {print(e)});
    } catch (e) {
      print(e);
    }
  }
}
