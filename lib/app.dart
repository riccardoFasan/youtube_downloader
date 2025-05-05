import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/download_controller.dart';
import 'package:youtube_downloader/controllers/settings_controller.dart';
import 'package:youtube_downloader/routes.dart';
import 'package:youtube_downloader/services/services.dart';
import 'package:youtube_downloader/utils/to_material_color.dart';
import 'package:youtube_downloader/utils/utils.dart';

class YouTubeDownloaderApp extends StatelessWidget {
  const YouTubeDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    _askDevicePermissions();
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        title: 'Flutter YouTube Downloader & Converter',
        color: AppColors.white,
        theme: ThemeData(
          primarySwatch: toMaterialColor(Colors.white),
          fontFamily: 'Sofia Sans',
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.black,
          appBarTheme: const AppBarTheme(
            toolbarHeight: 80,
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 0,
            surfaceTintColor: AppColors.black,
            shadowColor: null,
            systemOverlayStyle: null,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w800, fontSize: 26),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.red,
            selectionHandleColor: AppColors.red,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: AppColors.black,
            titleTextStyle: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
            contentTextStyle: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        initialRoute: AppRoutes.home,
        getPages: appRoutes(),
      ),
    );
  }

  Future<void> _askDevicePermissions() async {
    FileSystemService fs = Get.find<FileSystemService>();
    SettingsController settings = Get.find<SettingsController>();
    NotificationsService notifications = Get.find<NotificationsService>();
    BatteryOptimizationService batteryOptimization =
        Get.find<BatteryOptimizationService>();
    PlayerService player = Get.find<PlayerService>();
    DownloadController downloadController = Get.find<DownloadController>();

    sleep(Duration(milliseconds: 1000));

    await fs.init();
    await settings.init();
    await notifications.init();
    await batteryOptimization.askToDisableOptimization();
    await player.init();
    await downloadController.init();
  }
}
