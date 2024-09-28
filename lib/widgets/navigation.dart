import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/routes.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';
import 'package:youtube_downloader/controllers/controllers.dart';

class Navigation extends StatelessWidget {
  final PlayerController _playerController = Get.find<PlayerController>();

  static const double _navigationHeight = 83;
  static const double _playerHeight = 72;
  static const double _margin = 5;

  Navigation({super.key});

  double get _barheight => _playerController.hasAudio
      ? _navigationHeight + _margin + _playerHeight
      : _navigationHeight + _margin;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _barheight,
          padding: const EdgeInsets.all(_margin * 2),
          child: Stack(
            children: [
              if (_playerController.hasAudio)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [MiniPlayer()],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: _margin),
                    child: _buildNavBar(),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _margin * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _buildButton(
              AppIcons.home,
              'Home',
              () => Get.toNamed(AppRoutes.home),
              Get.currentRoute == AppRoutes.home,
            ),
          ),
          Expanded(
            child: _buildButton(
              AppIcons.search,
              'Search',
              () => Get.toNamed(AppRoutes.search),
              Get.currentRoute == AppRoutes.search,
            ),
          ),
          Expanded(
            child: _buildButton(
              AppIcons.download,
              'Downloads',
              () => Get.toNamed(AppRoutes.downloads),
              Get.currentRoute == AppRoutes.downloads,
            ),
          ),
          Expanded(
            child: _buildButton(
              AppIcons.settingsCog,
              'Settings',
              () => Get.bottomSheet(SettingsModalSheet(),
                  backgroundColor: AppColors.black,
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                  enterBottomSheetDuration: const Duration(milliseconds: 150)),
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      IconData icon, String label, Function onPressed, bool active) {
    final Color color = active ? AppColors.white : AppColors.lightGray;
    return InkWell(
      onTap: () => onPressed(),
      borderRadius: BorderRadius.circular(_margin),
      child: Padding(
        padding: const EdgeInsets.all(_margin * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              height: 2,
              width: 35,
              decoration: BoxDecoration(
                color: active ? AppColors.red : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
