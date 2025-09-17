import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:youtube_downloader/controllers/player_controller.dart';
import 'package:youtube_downloader/routes.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class MiniPlayer extends StatelessWidget {
  final PlayerController _playerController = Get.find<PlayerController>();

  static const double _height = 70;
  static const double _padding = 12;

  MiniPlayer({super.key});

  double get _thumbnailSize => _height - (_padding * 2);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.player),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(_padding),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Obx(
            () => Row(
              children: <Widget>[
                Container(
                  height: _thumbnailSize,
                  width: _thumbnailSize,
                  margin: const EdgeInsets.only(right: _padding),
                  child: VideoThumbnail(
                    radius: 4,
                    url: _playerController.audio.thumbnailMinResUrl,
                  ),
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
      ),
    );
  }

  Widget _buildAudioTitle() {
    return TextScroll(
      _playerController.audio.title,
      velocity: const Velocity(pixelsPerSecond: Offset(35, 0)),
      delayBefore: const Duration(milliseconds: 400),
      pauseBetween: const Duration(milliseconds: 25),
      intervalSpaces: 20,
      fadedBorder: true,
      fadedBorderWidth: .1,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildAudioChannelName() {
    return Text(
      _playerController.audio.channel,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: AppColors.lightGray,
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      color: AppColors.white,
      onPressed: () => _playerController.togglePlay(),
      icon: _buildPlayPauseIcon(),
    );
  }

  Widget _buildPlayPauseIcon() {
    return Icon(
      _playerController.playing == true ? AppIcons.pause : AppIcons.play,
      size: 18,
    );
  }

  Widget _buildDismissButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      color: AppColors.white,
      onPressed: () => _playerController.stop(),
      icon: const Icon(
        AppIcons.dismiss,
        size: 18,
      ),
    );
  }
}
