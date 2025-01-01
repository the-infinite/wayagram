import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  // // get the fcm device token
  // static Future getDeviceToken({int maxRetires = 3}) async {
  //   try {
  //     String? token;
  //     // if (kIsWeb) {
  //     //   // get the device fcm token
  //     //   token = await _firebaseMessaging.getToken(
  //     //       vapidKey:
  //     //           "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
  //     //   print("for web device token: $token");
  //     // } else {
  //     // get the device fcm token
  //     token = await _firebaseMessaging.getToken();
  //     print(
  //         "for android device token ==============================================: $token");

  //     // saveTokentoFirestore(token: token!);
  //     // return token;
  //   } catch (e) {
  //     print("failed to get device token ===========================");
  //     if (maxRetires > 0) {
  //       print("try after 10 sec  -------------=---------------------");
  //       await Future.delayed(Duration(seconds: 10));
  //       return getDeviceToken(maxRetires: maxRetires - 1);
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  static saveTokenToServer() async {
    // final token = await _firebaseMessaging.getToken();
    //  print("saved ========== $token");
    // if (token == null) return;
    // var storage = await SharedPreferenceLocalStorage.getInstance();
    // var user = storage.getMap(StorageKeys.user);
    // final crudService = CrudService();

    // if (user != null) {
    //   await crudService.saveToken(token);
    //    print("saved = ======");
    // }
    // // also save if token changes
    // _firebaseMessaging.onTokenRefresh.listen((event) async {
    //   if (user != null) {
    //     await crudService.saveToken(token);
    //     //  print("saved =wer");
    //   }
    // });
  }

static Future localNotiInit() async {
  // Initialise the plugin. `app_icon` needs to be added as a drawable resource to the Android head project.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //   onDidReceiveLocalNotification: (id, title, body, payload) {},
  // );

  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsDarwin,
  //   linux: initializationSettingsLinux,
  // );

  // Request notification permissions for Android 13 or above
  final androidImplementation =
      _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidImplementation != null) {
    await androidImplementation.requestNotificationsPermission();
  } else {
    //print("AndroidFlutterLocalNotificationsPlugin is not available.");
  }

  // Initialize the plugin for handling notifications
  // await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onDidReceiveNotificationResponse: onNotificationTap,
  //     onDidReceiveBackgroundNotificationResponse: onNotificationTap);
}


  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;

    // if (payload != null && payload.contains("Onboarding")) {
    //   navRouter.navigateToDocumentsView();
    // } else {
    //   navRouter.navigateToCustomerDashboardView();
    // }
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
