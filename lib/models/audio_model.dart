import 'package:yuotube_downloader/models/models.dart';

class Audio extends AudioInfo {
  String path;
  List<Segment> sponsorships = [];

  Audio({
    required String id,
    required String url,
    required String title,
    required String channel,
    String? thumbnailUrl,
    required this.path,
    required this.sponsorships,
  }) : super(
            id: id,
            url: url,
            title: title,
            channel: channel,
            thumbnailUrl: thumbnailUrl);

  @override
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      channel: json['channel'],
      thumbnailUrl: json['thumbnailUrl'],
      path: json['path'],
      sponsorships: json['sponsorships'],
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
      'path': path,
      'sponsorships': sponsorships,
    };
  }
}
