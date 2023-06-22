import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();
  final PlayerViewModel _player = Get.find<PlayerViewModel>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YouTube Downloader',
        ),
      ),
      bottomNavigationBar: Navigation(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
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
      removeCallback: _viewModel.delete,
      tapCallback: _playAudio,
    );
  }

  void _playAudio(Audio audio) {
    _player.setCurrentAudioAndPlay(audio);
  }
}
