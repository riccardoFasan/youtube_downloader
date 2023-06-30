import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/routes.dart';
import 'package:youtube_downloader/utils/utils.dart';

class YouTubeDownloaderApp extends StatelessWidget {
  const YouTubeDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        title: 'Flutter YouTube Downloader & Converter',
        theme: ThemeData(
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
                TextStyle(fontWeight: FontWeight.w800, fontSize: 27),
          ),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: AppColors.red),
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
}
