import 'package:yuotube_downloader/models/audio_info_model.dart';

class Audio extends AudioInfo {
  Uri fileUri;

  Audio({
    required String id,
    required String url,
    required String title,
    required String channel,
    String? thumbnailUrl,
    required this.fileUri,
  }) : super(
          id: id,
          url: url,
          title: title,
          channel: channel,
          thumbnailUrl: thumbnailUrl,
        );

  @override
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      channel: json['channel'],
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
      'thumbnailUrl': thumbnailUrl,
      'fileUri': fileUri,
    };
  }
}
