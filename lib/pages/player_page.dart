import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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
            _buildProgressBar(),
            _buildControls(),
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
              color: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 50,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Obx(
                  () => _buildDurationText(_viewModel.currentPosition),
                ),
              ),
              Obx(
                () => _buildDurationText(_viewModel.audio.duration),
              ),
            ],
          ),
          Obx(
            () => ProgressBar(
              barHeight: 8,
              thumbGlowRadius: 13,
              thumbGlowColor: Colors.white,
              progress: _viewModel.currentPosition,
              total: _viewModel.audio.duration,
              progressBarColor: Colors.white,
              thumbColor: Colors.white,
              baseBarColor: AppColors.mediumGray,
              onSeek: (Duration duration) =>
                  _viewModel.seek(duration.inMilliseconds),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationText(Duration duration) {
    return Text(
      printDuration(duration),
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      margin: const EdgeInsets.only(
        top: 25,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildSkipBackButton(),
              _buildRewindButton(),
              _buildPlayPauseButton(),
              _buildForwardButton(),
              _buildSkipForwardButton(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildLoopButton(),
                _buildShuffleButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return Ink(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(0),
        color: AppColors.darkGray,
        onPressed: () => _viewModel.togglePlay(),
        icon: _buildPlayPauseIcon(),
      ),
    );
  }

  Widget _buildPlayPauseIcon() {
    return Obx(
      () => Padding(
        // * play icon is a bit off center
        padding: EdgeInsets.only(left: _viewModel.playing == true ? 0 : 4),
        child: Icon(
          _viewModel.playing == true ? AppIcons.pause : AppIcons.play,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRewindButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _viewModel.seekBackward(),
      icon: const Icon(
        AppIcons.rewind,
        size: 30,
      ),
    );
  }

  Widget _buildForwardButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _viewModel.seekForward(),
      icon: const Icon(
        AppIcons.forward,
        size: 30,
      ),
    );
  }

  Widget _buildSkipBackButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _viewModel.playPrevious(),
      icon: const Icon(
        AppIcons.skipBack,
        size: 30,
      ),
    );
  }

  Widget _buildSkipForwardButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _viewModel.playNext(),
      icon: const Icon(
        AppIcons.skipForward,
        size: 30,
      ),
    );
  }

  Widget _buildLoopButton() {
    return Obx(
      () => Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: _viewModel.loopOne ? AppColors.gray : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          color: AppColors.white,
          onPressed: () => _viewModel.switchLoop(),
          icon: const Icon(
            AppIcons.arrowReload,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildShuffleButton() {
    return Obx(
      () => Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: _viewModel.shuffle ? AppColors.gray : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          color: AppColors.white,
          onPressed: () => _viewModel.switchShuffle(),
          icon: const Icon(
            AppIcons.shuffle,
            size: 20,
          ),
        ),
      ),
    );
  }
}
