import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class AudiosList extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();

  AudiosList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ..._viewModel.audios.map((Audio todo) => _generateAudioTile(todo))
        ],
      ),
    );
  }

  AudioTile _generateAudioTile(Audio audio) {
    return AudioTile(
      key: ValueKey(audio.id),
      audio: audio,
      removeCallback: _viewModel.delete,
      tapCallback: _viewModel.play,
    );
  }
}
