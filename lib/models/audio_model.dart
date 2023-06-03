import 'package:yuotube_downloader/models/audio_info_model.dart';

class Audio extends AudioInfo {
  String fileUri;

  Audio({
    required String id,
    required String url,
    required String title,
    required String channel,
    required int duration,
    String? thumbnailUrl,
    required this.fileUri,
  }) : super(
          id: id,
          url: url,
          title: title,
          channel: channel,
          duration: duration,
          thumbnailUrl: thumbnailUrl,
        );

  @override
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      channel: json['channel'],
      duration: json['duration'],
      thumbnailUrl: json['thumbnailUrl'],
      fileUri: json['fileUri'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'channel': channel,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
      'fileUri': fileUri,
    };
  }
}
