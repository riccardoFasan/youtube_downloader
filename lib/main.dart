import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/app.dart';
import 'package:yuotube_downloader/services/services.dart';
import 'package:yuotube_downloader/controllers/controllers.dart';

void main() {
  runApp(const YouTubeDownloaderApp());
  _injectServices();
}

Future<void> _injectServices() async {
  Get.put(LifecycleService());
  Get.put(NotificationsService());
  Get.put(SnackbarService());
  Get.put(FileSystemService());
  Get.put(StorageService());
  Get.put(PlayerService());
  Get.put(YouTubeService());
  Get.put(SponsorblockService());
  Get.put(TrimmerService());
  Get.put(VideoSearchController());
  Get.put(DownloadController());
  Get.put(PlayerController());
}
