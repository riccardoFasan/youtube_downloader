import 'package:get/get.dart';
import 'package:youtube_downloader/pages/pages.dart';

class AppRoutes {
  static const String home = '/home';
  static const String search = '/search';
  static const String downloads = '/downloads';
  static const String player = '/player';
}

appRoutes() => [
      GetPage(
        name: AppRoutes.home,
        page: () => HomePage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: AppRoutes.search,
        page: () => SearchPage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: AppRoutes.downloads,
        page: () => DownloadsPage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: AppRoutes.player,
        page: () => PlayerPage(),
        transition: Transition.noTransition,
      ),
    ];
