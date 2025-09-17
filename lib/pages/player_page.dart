import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class PlayerPage extends StatelessWidget {
  final PlayerController _playerController = Get.find<PlayerController>();

  PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildHero(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: VideoThumbnail(
              radius: 16,
              url: _playerController.audio.thumbnailMaxResUrl,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
              bottom: 8,
            ),
            child: Text(
              _playerController.audio.title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            _playerController.audio.channel,
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

  Widget _buildControls() {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      child: Column(
        children: <Widget>[
          _buildProgressBar(),
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

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Obx(
        () => ProgressBar(
          timeLabelLocation: TimeLabelLocation.above,
          timeLabelTextStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          timeLabelPadding: 10,
          barHeight: 8,
          thumbGlowRadius: 13,
          thumbGlowColor: Colors.white,
          progress: _playerController.currentPosition,
          total: _playerController.audio.duration,
          progressBarColor: Colors.white,
          thumbColor: Colors.white,
          baseBarColor: AppColors.mediumGray,
          onSeek: (Duration duration) =>
              _playerController.seek(duration.inMilliseconds),
        ),
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
        onPressed: () => _playerController.togglePlay(),
        icon: _buildPlayPauseIcon(),
      ),
    );
  }

  Widget _buildPlayPauseIcon() {
    return Obx(
      () => Padding(
        // * play icon is a bit off center
        padding:
            EdgeInsets.only(left: _playerController.playing == true ? 0 : 4),
        child: Icon(
          _playerController.playing == true ? AppIcons.pause : AppIcons.play,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildRewindButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _playerController.seekBackward(),
      icon: const Icon(
        AppIcons.rewind,
        size: 30,
      ),
    );
  }

  Widget _buildForwardButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _playerController.seekForward(),
      icon: const Icon(
        AppIcons.forward,
        size: 30,
      ),
    );
  }

  Widget _buildSkipBackButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _playerController.playPrevious(),
      icon: const Icon(
        AppIcons.skipBack,
        size: 30,
      ),
    );
  }

  Widget _buildSkipForwardButton() {
    return IconButton(
      color: AppColors.white,
      onPressed: () => _playerController.playNext(),
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
          color: _getIconButtonBackground(_playerController.loopOne),
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          color: AppColors.white,
          onPressed: () => _playerController.switchLoop(),
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
          color: _getIconButtonBackground(_playerController.shuffle),
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          color: AppColors.white,
          onPressed: () => _playerController.switchShuffle(),
          icon: const Icon(
            AppIcons.shuffle,
            size: 20,
          ),
        ),
      ),
    );
  }

  Color _getIconButtonBackground(bool active) {
    return active ? AppColors.white.withValues(alpha: .15) : Colors.transparent;
  }
}
