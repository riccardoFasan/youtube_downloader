import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';

class Download extends AudioInfo {
  RxInt progress;

  Download({
    required super.id,
    required super.url,
    required super.title,
    required super.channel,
    required super.duration,
    super.thumbnailMaxResUrl,
    super.thumbnailMinResUrl,
    required this.progress,
  });
}
