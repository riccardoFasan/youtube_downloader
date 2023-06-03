import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/download_tile.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class AudiosAndDownloadsList extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find();

  AudiosAndDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(children: [
          ..._viewModel.downloads
              .map((Download download) => _generateDownloadTile(download)),
          ..._viewModel.audios.map((Audio todo) => _generateAudioTile(todo))
        ]));
  }

  DownloadTile _generateDownloadTile(Download download) {
    return DownloadTile(
      key: ValueKey(download.url),
      download: download,
    );
  }

  AudioTile _generateAudioTile(Audio audio) {
    return AudioTile(
      key: ValueKey(audio.id),
      audio: audio,
      removeCallback: _viewModel.delete,
      tapCallback: _viewModel.open,
    );
  }
}
