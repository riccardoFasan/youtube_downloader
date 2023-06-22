import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/app.dart';
import 'package:yuotube_downloader/services/services.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';

void main() {
  runApp(const YouTubeDownloaderApp());
  _injectServices();
}

Future<void> _injectServices() async {
  Get.put(YouTubeService());
  Get.put(StorageService());
  Get.put(FileSystemService());
  Get.put(SnackbarService());
  Get.put(SponsorblockService());
  Get.put(TrimmerService());
  Get.put(PlayerService());
  Get.put(PlayerViewModel());
  Get.put(AudiosViewModel());
  Get.put(SearchViewModel());
}
