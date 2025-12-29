

import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/ui/screens/bottom_navigation/chat_list/chat_room/chat_screen.dart';
import 'package:chat_app/ui/screens/bottom_navigation/profile/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../ui/screens/home/home_screen.dart';
import '../constants/string.dart';
import 'package:http/http.dart' as http;


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotification();
  await NotificationService.instance.showNotification(message);

}



class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  String? mtoken = "";

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
 
  Future<void> initialize() async {

    await _requestPermission();
    await setupFlutterNotification();

    await _setupMessageHandlers();

    

    final token = await _messaging.getToken();
    mtoken = token;
    print('FCM Token: $token');



    subscribeToTopic('all_devices');

  }

  Future<void> _requestPermission() async {
    final setting = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false);
    print('Permission status:${setting.authorizationStatus}');
  }

    Future<void> setupFlutterNotification() async {

      if(_isFlutterLocalNotificationsInitialized){
        return;
      }
      //// android setup
      const channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notification',
        description: 'This channel is used for impotant notifications.',
        importance: Importance.high);

        await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

        const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

        /// ios set up
        final initializationSettingsDarwin = DarwinInitializationSettings();

        final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

        await _localNotifications.initialize(initializationSettings,onDidReceiveNotificationResponse: (details) {
          if(details.payload == 'chat') {

            log('clicked');
             navigatorKey.currentState?.push(MaterialPageRoute(builder: (ctx) {
  return Scaffold(
    appBar: AppBar(
      title: Text('notification clicked'),
    ),
  );
}));
          }
        },);

        _isFlutterLocalNotificationsInitialized = true;
    }


  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if(notification != null && android != null){
      await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                'high_importance_channel', 'High Importance Notification',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher'),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString());
    }
  }
  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message){
      showNotification(message);
    });
    //background message

  FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

 //opened app
 final initialMessage = await _messaging.getInitialMessage();
 if(initialMessage != null){
  _handleBackgroundMessage(initialMessage);
 }
  }
   void _handleBackgroundMessage(RemoteMessage message){
    if(message.data['type'] == 'chat'){
      //open chat screen

        navigatorKey.currentState?.push(MaterialPageRoute(builder: (context)=> Scaffold(
    appBar: AppBar(
      title: Text('notification clicked'),
    ),
  )));
    }
  }

  Future<void> subscribeToTopic(String topic) async{
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print("Subscribed to $topic");

  }
  
    Future<void> sendNotification(String title,String body,String token) async{
String accessToken='ya29.c.c0ASRK0Gbl_qbo5nQiI-pVazHjv8qLUHpgVqUtEPal3RoRnxjqXnF-PE-6bses0Ej4ZoEaT8oHaUINhmXVzJF93uIfnl66JKQQ1JxUjT4WschQppn8pa5kHD9Gn2htMvlaylMcbr01yWZhBx_zB9zDDMqS9BxuGCrqjXJYibkSw3E6pdJ7gSML56gPaXc2Gq6asxyMAOaGxjTQgswJWRZLFT_-mdibyR1qxXKsbLZefJc3-mW6mTOdCqxVL20FPsrXa3PmBcpRTEpT_85hNpKqz4YXiXjdK8YUgyHo6zGKx51ocMrkesv94Key03SQJcFIGGPu5G64OS7rQsRZndtJvXSpzltmp8bh-898_RxIihYfZOXqbHFv4uJsH385ClZx0vbM1Whz15xR99Fqk4qxag_26bzSIy_9SxrIbUcwmJSsIv0Y_v6gSocove3M4jgk6u1t9d_R_7RMkd0m0mQoVhQ4cbItggZhZnjY7_k0IQn2QbJuMhnJrfcb8JFhOJ7vMksabchIskBeV5BnscWf0Zfb4b_7u7ocjY6WInyUjWRUOanRt-604RFlpS2l4q2tOdQicR-0_fiud9JQk3Zt8IxM1goB7ui1a6n9JJsyYq6sjledYfMxV5YJrlnBWnk-4IXJQkUXZ1qeMXY-34XX-pR_4RyyQ22J9YVQ4VarSW9vhOxxmUm2rcMvn5Zw6dSyB5f7xMVdfntO1r1OnwJdB3y5ui1JUIjB6Wudjw8QcsRMOU4jxUrr75Wpehqu_y8ejV5kpBRQ-V3R5ihUfolR3_5MbU4sZB1ax8khJ-noMoU7JSp-87ou0xOY84fO01iFwFVF70xvSgd-4S52x1kF2ItZzUaysh21wuroI7nqea90bSktc6_mj_cOd9glrV58lI36pYRZwe0g121Yzly4ZwSmsFSIiR94Fdqx1nsQfFun3S41h281awlzmo22J7mkmqhq1MceuS8s7IkWbR-vhYIZ9czro40j-t9MlUk4cfJaqBQpIJf7owO';
    var messagePayload = {
  "message": {
    "token": token, // Send to a specific device token
    "notification": {
      "title": title,
      "body": body
    },
    "data": {
      "type": "chat"
    },
    "android": {
      "priority": "high",
      "notification": {
        "channel_id": "high_importance_channel"
      }
    }
  }
};

//   var messagePayload1 = {
//   'message': {
//     'topic': "all_devices",
//     'notification': {
//       'title': title,
//       'body': body
//     },
//     'data': {
//       'type': "chat" // Used for navigation
//     },
//     'android': {
//       'priority': "high",
//       'notification': {
//         'channel_id': "high_importance_channel"
//       }
//     }
//   }
// };
final url = 'https://fcm.googleapis.com/v1/projects/chat-app-a309b/messages:send';

final headers = {
  'Authorization': 'Bearer $accessToken',
  'Content-Type': 'application/json'
};

final response = await http.post(
  Uri.parse(url),
  headers:headers,body:jsonEncode(messagePayload));

  if(response.statusCode == 200){
    print('notification sent succesfully');
  }else{
    print('Error sending notification: ${response.body}');
  }

}
}
