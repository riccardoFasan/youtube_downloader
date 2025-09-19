import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:youtube_downloader/controllers/player_controller.dart';
import 'package:youtube_downloader/routes.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  final PlayerController _playerController = Get.find<PlayerController>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static const double _height = 70;
  static const double _padding = 10;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _thumbnailSize => _height - (_padding * 2);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: InkWell(
            borderRadius: BorderRadius.circular(_padding),
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () => Get.toNamed(AppRoutes.player),
            child: Obx(
              () => BlurredBackground(
                color: AppColors.darkGray,
                radius: _padding * 1.75,
                url: _playerController.audio.thumbnailMinResUrl,
                fit: BoxFit.fitWidth,
                child: Container(
                  color: AppColors.darkGray.withValues(alpha: .5),
                  padding: const EdgeInsets.all(_padding),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: _thumbnailSize,
                        width: _thumbnailSize,
                        margin: const EdgeInsets.only(right: _padding),
                        child: Hero(
                          tag: 'miniPlayer',
                          child: VideoThumbnail(
                            radius: _padding * 1.25,
                            url: _playerController.audio.thumbnailMinResUrl,
                          ),
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
          ),
        );
      },
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _playerController.togglePlay(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: _buildPlayPauseIcon(),
        ),
      ),
    );
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
        child: Icon(
          key: ValueKey(_playerController.playing),
          _playerController.playing == true ? AppIcons.pause : AppIcons.play,
          size: 18,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildDismissButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _playerController.stop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            AppIcons.dismiss,
            size: 16,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
