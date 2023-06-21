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
          children: [
            if (_viewModel.hasAudio) Player(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            AppIcons.home,
            'Home',
            '/',
          ),
          _buildButton(
            AppIcons.search,
            'Search',
            '/search',
          ),
          _buildButton(
            AppIcons.download,
            'Downloads',
            '/downloads',
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, String path) {
    return TextButton.icon(
      // onPressed: () => Get.toNamed(path),
      onPressed: () {},
      icon: Icon(
        icon,
        color: AppColors.white,
        size: 20,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
