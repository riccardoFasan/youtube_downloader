import 'dart:async';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yuotube_downloader/models/models.dart';

class YouTubeService {
  Future<AudioInfo> getInfo(String url) async {
    final YoutubeExplode yte = YoutubeExplode();
    final Video metadata = await yte.videos.get(url);
    yte.close();
    return AudioInfo(
      id: metadata.id.value,
      url: url,
      title: metadata.title,
      channel: metadata.author,
      duration: metadata.duration ?? Duration.zero,
      thumbnailUrl: metadata.thumbnails.maxResUrl,
    );
  }

  Future<List<int>> download(String videoId) async {
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
  }
}
