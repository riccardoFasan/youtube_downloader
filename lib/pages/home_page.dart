import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/pages/pages.dart';
import 'package:yuotube_downloader/controllers/controllers.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

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
      () => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ..._downloadController.audios.map(
            (Audio audio) => _buildAudioTile(audio),
          )
        ],
      ),
    );
  }

  AudioTile _buildAudioTile(Audio audio) {
    return AudioTile(
      key: ValueKey(audio.id),
      audio: audio,
      removeCallback: _removeAudio,
      tapCallback: _playAudio,
    );
  }

  void _playAudio(Audio audio) {
    _playerController.setCurrentAudioAndPlay(audio);
  }

  void _removeAudio(Audio audio) {
    _downloadController.delete(audio);
    if (_playerController.isSelected(audio)) _playerController.stop();
  }
}
