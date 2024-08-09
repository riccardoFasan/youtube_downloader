import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _downloadCompletedAndroidDetails =
      const AndroidNotificationDetails(
    'com.richard.youtube_downloader.download_info',
    'YouTube Downloader',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    channelShowBadge: false,
  );

  final AndroidNotificationDetails _downloadInProgressAndroidDetails =
      const AndroidNotificationDetails(
    'com.richard.youtube_downloader.download_info',
    'YouTube Downloader',
    importance: Importance.low,
    priority: Priority.low,
    playSound: false,
    onlyAlertOnce: true,
    showProgress: true,
    indeterminate: true,
    channelShowBadge: false,
  );

  bool _permissionsAccepted = false;

  NotificationsService() {
    _init();
  }

  NotificationDetails get _downloadCompletedDetails => NotificationDetails(
        android: _downloadCompletedAndroidDetails,
      );

  NotificationDetails get _downloadInProgressDetails => NotificationDetails(
        android: _downloadInProgressAndroidDetails,
      );

  Future<int?> showDownloadCompleted(String title) async {
    if (!_permissionsAccepted) return null;
    final int id = UniqueKey().hashCode;
    await _notifications.show(
      id,
      'Download completed',
      "\"$title\" has been downloaded.",
      _downloadCompletedDetails,
    );
    return id;
  }

  Future<int?> showDownloadFailed(String title) async {
    if (!_permissionsAccepted) return null;
    final int id = UniqueKey().hashCode;
    await _notifications.show(
      id,
      'Download failed',
      "\"$title\" failed to download.",
      _downloadCompletedDetails,
    );
    return id;
  }

  Future<int?> showDownloadInProgress(String title) async {
    if (!_permissionsAccepted) return null;
    final int id = UniqueKey().hashCode;
    await _notifications.show(
      id,
      'Download in progress',
      "\"$title\" is being downloaded.",
      _downloadInProgressDetails,
    );
    return id;
  }

  Future<void> cancelNotification(int id) async {
    if (!_permissionsAccepted) return;
    return _notifications.cancel(id);
  }

  Future<void> _init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('mipmap/ic_launcher'),
    );
    _notifications.initialize(initializationSettings);
    _permissionsAccepted = await _requestPermissions();
  }

  Future<bool> _requestPermissions() async {
    bool? accepted = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    if (accepted == null || !accepted) return false;
    return true;
  }
}
