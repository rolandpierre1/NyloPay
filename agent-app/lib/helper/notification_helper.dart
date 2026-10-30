import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:six_cash/common/enums/request_type_enum.dart';
import 'package:six_cash/common/models/notification_body.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/home/domain/enums/navbar_type_enum.dart';
import 'package:six_cash/features/notification/controllers/notification_controller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/requested_money/controllers/requested_money_controller.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/requested_money/screens/requested_list_screen.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/app_constants.dart';


class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {

      try{
        if(notificationResponse.payload != null && notificationResponse.payload != ''){
          NotificationBody notificationBody = convertNotification(jsonDecode(notificationResponse.payload!));
          final MenuItemController menuItemController = Get.find();
          final RequestedMoneyController requestedMoneyController = Get.find();

          if(notificationBody.type == 'general'){
            menuItemController.updateNavbarScreen(NavbarType.notificationScreen);
            Get.toNamed(RouteHelper.getNavBarRoute(isFromNotification: true));

          }else if(notificationBody.type == 'cash_in'
              || notificationBody.type == 'cash_out'
              || notificationBody.type == 'add_money'
              || notificationBody.type == 'add_money_bonus'
              || notificationBody.type == AppConstants.addDisputedMoney
              || notificationBody.type == AppConstants.deductDisputedMoney
          ){

            menuItemController.updateNavbarScreen(NavbarType.transactionHistoryScreen);
            Get.toNamed(RouteHelper.getNavBarRoute(isFromNotification: true));

          }else if(notificationBody.type == 'withdraw_money_approved'){
            requestedMoneyController.setIndex(1);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.withdraw, isFromNotification: true));

          }else if(notificationBody.type == 'withdraw_money_denied'){
            requestedMoneyController.setIndex(2);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.withdraw, isFromNotification: true));

          }else if(notificationBody.type == 'send_request_money'){
            requestedMoneyController.setIndex(0);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }else if(notificationBody.type == 'denied_money'){
            requestedMoneyController.setIndex(2);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }else if(notificationBody.type == 'received_money'){
            requestedMoneyController.setIndex(1);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }else if (notificationBody.type == 'download' && notificationBody.filePath != null) {
            await OpenFile.open(notificationBody.filePath!);
          }
        }
      }catch(e){
        debugPrint('Error => $e');
      }


    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('onMessage: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey} \n ${message.data}');



      showNotification(message, flutterLocalNotificationsPlugin);
      if(Get.find<AuthController>().isLoggedIn()){
        Get.find<ProfileController>().profileData(reload: true);
        Get.find<NotificationController>().getNotificationList(true);
        Get.find<RequestedMoneyController>().getRequestedMoneyList(reload: true );

        final transactionHistoryController = Get.find<TransactionHistoryController>();
        transactionHistoryController.getTransactionList(1, isUpdate: true);
        transactionHistoryController.getRecentTransactionList(isUpdate: true);
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey} \n ${message.data}');


      if(Get.currentRoute != RouteHelper.loginScreen){
        Get.find<ProfileController>().profileData(reload: true);
        Get.find<RequestedMoneyController>().getRequestedMoneyList(reload: true );
        Get.find<NotificationController>().getNotificationList(true);

        final transactionHistoryController = Get.find<TransactionHistoryController>();
        transactionHistoryController.getTransactionList(1, isUpdate: true);
        transactionHistoryController.getRecentTransactionList(isUpdate: true);
      }

      try{
        if(message.data.isNotEmpty){
          NotificationBody notificationBody = convertNotification(message.data);
          final MenuItemController menuItemController = Get.find();
          final RequestedMoneyController requestedMoneyController = Get.find();

          if(notificationBody.type == 'general'){
            menuItemController.updateNavbarScreen(NavbarType.notificationScreen);
            Get.toNamed(RouteHelper.getNavBarRoute(isFromNotification: true));

          }else if(notificationBody.type == 'cash_in'
              || notificationBody.type == 'cash_out'
              || notificationBody.type == 'add_money'
              || notificationBody.type == 'add_money_bonus'
              || notificationBody.type == AppConstants.addDisputedMoney
              || notificationBody.type == AppConstants.deductDisputedMoney
          ){

            menuItemController.updateNavbarScreen(NavbarType.transactionHistoryScreen);
            Get.toNamed(RouteHelper.getNavBarRoute(isFromNotification: true));

          }else if(notificationBody.type == 'withdraw_money_approved'){
            requestedMoneyController.setIndex(1);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.withdraw, isFromNotification: true));

          }else if(notificationBody.type == 'withdraw_money_denied'){
            requestedMoneyController.setIndex(2);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.withdraw, isFromNotification: true));

          }else if(notificationBody.type == 'send_request_money'){
            requestedMoneyController.setIndex(0);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }else if(notificationBody.type == 'denied_money'){
            requestedMoneyController.setIndex(2);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }else if(notificationBody.type == 'received_money'){
            requestedMoneyController.setIndex(1);
            Get.to(()=> const RequestedListScreen(requestType: RequestType.sendRequest, isFromNotification: true));

          }

        }
      }catch(e){
        debugPrint('Error : $e');
      }

    });

  }

  static Future<void> showDownloadNotification(String payload, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notifications for completed downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await fln.show(
      0,
      'Download Complete',
      'Tap to open transaction_statement.pdf',
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin? fln) async {
    String? title;
    String? body;
    String? orderID;
    String? image;
    String payload = jsonEncode(message.data);

    title = message.data['title'];
    body = message.data['body'];
    orderID = message.data['order_id'];
    image = (message.data['image'] != null && message.data['image'].isNotEmpty)
        ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

    if(image != null && image.isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln!, payload: payload);
      }catch(e) {
        await showBigTextNotification(title, body!, orderID, fln!, payload: payload);
      }
    }else {
      await showBigTextNotification(title, body!, orderID, fln!, payload: payload);
    }
  }

  static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.appName, AppConstants.appName, playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String? title, String body, String? orderID, FlutterLocalNotificationsPlugin fln, {String? payload}) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.appName, AppConstants.appName, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, String? orderID, String image, FlutterLocalNotificationsPlugin fln,  {String? payload}) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.appName, AppConstants.appName,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data){
    return NotificationBody.fromJson(data);
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
  // var androidInitialize = const AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = const IOSInitializationSettings();
  // var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}