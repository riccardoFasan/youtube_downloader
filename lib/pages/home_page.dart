import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/pages/pages.dart';
import 'package:youtube_downloader/utils/colors.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final DownloadController _downloadController = Get.find<DownloadController>();
  final PlayerController _playerController = Get.find<PlayerController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPage(
      barContent: const Text(
        'YouTube Downloader',
      ),
      columnContent: _buildList(),
    );
  }

  Widget _buildList() {
    return Obx(
      () => ReorderableListView(
        shrinkWrap: true,
        proxyDecorator: _proxyDecorator,
        scrollDirection: Axis.vertical,
        onReorder: (int oldIndex, int newIndex) {
          _downloadController.reorder(oldIndex, newIndex);
        },
        children: <Widget>[
          ..._downloadController.audios.map(
            (Audio audio) => _buildAudioTile(audio),
          )
        ],
      ),
    );
  }

  Widget _buildAudioTile(Audio audio) {
    return AudioTile(
      key: ValueKey(audio.id),
      audio: audio,
      removeCallback: _removeAudio,
      tapCallback: _playAudio,
      current: _playerController.isSelected(audio),
      playing: _playerController.isSelected(audio) && _playerController.playing,
    );
  }

  void _playAudio(Audio audio) {
    _playerController.setCurrentAudioAndPlay(audio);
  }

  void _removeAudio(Audio audio) {
    _downloadController.delete(audio);
    if (_playerController.isSelected(audio)) _playerController.stop();
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: AppColors.black,
          shadowColor: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}
