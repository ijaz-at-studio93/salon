import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  // Data-only FCM messages on iOS are delivered to this handler but won't
  // show a system banner on their own — we must post a local notification.
  // Messages that include a `notification` payload are already displayed by
  // APNs automatically, so we skip those to avoid duplicates.
  if (Platform.isIOS &&
      message.notification == null &&
      message.data.isNotEmpty) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    final data = message.data;
    final title = data['title']?.toString() ?? 'New Notification';
    final body = data['message']?.toString() ?? data['body']?.toString() ?? '';
    final pushType =
        (data['push_type'] ?? data['type'] ?? '').toString().toLowerCase();
    final channelId =
        (data['android_channel_id'] ?? data['channel_id'] ?? '').toString();
    final isBooking = pushType.contains('booking') ||
        pushType.contains('appointment') ||
        pushType.contains('cancel') ||
        channelId == 'booking';

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        iOS: DarwinNotificationDetails(
          sound: isBooking ? 'booking.wav' : null,
          presentAlert: true,
          presentBadge: true,
          presentSound: isBooking,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  return;
}

/* ===================== Click handling (navigate) ==================== */

/// Merges FCM notification fields into the data map so callers that only
/// have [RemoteMessage.data] don't lose the notification title/body.
Map<String, dynamic> mergeMessageData(RemoteMessage message) {
  return {
    ...message.data,
    if (message.notification?.title != null &&
        !message.data.containsKey('title'))
      'title': message.notification!.title,
    if (message.notification?.body != null &&
        !message.data.containsKey('message') &&
        !message.data.containsKey('body'))
      'body': message.notification!.body,
  };
}

Future<void> handleNotification(Map<String, dynamic> data,
    {bool delay = false}) async {
  if (delay) {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  final appointmentId = _readAppointmentId(data);

  // Tray taps only carry message.data, so the FCM notification title/channel
  // are absent. If we have an appointment ID, that's enough to navigate.
  if (appointmentId.isEmpty) return;

  _openAppointmentDetails(appointmentId, data);
}

String _firstNonEmptyString(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null) continue;
    final s = value.toString().trim();
    if (s.isNotEmpty) return s;
  }
  return '';
}

String _readAppointmentId(Map<String, dynamic> data) {
  return _firstNonEmptyString(data, const [
    'salonAppointmentId',
    'appointmentId',
    'appointment_id',
  ]);
}

void _openAppointmentDetails(
  String appointmentId, [
  Map<String, dynamic>? data,
]) {
  if (!AppLaunchGate.isReady) {
    AppLaunchGate.hold({
      ...?data,
      'appointmentId': appointmentId,
    });
    return;
  }

  if (SharedPrefs.readBoolValue(PrefConstants.isSalon)) {
    // `status` is a non-nullable String on the page, and a payload is not
    // obliged to carry one — deep links usually don't.
    final rawStatus = _firstNonEmptyString(data ?? const {}, const ['status']);
    final status = rawStatus.isEmpty
        ? 'pending'
        : rawStatus == 'cancelled'
            ? 'Cancel'
            : rawStatus;
    Get.to(
      () => BookingHistoryViewpage(
        appointmentId: appointmentId,
        status: status,
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

/* ====================== Deferred destinations ======================= */

/// Holds a destination that arrived before the app could show it.
///
/// A deep link or a notification tap can land during the splash screen's
/// version check, or while the user is signed out. Navigating straight away is
/// lost in both cases: the splash finishes with a `pushAndRemoveUntil` that
/// clears the stack, and a signed-out user has no home screen to push onto.
/// This matters most for deferred OneLinks, which fire moments after a fresh
/// install when the user has certainly not signed in yet.
///
/// The two bottom bar pages call [markRouted] once they are on screen, which
/// releases whatever is held — covering the cold-start path (splash to bottom
/// bar) and the sign-in path (login to bottom bar) with one hook.
///
/// Only the most recent destination is kept; if two links arrive before the
/// app is ready, opening the last one tapped is the better guess.
class AppLaunchGate {
  AppLaunchGate._();

  static bool _routed = false;
  static Map<String, dynamic>? _held;

  static bool get isReady =>
      _routed && SharedPrefs.readBoolValue(PrefConstants.isUserLogin);

  static void hold(Map<String, dynamic> data) => _held = data;

  static void markRouted() {
    _routed = true;
    _release();
  }

  /// Called on sign-out so a link held under one account cannot open under the
  /// next one.
  static void reset() {
    _routed = false;
    _held = null;
  }

  static void _release() {
    final held = _held;
    if (held == null || !isReady) return;
    _held = null;
    // The bottom bar is still building when this runs, so let its Navigator
    // settle before pushing on top of it.
    handleNotification(held, delay: true);
  }
}

/* =========================== Service ================================ */
class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    // Firebase is already initialized in main() before this is called.
    // Tapped while app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(mergeMessageData(message));
    });

    // Tapped when app was terminated
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final RemoteMessage? initial =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null &&
          (initial.data.isNotEmpty || initial.notification != null)) {
        await Future.delayed(const Duration(milliseconds: 900));
        handleNotification(mergeMessageData(initial), delay: true);
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
