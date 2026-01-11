import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;

/*background notification handler*/
Future<dynamic> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Message: ${message.data}');
  }
  if (message.notification != null) {}
  return;
}

/*Handle the clicked notification.*/
Future<void> handleNotification(Map<String, dynamic> data, {bool delay = false}) async {
  switch (data['push_type']) {
    /*  case '5':
      Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
      break;
    case '6':
      Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
      break;*/
    default:
      break;
  }
}

class PushNotificationService {
  dynamic message;

  /*It is assumed that all messages contain a data field with the key 'type'*/
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    /*This function is called when the app is in the background and user clicks on the notification*/
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      this.message = message.data;
      handleNotification(message.data);
    });

    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
          // this.message = message?.data;
          if (message?.data.isNotEmpty ?? false) {
            Future.delayed(const Duration(milliseconds: 900)).then((value) => handleNotification(message!.data));
          }
        });
      },
    );

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    // flutter_local_notifications plugin
    final fln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    fln.FlutterLocalNotificationsPlugin();

    // 1) Create booking channel with custom sound
    const fln.AndroidNotificationChannel bookingChannel = fln.AndroidNotificationChannel(
      'booking', // must match backend android.channelId
      'Booking Notifications',
      description: 'Channel for booking alerts',
      importance: fln.Importance.max,
      playSound: true,
      sound: fln.RawResourceAndroidNotificationSound('booking'),
      //bypassDnd: true,
    );

    // Also keep your high importance channel if used elsewhere
    const fln.AndroidNotificationChannel highImportanceChannel = fln.AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: fln.Importance.max,
    );

    // Register channels with the plugin
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(bookingChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(highImportanceChannel);

    // 2) Initialize plugin
    var androidSettings = const fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const fln.DarwinInitializationSettings(
      requestSoundPermission: false,
      requestAlertPermission: false,
    );
    var initSettings = fln.InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    // 3) Background handler (safe to keep)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4) Foreground message: show local notification using the 'booking' channel and sound
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message == null) return;
      if (message.notification == null && message.data.isEmpty) return;

      final notification = message.notification;
      // Use provided channel id from payload (if any), fallback to booking
      final channelId = message.data['android_channel_id'] ?? 'booking';

      // Android details (explicitly set sound and channel)
      final fln.AndroidNotificationDetails androidDetails = fln.AndroidNotificationDetails(
        channelId,
        'Booking Notifications',
        channelDescription: 'Channel for booking alerts',
        importance: fln.Importance.max,
        priority: fln.Priority.high,
        playSound: true,
        sound: fln.RawResourceAndroidNotificationSound('booking'),
        icon: '@mipmap/ic_launcher',
      );

      // iOS details (sound name must include extension)
      final fln.DarwinNotificationDetails iOSDetails = const fln.DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        sound: 'booking.wav',
      );

      final fln.NotificationDetails platformDetails =
      fln.NotificationDetails(android: androidDetails, iOS: iOSDetails);

      // show local notification so sound plays in foreground
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title ?? message.data['title'],
        notification?.body ?? message.data['body'],
        platformDetails,
        payload: jsonEncode(message.data),
      );
    });
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        // description
        importance: Importance.max,
      );

  Future onDidReceiveNotificationResponse(NotificationResponse? notificationResponse) async {
    if (message != null) {
      handleNotification(message);
    }
  }

  /* Handle the clicked notification.*/
  Future<void> handleNotification(Map<String, dynamic> data, {bool delay = false}) async {
    message = data;
    switch (message['push_type']) {
      /* case '5':
        Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
        if (tabController != null) {
          tabController?.animateTo(1);
        }
        break;
      case '6':
        Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
        if (tabController != null) {
          tabController?.animateTo(1);
        }
        break;*/
      default:
        break;
    }
  }
}
