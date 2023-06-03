import 'package:yuotube_downloader/models/audio_info_model.dart';

class Download {
  String url;
  AudioInfo info;

  Download({
    required this.url,
    required this.info,
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      url: json['url'],
      info: AudioInfo.fromJson(json['info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'info': info.toJson(),
    };
  }
}
