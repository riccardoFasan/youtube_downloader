import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/pages/pages.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();
  final PlayerViewModel _player = Get.find<PlayerViewModel>();

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
          ..._viewModel.audios.map(
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
    _player.setCurrentAudioAndPlay(audio);
  }

  void _removeAudio(Audio audio) {
    _viewModel.delete(audio);
    if (_player.isSelected(audio)) _player.stop();
  }
}
