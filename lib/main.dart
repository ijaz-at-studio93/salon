import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // 🔥 STEP 2 — CREATE AND REGISTER CHANNELS (VERY IMPORTANT)
  await _setupAndroidChannels();

  await GetStorage.init();
  Get.put(AuthController());
  await Get.find<AuthController>().initUserData();
  DioClient.init();
  Get.put(HomeController());
  Get.put(StylistController());

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationService().setupInteractedMessage();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
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
    debugPrint('BOOTSTRAP: start');

    // Ensure Firebase/FCM is ready first
    // await initFCM();

    // Initialize local notifications & channels (already done in main() but safe to call again)
    // await flutterLocalNotificationsPlugin.initialize(...); // already initialized in main
    await _setupAndroidChannels(); // ensure channels exist now

    // Now register listeners & other notification setup
    await initNotification();

    debugPrint('BOOTSTRAP: done');
  }

  Future<void> initFCM() async {
    debugPrint('initFCM: start');
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      SharedPrefs.writeValue(PrefConstants.deviceId, deviceId);

      // get token and print it so you can copy/paste for testing
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('initFCM: FCM token -> $fcmToken');
      await SharedPrefs.writeValue(PrefConstants.fcmToken, fcmToken);

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint('initFCM: onTokenRefresh -> $newToken');
        SharedPrefs.writeValue(PrefConstants.fcmToken, newToken);
      });
    } catch (e, st) {
      debugPrint('initFCM: error $e');
      debugPrint(st.toString());
    }
    debugPrint('initFCM: end');
  }

  Future<void> initNotification() async {
    debugPrint('initNotification: start');

    // Ensure background handler is registered (idempotent)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    debugPrint('initNotification: background handler registered');

    // register onMessage listener and debug everything we get
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      debugPrint('=== FCM onMessage RAW ===');
      debugPrint('data: ${msg.data}');
      debugPrint('notification: ${msg.notification}');
      debugPrint('android channelId: ${msg.notification?.android?.channelId}');
      debugPrint('android sound: ${msg.notification?.android?.sound}');
      debugPrint(
          'apns sound (data): ${msg.data['aps'] ?? msg.data['sound'] ?? msg.data['apns']}');

      // forward to your handler
      NotificationUtils.handleNotificationOnForeground(msg);
    });

    debugPrint('initNotification: onMessage listener registered');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      debugPrint('onMessageOpenedApp -> ${event.data}');
      NotificationUtils.handleNotificationOnAppOpened(remoteMessage: event);
    });

    // initial message (app opened from killed)
    final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
    debugPrint('initNotification: initialMessage -> ${initialMsg?.data}');
    if (initialMsg != null) {
      NotificationUtils.handleNotificationOnAppOpened(
          remoteMessage: initialMsg, isAppKilled: true);
    }

    debugPrint('initNotification: end');
  }

  // 🔥🔥🔥 YOU DELETED THIS PART — THIS WAS THE ERROR
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
