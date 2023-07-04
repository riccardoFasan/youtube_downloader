import 'package:flutter_background/flutter_background.dart';

class BackgroundService {
  final _backgroundNotificationConfig = const FlutterBackgroundAndroidConfig(
    notificationTitle: "YouTube Downloader",
    notificationText:
        "YouTube Downloader is downloading one or more videos in background",
    notificationImportance: AndroidNotificationImportance.Default,
    showBadge: false,
  );

  bool get isEnabled => FlutterBackground.isBackgroundExecutionEnabled;

  BackgroundService() {
    _init();
  }

  Future<void> enableBackgroundExecution() async {
    if (isEnabled) return;
    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (hasPermissions) return;
    await FlutterBackground.enableBackgroundExecution();
  }

  Future<void> disableBackgroundExecution() async {
    if (!isEnabled) return;
    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (hasPermissions) return;
    await FlutterBackground.disableBackgroundExecution();
  }

  Future<void> _init() async {
    await FlutterBackground.initialize(
      androidConfig: _backgroundNotificationConfig,
    );
  }
}
