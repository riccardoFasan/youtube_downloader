import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/pages/pages.dart';
import 'package:yuotube_downloader/utils/utils.dart';

class YouTubeDownloaderApp extends StatelessWidget {
  const YouTubeDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter YouTube Downloader & Converter',
      theme: ThemeData(
        fontFamily: 'Sofia Sans',
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.black,
        listTileTheme: const ListTileThemeData(
          tileColor: AppColors.black,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 80,
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: null,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 27),
        ),
      ),
      home: const DownloadsPage(),
    );
  }
}
