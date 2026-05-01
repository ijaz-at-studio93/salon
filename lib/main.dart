import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/splash_page.dart';
import 'package:salon/util/NotificationUtils.dart';
import 'package:salon/util/notification_service.dart';
import 'package:salon/util/shared_prefs.dart';

import 'api/dio_client.dart';
import 'controller/auth_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> requestDndAccess() async {
  if (await Permission.accessNotificationPolicy.isDenied) {
    await Permission.accessNotificationPolicy.request();
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _setupAndroidChannels() async {
  // booking (sound)
  const AndroidNotificationChannel booking = AndroidNotificationChannel(
    'booking',
    'Appointment Received',
    description: 'Custom sound when appointment is Received',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    sound:
        RawResourceAndroidNotificationSound('booking'), // res/raw/booking.wav
  );

  // General/Silent (for booked)
  const AndroidNotificationChannel generalSilent = AndroidNotificationChannel(
    'general_silent',
    'General (Silent)',
    description: 'General notifications without sound',
    importance: Importance.defaultImportance,
    playSound: false, // 👈 silent
    enableVibration: false,
  );

  final impl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await impl?.createNotificationChannel(booking);
  await impl?.createNotificationChannel(generalSilent);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyATecmTI6WWH24gR6wCR4IooVH77VCnSgc',
            appId: '1:664897641321:android:e7f891474d9e7daeabfbf8',
            messagingSenderId: '664897641321',
            projectId: 'scuts-3ede2'));
  } else {
    await Firebase.initializeApp();
  }

  await requestDndAccess();

  // 🔥 STEP 1 — Initialize local notifications plugin
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit, iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      NotificationUtils.handleLocalNotificationPayload(response.payload);
    },
  );

  // 🔥 STEP 2 — CREATE AND REGISTER CHANNELS (VERY IMPORTANT)
  await _setupAndroidChannels();

  await GetStorage.init();
  Get.put(AuthController());
  await Get.find<AuthController>().initUserData();

  // ── DEBUG ONLY ──────────────────────────────────────────────────────────
  // Overwrite the stored access token with a garbage value so the next API
  // call receives a 401. The interceptor should silently refresh and retry.
  // To test refresh-token expiry too, also corrupt PrefConstants.userModel /
  // stylistModel (set refreshToken inside to "invalid") → expect logout.
  // if (kDebugMode) {
  //   final hasToken =
  //       SharedPrefs.readStringValue(PrefConstants.token).isNotEmpty;
  //   if (hasToken) {
  //     await SharedPrefs.writeValue(
  //         PrefConstants.token, "invalid_access_token_test");
  //     await SharedPrefs.writeValue(
  //         PrefConstants.userModel, "invalid_user_model_test");
  //     await SharedPrefs.writeValue(
  //         PrefConstants.stylistModel, "invalid_stylist_model_test");
  //     debugPrint("🔐 DEBUG: access token corrupted for 401 flow test");
  //     debugPrint("🔐 DEBUG: user model corrupted for 401 flow test");
  //     debugPrint("🔐 DEBUG: stylist model corrupted for 401 flow test");
  //   }
  // }
  // ── END DEBUG ────────────────────────────────────────────────────────────

  DioClient.init();
  Get.put(HomeController());
  Get.put(StylistController());

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationService().setupInteractedMessage();
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await initFCM();
    await initNotification();
  }

  Future<void> initFCM() async {
    // Single listener for token rotation.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await SharedPrefs.writeValue(PrefConstants.fcmToken, newToken);
      debugPrint('FCM Token (refresh): $newToken');
    });

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      await SharedPrefs.writeValue(PrefConstants.deviceId, deviceId);

      if (Platform.isIOS) {
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();
        if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
          await FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );
        }
        // Without Push capability + aps-environment, APNS stays null and FCM token never resolves.
        String? apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null) {
          for (var i = 0; i < 15; i++) {
            await Future<void>.delayed(const Duration(milliseconds: 400));
            apns = await FirebaseMessaging.instance.getAPNSToken();
            if (apns != null) break;
          }
        }
        if (kDebugMode) {
          debugPrint('APNS TOKEN => $apns');
        }
      }

      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await SharedPrefs.writeValue(PrefConstants.fcmToken, token);
          debugPrint('FCM Token: $token');
        } else {
          debugPrint(
            'FCM Token: null — iOS: enable Push Notifications + upload APNs key in '
            'Firebase Console; use a real device. '
            'Android: use an emulator image with Google Play.',
          );
        }
      } catch (e) {
        debugPrint('FCM getToken inner error: $e');
      }
    } catch (e, st) {
      debugPrint('FCM getToken failed: $e');
      debugPrint('$st');
    }

    if (kDebugMode) {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      debugPrint('AUTH STATUS => ${s.authorizationStatus}');
      debugPrint('PROJECT => ${Firebase.app().options.projectId}');
    }
  }

  Future<void> initNotification() async {
    // Foreground: show local notification + snackbar via NotificationUtils.
    // Background tap + terminated tap are handled by PushNotificationService
    // (setupInteractedMessage) which is called in main() before runApp.
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      NotificationUtils.handleNotificationOnForeground(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scuts for business',
      theme: ThemeData(
        fontFamily: "Satoshi",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      initialRoute: "/",
      getPages: [GetPage(name: "/", page: () => const SplashPage())],
    );
  }
}
