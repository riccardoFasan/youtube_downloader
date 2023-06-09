import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class AudiosAndDownloadsList extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();

  AudiosAndDownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          if (_viewModel.downloads.isNotEmpty)
            const ListTile(
              title: Text(
                'Current Downloads',
                style: TextStyle(color: Color.fromARGB(185, 255, 255, 255)),
              ),
            ),
          ..._viewModel.downloads
              .map((Download download) => _generateDownloadTile(download)),
          if (_viewModel.audios.isNotEmpty)
            Container(
                margin: EdgeInsets.only(
                    top: _viewModel.audios.isNotEmpty &&
                            _viewModel.downloads.isNotEmpty
                        ? 20
                        : 0),
                child: const ListTile(
                  title: Text(
                    'Your Audios',
                    style: TextStyle(
                      color: Color.fromARGB(185, 255, 255, 255),
                    ),
                  ),
                )),
          ..._viewModel.audios.map((Audio todo) => _generateAudioTile(todo))
        ],
      ),
    );
  }

  DownloadTile _generateDownloadTile(Download download) {
    return DownloadTile(
      key: ValueKey(download.url),
      download: download,
      cancelCallback: _viewModel.cancelDownload,
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
