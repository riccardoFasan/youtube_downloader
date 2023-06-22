import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class PlayerPage extends StatelessWidget {
  final PlayerViewModel _viewModel = Get.find<PlayerViewModel>();

  PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBackBar(),
      body: _buildFullPlayer(),
    );
  }

  AppBar _buildBackBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          AppIcons.chewronDown,
          size: 24,
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildFullPlayer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            _buildHero(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Obx(
      () => Column(
        children: <Widget>[
          Container(
            height: 300,
            width: 300,
            margin: const EdgeInsets.only(
              bottom: 24,
            ),
            child: VideoThumbnail(
              url: _viewModel.audio.thumbnailUrl,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Text(
              _viewModel.audio.title,
              style: const TextStyle(
                color: AppColors.white,
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            _viewModel.audio.channel,
            style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w300,
              color: AppColors.lightgray,
            ),
          ),
        ],
      ),
    );
  }
}
