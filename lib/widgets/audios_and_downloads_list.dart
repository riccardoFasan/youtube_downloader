import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class AudiosAndDownloadsList extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find();

  AudiosAndDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(children: [
          if (_viewModel.downloads.isNotEmpty)
            const ListTile(
              title: Text('Current Downloads'),
            ),
          ..._viewModel.downloads
              .map((Download download) => _generateDownloadTile(download)),
          if (_viewModel.downloads.isNotEmpty && _viewModel.audios.isNotEmpty)
            const Divider(
              height: 40,
              indent: 20,
              endIndent: 20,
            ),
          if (_viewModel.audios.isNotEmpty)
            const ListTile(
              title: Text('Your Audios'),
            ),
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
