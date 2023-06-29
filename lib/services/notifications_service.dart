import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _androidDetails =
      const AndroidNotificationDetails(
    'youtube_downloader_notification_channel',
    'YouTube Downloader',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  bool _permissionsAccepted = false;

  NotificationsService() {
    _init();
  }

  NotificationDetails get _details => NotificationDetails(
        android: _androidDetails,
      );

  Future<void> showDownloadCompletd(String title) async {
    await _showLocalNotification(
      'YouTube Video Downloaded',
      "\"$title\" has been downloaded.",
    );
  }

  Future<void> _showLocalNotification(String title, String text) async {
    if (!_permissionsAccepted) return;
    return _plugin.show(UniqueKey().hashCode, title, text, _details);
  }

  Future<void> _init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('mipmap/ic_launcher'),
    );
    _plugin.initialize(initializationSettings);
    _permissionsAccepted = await _requestPermissions();
  }

  Future<bool> _requestPermissions() async {
    bool? accepted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    if (accepted == null || !accepted) return false;
    return true;
  }
}
