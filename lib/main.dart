import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/app.dart';
import 'package:yuotube_downloader/services/services.dart';

void main() {
  _injectServices();
  runApp(const YouTubeDownloaderApp());
}

void _injectServices() {
  Get.put(YouTubeService());
  Get.put(StorageService());
  Get.put(FileSytemService());
}
