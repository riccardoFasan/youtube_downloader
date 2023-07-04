import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/app.dart';
import 'package:youtube_downloader/services/services.dart';
import 'package:youtube_downloader/controllers/controllers.dart';

void main() {
  runApp(const YouTubeDownloaderApp());
  _injectServices();
}

Future<void> _injectServices() async {
  Get.lazyPut(() => LifecycleService());
  Get.lazyPut(() => NotificationsService());
  Get.lazyPut(() => SnackbarService());
  Get.lazyPut(() => FileSystemService());
  Get.lazyPut(() => StorageService());
  Get.lazyPut(() => PlayerService());
  Get.lazyPut(() => YouTubeService());
  Get.lazyPut(() => SponsorblockService());
  Get.lazyPut(() => TrimmerService());
  Get.lazyPut(() => BackgroundService());
  Get.lazyPut(() => VideoSearchController());
  Get.lazyPut(() => DownloadController());
  Get.lazyPut(() => PlayerController());
}
