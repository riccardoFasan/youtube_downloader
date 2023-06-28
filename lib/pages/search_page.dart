import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/pages/pages.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/controllers/controllers.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  final VideoSearchController _searchController =
      Get.find<VideoSearchController>();
  final DownloadController _downloadController = Get.find<DownloadController>();

  final Debouncer _debouncer = Debouncer(milliseconds: 350);

  final Random _random = Random();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPage(
      barContent: SeekerBar(
        searchCallback: (String query) =>
            _debouncer.run(() => _searchController.search(query)),
        clearCallback: _searchController.clear,
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
          if (!_searchController.loading)
            ..._searchController.results.map(
              (AudioInfo result) {
                if (_downloadController.isDownloading(result)) {
                  return _buildDownloadTile(result);
                }

                return _buildResultTile(
                    result, _downloadController.isSaved(result));
              },
            ),
          if (_searchController.loading) ..._buildSkeletonTiles()
        ],
      ),
    );
  }

  ResultTile _buildResultTile(AudioInfo result, bool saved) {
    return ResultTile(
      key: ValueKey(result.id),
      result: result,
      saved: saved,
      downloadCallback: () => _downloadController.download(result),
    );
  }

  DownloadTile _buildDownloadTile(AudioInfo download) {
    return DownloadTile(
      key: ValueKey(download.id),
      download: download,
      cancelCallback: _downloadController.cancelDownload,
    );
  }

  List<SkeletonTile> _buildSkeletonTiles() {
    const int maxNumberOfTiles = 15;
    const int minNumberOfTiles = 5;
    final int lenght =
        minNumberOfTiles + _random.nextInt(maxNumberOfTiles - minNumberOfTiles);
    return List.generate(
      lenght,
      (index) => SkeletonTile(),
    );
  }
}
