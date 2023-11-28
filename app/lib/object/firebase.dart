import 'dart:convert';
import 'dart:ui';
import 'package:app/main.dart';
import 'package:app/pages/notifications.dart';
import 'package:app/pages/widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Función que maneja la recepción de mensajes en segundo plano
Future<void> backgroundHandler(RemoteMessage message) async {
  //print(message.data.toString());
  //print(message.notification?.title);
}

const uses = {
  "Single_use": "Uso común",
  "Maintenance": "Mantención",
  "Repair": "Reparación"
};

Widget textAlert(String label, String value) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      Text(value),
    ],
  );
}

// Clase que encapsula la lógica de Firebase y notificaciones locales
class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Configuración de canal de notificaciones para Android
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    //navigatorKey.currentState?.pushNamed(notification.route);
  }

  // Método para inicializar las notificaciones push
  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );

    firebaseMessaging.getInitialMessage();

    // Manejo de mensajes cuando la aplicación está en segundo plano y se toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    // Manejo de mensajes cuando la aplicación está en primer plano
    FirebaseMessaging.onMessage.listen((message) {
      //handleMessage(message);
      showFlutterNotification(message);
    });

    // Manejo de mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  // Método para mostrar una notificación local con FlutterLocalNotificationsPlugin
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

  // Método para inicializar la configuración de localización de notificaciones
  Future<void> initLocation() async {
    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("mipmap/ic_launcher"));
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Lo que se ejecutaá si el usuario toca la notificación
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        navigatorKey.currentState?.pushNamed(notification.route);
        showAlertDialog(notificationResponse.payload!);
      },
    );
    final platForm =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platForm?.createNotificationChannel(_androidChannel);
  }

  // Método para inicializar las notificaciones
  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((value) => print(value));
    initPushNotification();
    initLocation();
  }
}

void showAlertDialog(String? payload) {
  Map<String, dynamic> jsonMap = json.decode(payload!);

  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textAlert(
                  "Autor: ",
                  jsonMap['data'][
                      'user']), //jsonMap['data']?['user_id']), //item.userId.toString()),
              textAlert(
                  "Fecha: ", jsonMap['data']['date_time']), //item.dateTime),
              textAlert("Unidad: ",
                  jsonMap['data']['truck_patent']), //item.truckPatent),
              jsonMap['data']['type'] == "Single_use"
                  ? textAlert("Tipo: ", "Uso común")
                  : jsonMap['data']['type'] == "Maintenance"
                      ? textAlert("Tipo: ", "Mantención")
                      : textAlert("Tipo: ", "Reparación"),
              textAlert(
                  "Nivel de combustible: ",
                  transformTodouble(jsonMap['data']
                      ['fuel_level'])), //item.fuelLevel.toString()),
              textAlert(
                  "Nivel de aceite: ",
                  transformTodouble(jsonMap['data']
                      ['oil_level'])), //item.waterLevel.toString()),
              textAlert(
                  "Nivel de agua: ",
                  transformTodouble(jsonMap['data']
                      ['water_level'])), //item.oilLevel.toString()),
              const Text(
                "Observación:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(jsonMap['data']['description']),
            ],
          ),
        ),
      );
    },
  );
}
