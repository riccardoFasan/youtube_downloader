import 'dart:async';
import 'dart:isolate';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_downloader/models/models.dart';

class YouTubeService {
  final int batchSize = 20;

  YoutubeExplode? _searchSession;
  VideoSearchList? _searchList;

  Future<List<int>> download(String videoId) {
    return Isolate.run(() async {
      final YoutubeExplode yte = YoutubeExplode();
      final StreamManifest manifest =
          await yte.videos.streamsClient.getManifest(videoId);
      final StreamInfo streamInfo = manifest.audioOnly.withHighestBitrate();
      final Stream<List<int>> stream = yte.videos.streamsClient.get(streamInfo);
      final Completer<List<int>> completer = Completer<List<int>>();
      final List<int> bytes = [];
      stream.listen(
        (List<int> chunk) => bytes.addAll(chunk),
        onDone: () {
          completer.complete(bytes);
          yte.close();
        },
      );
      return completer.future;
    });
  }

  void openSearchSession() {
    _searchSession = YoutubeExplode();
  }

  void closeSearchSession() {
    _searchSession!.close();
    _searchSession = null;
  }

  Future<List<AudioInfo>> search(String query) async {
    if (_searchSession == null) {
      throw Exception('Search session is not open');
    }
    _searchList = await _searchSession!.search.search(query);
    return _mapSearchList(_searchList!);
  }

  Future<List<AudioInfo>> nextPage() async {
    if (_searchSession == null) {
      throw Exception('Search session is not open');
    }
    if (_searchList == null) {
      throw Exception('Use search() before calling nextPage()');
    }
    _searchList = await _searchList!.nextPage();
    if (_searchList == null) return [];
    return _mapSearchList(_searchList!);
  }

  List<AudioInfo> _mapSearchList(VideoSearchList searchList) {
    return searchList
        .map((Video metadata) => _mapVideoToInfo(metadata))
        .toList();
  }

  AudioInfo _mapVideoToInfo(Video metadata) {
    return AudioInfo(
      id: metadata.id.value,
      url: metadata.url,
      title: metadata.title,
      channel: metadata.author,
      duration: metadata.duration ?? Duration.zero,
      thumbnailUrl: metadata.thumbnails.maxResUrl,
    );
  }
}
