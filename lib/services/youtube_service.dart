import 'dart:async';
import 'dart:isolate';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yuotube_downloader/models/models.dart';

class YouTubeService {
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

  Future<List<AudioInfo>> search(String query) async {
    final YoutubeExplode yte = YoutubeExplode();
    final VideoSearchList searchList = await yte.search.search(query);
    yte.close();
    List<AudioInfo> results =
        searchList.map((Video metadata) => _mapVideoToInfo(metadata)).toList();
    return results;
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
