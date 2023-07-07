import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';

class Download extends AudioInfo {
  RxInt progress;

  Download({
    required String id,
    required String url,
    required String title,
    required String channel,
    required Duration duration,
    String? thumbnailMaxResUrl,
    String? thumbnailMinResUrl,
    required this.progress,
  }) : super(
          id: id,
          url: url,
          title: title,
          channel: channel,
          duration: duration,
          thumbnailMaxResUrl: thumbnailMaxResUrl,
          thumbnailMinResUrl: thumbnailMinResUrl,
        );
}
