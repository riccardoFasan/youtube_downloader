import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/routes.dart';
import 'package:yuotube_downloader/utils/utils.dart';

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
            surfaceTintColor: null,
            shadowColor: null,
            systemOverlayStyle: null,
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.w800, fontSize: 27),
          ),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: AppColors.red),
        ),
        initialRoute: '/home',
        getPages: appRoutes(),
      ),
    );
  }
}
