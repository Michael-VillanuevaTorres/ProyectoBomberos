import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification?.title);
}

bool isFlutterLocalNotificationsInitialized = false;

class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    //if (message == null) return;
    //navigatorKey.currentState?
    print('Handling a background message ${message?.messageId}');
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );

    firebaseMessaging.getInitialMessage().then((message) {
      handleMessage(message);
    });
    // Apliacion en 2do plano y se toca la notificacion
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("fev ${message.notification}");
    });
    // Cuando se recibe el mensaje
    FirebaseMessaging.onMessage.listen((message) {
      showFlutterNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            //icon: '@drawable/ic_launcher',
          ),
        ),
      );
    }
  }

  Future<void> initLocation() async {
    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("mipmap/ic_launcher"));
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        //print("fev ${notificationResponse.payload.toString()}");
      },
      //onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    final platForm =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platForm?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((value) => print(value));
    initPushNotification();
    initLocation();
  }
}
