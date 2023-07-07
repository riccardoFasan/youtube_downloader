import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/pages/pages.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  final DownloadController _downloadController = Get.find<DownloadController>();

  DownloadsPage({super.key});

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
          ..._downloadController.downloads.map(
            (Download download) => _buildDownloadTile(download),
          ),
        ],
      ),
    );
  }

  DownloadTile _buildDownloadTile(Download download) {
    return DownloadTile(
      key: ValueKey(download.id),
      download: download,
      cancelCallback: _downloadController.cancelDownload,
    );
  }
}
