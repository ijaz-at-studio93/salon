import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/util/app_snackbar.dart';
// 👇 NEW
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // to access flutterLocalNotificationsPlugin

class NotificationUtils {
  // 👇 NEW: plays custom sound on Android foreground using channel 'booking'
  static Future<void> _showForegroundNotification(RemoteMessage msg) async {
    final titleRaw = msg.notification?.title ?? msg.data['title'] ?? '';
    final title = titleRaw.toString();
    final pushType = (msg.data['push_type'] ?? '').toString().toLowerCase();
    final payloadChannelId = msg.notification?.android?.channelId ??
        msg.data['android_channel_id']?.toString() ??
        msg.data['channel_id']?.toString();
    final payloadSound = msg.notification?.android?.sound ??
        msg.data['sound']?.toString();

    final isBookingReceived = pushType == 'booking_received' ||
        pushType == 'appointment_received' ||
        pushType == 'new_booking' ||
        payloadChannelId == 'booking' ||
        payloadSound == 'booking' ||
        title.toLowerCase().contains('received') ||
        title.toLowerCase().contains('new appointment') ||
        title.toLowerCase().contains('new booking');

    final AndroidNotificationDetails androidDetails = isBookingReceived
        ? const AndroidNotificationDetails(
            'booking',
            'Appointment Received',
            channelDescription: 'Custom sound when appointment is Received',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('booking'),
          )
        : const AndroidNotificationDetails(
            'general_silent',
            'General (Silent)',
            channelDescription: 'General notifications without sound',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
            enableVibration: false,
          );

    final DarwinNotificationDetails iosDetails = isBookingReceived
        ? const DarwinNotificationDetails(
            sound: 'booking.wav',
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          )
        : const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: false,
            presentBadge: true,
          );

    final notifDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      msg.notification?.body ?? msg.data['message'] ?? '',
      notifDetails,
      payload: msg.data['appointmentId'],
    );
  }

  static handleNotificationOnForeground(RemoteMessage remoteMessage) async {
    // 🔔 NEW: trigger local notification with custom sound (Android 8+)
    await _showForegroundNotification(remoteMessage);

    if (remoteMessage.notification != null) {
      String title = remoteMessage.data["title"] ?? "Notification";
      String message =
          remoteMessage.data['message'] ?? "You have a new notification";
      debugPrint('Notification $remoteMessage');
      //_stylistController.doPendingAppointmentsListModel();
      showAppSnackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        leading: const Icon(Icons.notifications, color: Colors.white),
        onTap: () {
          Get.back();
          handleNotificationNavigation(remoteMessage, false);
        },
      );
    }
  }

  static Future<bool> handleNotificationOnAppOpened(
      {RemoteMessage? remoteMessage, bool isAppKilled = false}) async {
    try {
      remoteMessage ??= await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null && remoteMessage.notification != null) {
        handleNotificationNavigation(remoteMessage, isAppKilled);
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  static bool handleNotificationNavigation(
      RemoteMessage remoteMessage, bool isAppKilled) {
    if (remoteMessage.data.isNotEmpty) {
      var data = remoteMessage.data;
      var type = data['push_type'];

      /*if (isAppKilled) {
        Get.to(() => SplashPage(remoteMessage: remoteMessage));
      } else {*/
      navigateNotification(type, data);
      // }
    }
    return false;
  }

  static void navigateNotification(String type, Map<String, dynamic> data) {
    switch (type) {
      /* case '5':
        Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
        break;
      case '6':
        Get.to(() => const ReferAndEarnPage(isNotificationClick: true));
        break;*/
      default:
        // Get.offAll(() => const SplashPage());
        break;
    }
  }
}
