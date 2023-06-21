import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsList extends StatelessWidget {
  final AudiosViewModel _viewModel = Get.find<AudiosViewModel>();

  DownloadsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ..._viewModel.downloads
              .map((Download download) => _generateDownloadTile(download)),
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
}
