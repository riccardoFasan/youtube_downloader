import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();

  DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          ..._viewModel.downloads.map(
            (AudioInfo download) => _buildDownloadTile(download),
          ),
        ],
      ),
    );
  }

  DownloadTile _buildDownloadTile(AudioInfo download) {
    return DownloadTile(
      key: ValueKey(download.id),
      download: download,
      cancelCallback: _viewModel.cancelDownload,
    );
  }
}
