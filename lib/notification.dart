import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationWidget {
  static final notifications = FlutterLocalNotificationsPlugin();

  ///
  ///
  static Future init({bool scheduled = false}) async {
    var initandroidsettings =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = DarwinInitializationSettings();
    final settings =
        InitializationSettings(android: initandroidsettings, iOS: ios);
    await notifications.initialize(settings);
  }

  ///
  ///

  static Future showNotification(
          {var id = 0, var title, var body, var payload}) async =>
      notifications.show(id, title, body, await notificationDetails());
//
//
//

  static notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          sound: RawResourceAndroidNotificationSound('notificatio'),
        ),
        iOS: DarwinNotificationDetails());
  }
}
