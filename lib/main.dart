import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/app.dart';
import 'package:yuotube_downloader/services/services.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';

void main() {
  runApp(const YouTubeDownloaderApp());
  _injectServices();
}

void _injectServices() {
  Get.put(YouTubeService());
  Get.put(StorageService());
  Get.put(FileSystemService());
  Get.put(SnackbarService());
  Get.put(AudiosViewModel());
}

// TODO: close yt explode client
