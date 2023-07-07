import 'dart:convert';

import 'package:youtube_downloader/models/models.dart';

class Audio extends AudioInfo {
  String path;
  List<Segment> sponsorsedSegments;

  Audio({
    required String id,
    required String url,
    required String title,
    required String channel,
    required Duration duration,
    String? thumbnailUrl,
    required this.path,
    required this.sponsorsedSegments,
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
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : Duration.zero,
      thumbnailUrl: json['thumbnailUrl'],
      path: json['path'],
      sponsorsedSegments: jsonDecode(json['sponsorsedSegments'])
          .map<Segment>((s) => Segment.fromJson(s))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'channel': channel,
      'duration': duration.inMilliseconds,
      'thumbnailUrl': thumbnailUrl,
      'path': path,
      'sponsorsedSegments':
          jsonEncode(sponsorsedSegments.map((s) => s.toJson()).toList())
    };
  }
}
