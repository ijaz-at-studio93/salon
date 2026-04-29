import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/home/booking_history_view_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/view_accept_page.dart';
import 'package:salon/util/shared_prefs.dart';

/* ======================== Background handler ======================== */
@pragma('vm:entry-point')
Future<dynamic> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('BG Message data: ${message.data}');
  }
  return;
}

/* ===================== Click handling (navigate) ==================== */
Future<void> handleNotification(Map<String, dynamic> data,
    {bool delay = false}) async {
  if (delay) {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  final appointmentId = _readAppointmentId(data);
  if (appointmentId.isEmpty || !_isAppointmentNotification(data)) return;

  _openAppointmentDetails(appointmentId);
}

String _readAppointmentId(Map<String, dynamic> data) {
  final value = data['appointmentId'] ??
      data['appointment_id'] ??
      data['appointmentID'] ??
      data['appointment'];

  return value?.toString() ?? '';
}

bool _isAppointmentNotification(Map<String, dynamic> data) {
  final type =
      (data['push_type'] ?? data['type'] ?? '').toString().toLowerCase();
  final title = (data['title'] ?? '').toString().toLowerCase();
  final channelId =
      (data['android_channel_id'] ?? data['channel_id'] ?? '').toString();

  return type == 'booking_received' ||
      type == 'appointment_received' ||
      type == 'new_booking' ||
      type.contains('appointment') ||
      type.contains('booking') ||
      title.contains('appointment') ||
      title.contains('booking') ||
      channelId == 'booking';
}

void _openAppointmentDetails(String appointmentId) {
  if (!SharedPrefs.readBoolValue(PrefConstants.isUserLogin)) return;

  if (SharedPrefs.readBoolValue(PrefConstants.isSalon)) {
    Get.to(
      () => BookingHistoryViewpage(
        appointmentId: appointmentId,
        status: 'pending',
      ),
    );
    return;
  }

  if (Get.isRegistered<StylistController>()) {
    Get.find<StylistController>().doAppointmentsDetailsModel(
      appointmentId: appointmentId,
    );
  }
  Get.to(() => ViewAcceptPage(appointmentId: appointmentId));
}

/* =========================== Service ================================ */
class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    // Firebase is already initialized in main() before this is called.
    // Tapped while app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(message.data);
    });

    // Tapped when app was terminated
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final RemoteMessage? initial =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initial?.data.isNotEmpty ?? false) {
        await Future.delayed(const Duration(milliseconds: 900));
        handleNotification(initial!.data, delay: true);
      }
    });

    // Permissions (Android 13+ & iOS)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // iOS: suppress FCM's native foreground banner — NotificationUtils renders
    // one local notification ourselves (custom channel/sound). Leaving these
    // true would cause two banners on foreground.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }
}
