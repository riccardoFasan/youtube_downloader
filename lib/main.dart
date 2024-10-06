import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/app.dart';
import 'package:youtube_downloader/services/services.dart';
import 'package:youtube_downloader/controllers/controllers.dart';

Future<void> main() async {
  await _injectServices();
  runApp(const YouTubeDownloaderApp());
}

Future<void> _injectServices() async {
  Get.lazyPut(() => LifecycleService());
  Get.lazyPut(() => NotificationsService());
  Get.lazyPut(() => SnackbarService());
  Get.lazyPut(() => FileSystemService());
  Get.lazyPut(() => DevicePermissionsStorageService());
  Get.lazyPut(() => BatteryOptimizationService());
  Get.lazyPut(() => PlayerService());
  Get.lazyPut(() => YouTubeService());
  Get.lazyPut(() => SponsorblockService());
  Get.lazyPut(() => SettingsController());
  Get.lazyPut(() => VideoSearchController());
  Get.lazyPut(() => DownloadController());
  Get.lazyPut(() => PlayerController());
}
