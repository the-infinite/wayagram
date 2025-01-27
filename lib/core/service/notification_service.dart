import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request the notification permission.
  static Future<void> init() async {
    //? First, try initializing firebase notifications.
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
    } catch (e) {
      print("Failed to initialize firebase notifications because ${e.toString().toLowerCase()}");
    }

    //? Second, initialize local notifications.
    try {
      var androidInitialize = const AndroidInitializationSettings('@mipmap/launcher_icon');
      var iOSInitialize = const DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

      //? If this is iOS...
      if (Platform.isIOS) {
        // Request for iOS notification permissions.
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
            .requestPermissions(
              sound: true,
              alert: true,
            ); //!.requestPermission();
      }

      //? We just assume this is Android.
      else {
        // Request for android notification permissions.
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission(); //!.requestPermission();
      }

      // Initialize the notification plugin.
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
      );
    } catch (e) {
      print("Failed to initialize local notifications because ${e.toString().toLowerCase()}");
    }

    //? Third, and finally, try to include our firebase notification listeners.
    try {
      FirebaseMessaging.onMessage.listen(onReceiveNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(onNotificationStartApp);
      FirebaseMessaging.onBackgroundMessage(onReceiveBackgroundNotification);
    } catch (e) {
      print("Failed to bind notification listeners because ${e.toString().toLowerCase()}");
    }
  }

  /// Simple utility function used to listen for notifications that are sent when
  /// the app is open.
  static Future<void> onReceiveNotification(RemoteMessage message) async {}

  /// Simple utility function used to configure the app for the right startup
  /// activity and proportions if the notification just so happens to be what
  /// opened the app.
  static Future<void> onNotificationStartApp(RemoteMessage message) async {}

  /// Simple utility function used to listen for notifications that are send when
  /// the app is currently in a minimized state.
  static Future<void> onReceiveBackgroundNotification(RemoteMessage message) async {}

  /// Simple utility used to get th eFirebase Cloud Messaging device token of
  /// this device.
  static Future<String?> _getDeviceToken({int maxRetires = 3}) async {
    String? deviceToken;

    // Try a couple of stuff.
    try {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (e) {
      if (maxRetires > 0) {
        print("try after 2 sec  -------------=---------------------");
        await Future.delayed(Duration(seconds: 2));
        return _getDeviceToken(maxRetires: maxRetires - 1);
      }
    }

    // This is fine.
    return deviceToken;
  }

  /// A utility function used to not only retrieve the Firebase cloud messaging
  /// device token of the calling device but also do any necessary platform
  /// related configurations.
  static Future<String?> requestDeviceToken() async {
    String? deviceToken;

    // This is fine.
    try {
      if (Platform.isIOS) {
        //? First, configure the notifications presentation method.
        _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

        //? Second, attempt to request/get notification permission configuration.
        final settings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: false,
          criticalAlert: true,
          provisional: false,
          sound: true,
        );

        //? We only ever want to send the device token when we confirm that
        //? permissions are up to spec.
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _getDeviceToken();
        }
      } else {
        deviceToken = await _getDeviceToken();
      }

      //? Next, subscribe to topics.
      FirebaseMessaging.instance.subscribeToTopic("all_all_all");
    } catch (e) {
      print(e);
    }

    //? Leave if no token was generated.
    return deviceToken;
  }

  // on tap local notification in foreground
  @pragma('vm:entry-point')
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
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
}
