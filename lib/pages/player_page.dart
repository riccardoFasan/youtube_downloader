import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({super.key});

  final PlayerController _playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BlurredBackground(
        color: AppColors.black,
        url: _playerController.audio.thumbnailMaxResUrl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildBackBar(),
          body: _buildFullPlayer(),
        ),
      ),
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
        ));
  }

  Widget _buildFullPlayer() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
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
        children: <Widget>[
          Hero(
            tag: 'miniPlayer',
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: VideoThumbnail(
                radius: 16,
                url: _playerController.audio.thumbnailMaxResUrl,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
              bottom: 8,
            ),
            child: TextScroll(
              _playerController.audio.title,
              velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
              delayBefore: const Duration(milliseconds: 300),
              pauseBetween: const Duration(milliseconds: 40),
              intervalSpaces: 40,
              fadedBorder: true,
              fadedBorderWidth: .1,
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 50.0, end: 0.0),
      curve: Curves.easeOutCubic,
      builder: (context, slideValue, child) {
        return Transform.translate(
          offset: Offset(0, slideValue),
          child: Opacity(
            opacity: 1.0 - (slideValue / 50.0),
            child: Container(
              margin: const EdgeInsets.only(top: 64),
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
                      top: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: 0.8 + (0.2 * opacity),
            child: Container(
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayPauseButton() {
    return AnimatedPressButton(
      onPressed: () => _playerController.togglePlay(),
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: _buildPlayPauseIcon(),
        ),
      ),
    );
  }

  Widget _buildRewindButton() {
    return AnimatedPressButton(
      onPressed: () => _playerController.seekBackward(),
      child: const Icon(
        AppIcons.rewind,
        size: 24,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildForwardButton() {
    return AnimatedPressButton(
      onPressed: () => _playerController.seekForward(),
      child: const Icon(
        AppIcons.forward,
        size: 24,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildSkipBackButton() {
    return AnimatedPressButton(
      onPressed: () => _playerController.playPrevious(),
      child: const Icon(
        AppIcons.skipBack,
        size: 24,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildSkipForwardButton() {
    return AnimatedPressButton(
      onPressed: () => _playerController.playNext(),
      child: const Icon(
        AppIcons.skipForward,
        size: 24,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildLoopButton() {
    return Obx(
      () => AnimatedPressButton(
        onPressed: () => _playerController.switchLoop(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: _getIconButtonBackground(_playerController.loopOne),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            AppIcons.arrowReload,
            size: 20,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildShuffleButton() {
    return Obx(
      () => AnimatedPressButton(
        onPressed: () => _playerController.switchShuffle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: _getIconButtonBackground(_playerController.shuffle),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            AppIcons.shuffle,
            size: 20,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Color _getIconButtonBackground(bool active) {
    return active ? AppColors.white.withValues(alpha: .15) : Colors.transparent;
  }

  Widget _buildPlayPauseIcon() {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Padding(
          key: ValueKey(_playerController.playing),
          padding:
              // * play icon is a bit off center
              EdgeInsets.only(left: _playerController.playing == true ? 0 : 4),
          child: Icon(
            _playerController.playing == true ? AppIcons.pause : AppIcons.play,
            size: 32,
          ),
        ),
      ),
    );
  }
}
