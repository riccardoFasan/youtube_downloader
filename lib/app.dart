import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/pages/pages.dart';

class YouTubeDownloaderApp extends StatelessWidget {
  const YouTubeDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter YouTube Downloader & Converter',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: DownloadsPage(),
    );
  }
}
