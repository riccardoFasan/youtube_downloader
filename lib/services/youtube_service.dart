import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yuotube_downloader/models/audio_info_model.dart';

class YouTubeService {
  final YoutubeExplode yte = YoutubeExplode();

  Future<AudioInfo> getInfo(String url) async {
    final Video metadata = await yte.videos.get(url);
    return AudioInfo(
      id: metadata.id.value,
      url: url,
      title: metadata.title,
      channel: metadata.author,
      thumbnailUrl: metadata.thumbnails.maxResUrl,
    );
  }

  Future<Stream<List<int>>> download(String videoId) async {
    final StreamManifest manifest =
        await yte.videos.streamsClient.getManifest(videoId);
    final StreamInfo streamInfo = manifest.audioOnly.withHighestBitrate();
    return yte.videos.streamsClient.get(streamInfo);
  }
}
