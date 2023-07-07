import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/pages/pages.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  final VideoSearchController _searchController =
      Get.find<VideoSearchController>();
  final DownloadController _downloadController = Get.find<DownloadController>();

  final Debouncer _searchDebouncer = Debouncer(milliseconds: 200);
  final Debouncer _scrollDebouncer = Debouncer(milliseconds: 100);
  final Random _random = Random();
  final ScrollController _scrollController = ScrollController();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    _onListEndReached();
    return ListPage(
      barContent: SeekerBar(
        searchCallback: (String query) =>
            _searchDebouncer.run(() => _searchController.search(query)),
        clearCallback: _searchController.clear,
      ),
      columnContent: _buildList(),
    );
  }

  Widget _buildList() {
    return Obx(
      () => ListView(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          if (!_searchController.loadingFirstBatch)
            ..._searchController.results.map(
              (AudioInfo result) {
                if (_downloadController.isDownloading(result)) {
                  return _buildDownloadTile(result);
                }
                return _buildResultTile(
                  result,
                  _downloadController.isSaved(result),
                );
              },
            ),
          if (_searchController.loadingFirstBatch) ..._buildSkeletonTiles(),
          if (_searchController.loadingNextBatch) _buildCenteredSpinner(),
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

  DownloadTile _buildDownloadTile(AudioInfo audioInfo) {
    final Download download = _downloadController.downloads
        .firstWhere((Download d) => d.id == audioInfo.id);
    return DownloadTile(
      key: ValueKey(download.id),
      download: download,
      cancelCallback: _downloadController.cancelDownload,
    );
  }

  List<SkeletonTile> _buildSkeletonTiles() {
    const int maxNumberOfTiles = 15;
    const int minNumberOfTiles = 8;
    final int lenght =
        minNumberOfTiles + _random.nextInt(maxNumberOfTiles - minNumberOfTiles);
    return List.generate(lenght, (_) => SkeletonTile());
  }

  Widget _buildCenteredSpinner() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: 30,
        height: 30,
        child: const CircularProgressIndicator(
          color: AppColors.red,
        ),
      ),
    );
  }

  void _onListEndReached() {
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (_searchController.canLoadNextBatch) {
          _scrollDebouncer.run(() => _searchController.nextSearchBatch());
        }
      }
    });
  }
}
