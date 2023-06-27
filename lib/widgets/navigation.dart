import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';

class Navigation extends StatelessWidget {
  final PlayerViewModel _viewModel = Get.find<PlayerViewModel>();

  static const double _navigationHeight = 70;
  static const double _playerHeight = 70;
  static const double _playerMargin = 5;

  Navigation({super.key});

  double get _barheight => _viewModel.hasAudio
      ? _navigationHeight + _playerHeight + _playerMargin
      : _navigationHeight;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: _barheight,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            if (_viewModel.hasAudio) MiniPlayer(),
            if (_viewModel.hasAudio)
              Container(
                margin: const EdgeInsets.only(bottom: _playerMargin),
              ),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _buildButton(
              AppIcons.home,
              'Home',
              '/home',
            ),
          ),
          Expanded(
            child: _buildButton(
              AppIcons.search,
              'Search',
              '/search',
            ),
          ),
          Expanded(
            child: _buildButton(
              AppIcons.download,
              'Downloads',
              '/downloads',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, String path) {
    final bool current = Get.currentRoute == path;
    final FontWeight fontWeight = current ? FontWeight.w900 : FontWeight.w300;
    return TextButton.icon(
      onPressed: () => Get.toNamed(path),
      icon: Icon(
        icon,
        color: AppColors.white,
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: fontWeight,
        ),
      ),
      style: ButtonStyle(
        backgroundColor:
            const MaterialStatePropertyAll<Color>(Colors.transparent),
        overlayColor: const MaterialStatePropertyAll<Color>(AppColors.darkGray),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        ),
      ),
    );
  }
}
