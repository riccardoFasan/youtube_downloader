import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/pages/pages.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  final SearchViewModel _viewModel = Get.find<SearchViewModel>();
  final AudiosViewModel _audios = Get.find<AudiosViewModel>();

  final Debouncer _debouncer = Debouncer(milliseconds: 350);

  final Random _random = Random();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPage(
      barContent: SeekerBar(
        searchCallback: (String query) =>
            _debouncer.run(() => _viewModel.search(query)),
        clearCallback: _viewModel.clear,
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
          if (!_viewModel.loading)
            ..._viewModel.results.map(
              (AudioInfo result) {
                if (_audios.isDownloading(result)) {
                  return _buildDownloadTile(result);
                }

                return _buildResultTile(result, _audios.isSaved(result));
              },
            ),
          if (_viewModel.loading) ..._buildSkeletonTiles()
        ],
      ),
    );
  }

  ResultTile _buildResultTile(AudioInfo result, bool saved) {
    return ResultTile(
      key: ValueKey(result.id),
      result: result,
      saved: saved,
      downloadCallback: () => _audios.download(result),
    );
  }

  DownloadTile _buildDownloadTile(AudioInfo download) {
    return DownloadTile(
      key: ValueKey(download.id),
      download: download,
      cancelCallback: _audios.cancelDownload,
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
