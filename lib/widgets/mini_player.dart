import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/view_models/player_view_model.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class MiniPlayer extends StatelessWidget {
  final PlayerViewModel _viewModel = Get.find<PlayerViewModel>();

  static const double _height = 70;
  static const double _padding = 12;

  MiniPlayer({super.key});

  double get _thumbnailSize => _height - (_padding * 2);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(_padding),
      onTap: () => Get.toNamed('/player'),
      child: Obx(
        () => Ink(
          height: _height,
          padding: const EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: _viewModel.backgroundColor,
            borderRadius: BorderRadius.circular(_padding),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: _thumbnailSize,
                width: _thumbnailSize,
                margin: const EdgeInsets.only(right: _padding),
                child: VideoThumbnail(url: _viewModel.audio.thumbnailUrl),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildAudioTitle(),
                    _buildAudioChannelName(),
                  ],
                ),
              ),
              _buildPlayPauseButton(),
              _buildDismissButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioTitle() {
    return Obx(
      () => Text(
        _viewModel.audio.title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildAudioChannelName() {
    return Obx(
      () => Text(
        _viewModel.audio.channel,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          color: AppColors.lightGray,
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      color: AppColors.white,
      onPressed: () => _viewModel.togglePlay(),
      icon: _buildPlayPauseIcon(),
    );
  }

  Widget _buildPlayPauseIcon() {
    return Obx(
      () => Icon(
        _viewModel.playing == true ? AppIcons.pause : AppIcons.play,
        size: 18,
      ),
    );
  }

  Widget _buildDismissButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      color: AppColors.white,
      onPressed: () => _viewModel.stop(),
      icon: const Icon(
        AppIcons.dismiss,
        size: 18,
      ),
    );
  }
}
