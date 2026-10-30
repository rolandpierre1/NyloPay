import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/features/profile/controllers/theme_controller.dart';
import 'package:six_cash/helper/notification_helper.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/theme/dark_theme.dart';
import 'package:six_cash/theme/light_theme.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'helper/get_di.dart' as di;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  try {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyBRzlDI7TXt5CfEbS9o38nH4fE6CxVFqX8",
      appId: "1:844198651339:android:14e33a31a06c534095c24e",
      messagingSenderId: "844198651339",
      projectId: "nylopay-fb5d8",
    ));

  }catch(e) {
    await Firebase.initializeApp();

  }

  ///firebase crashlytics


  cameras = await availableCameras();

  Map<String, Map<String, String>> languages = await di.init();

  int? orderID;
  try {
    if (GetPlatform.isMobile) {
      final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        orderID = notificationAppLaunchDetails!.notificationResponse!.payload != null ? int.parse(notificationAppLaunchDetails.notificationResponse!.payload!) : null;
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(e) {
    debugPrint('error -> $e');
  }

  runApp(MyApp(languages: languages, orderID: orderID));

}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final int? orderID;
  const MyApp({super.key, required this.languages, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
          child: SafeArea(top: false, child: GetMaterialApp(
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(),
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: themeController.darkTheme ? dark : light,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: RouteHelper.getSplashRoute(),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
          )),
        );
      },
      );
    },
    );
  }
}
