import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

import 'motivation_http_service.dart';

class LocalNotificationsService {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationsEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      notificationsEnabled = grantedNotificationPermission ?? false;
    } else if (Platform.isIOS) {
      final bool? result = await _localNotification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      notificationsEnabled = result ?? false;
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings('mipmap/ic_launcher');

    const notificationInit = InitializationSettings(
      android: androidInit,
    );

    await _localNotification.initialize(notificationInit);
  }

  static Future<void> showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'goodChannelId',
      'goodChannelName',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotification.show(
      0,
      'Pomodoro',
      "Dam olish vaqti bo'ldi",
      notificationDetails,
    );
  }

  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'goodChannelId',
      'goodChannelName',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'Ticker',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> showPeriodicNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.periodicallyShowWithDuration(
      0,
      "Xurmatli foydalanuvchi",
      "Dam oladigan vaqtingiz bo'ldi!",
      const Duration(minutes: 1),
      notificationDetails,
      payload: "Nimadir",
    );
  }


  static Future<void> scheduleDailyQuoteNotification() async {
    String motivationText = await APIService.getMotivation();

    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(seconds: 5));
    }

    await showScheduledNotification(
      id: 1,
      title: "Motivation text",
      body: motivationText,
      scheduledTime: scheduledTime,
    );
  }
}
