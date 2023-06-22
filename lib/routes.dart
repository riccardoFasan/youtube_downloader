import 'package:get/get.dart';
import 'package:yuotube_downloader/pages/pages.dart';

appRoutes() => [
      GetPage(
        name: '/home',
        page: () => HomePage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: '/search',
        page: () => SearchPage(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: '/downloads',
        page: () => DownloadsPage(),
        transition: Transition.noTransition,
      ),
    ];
