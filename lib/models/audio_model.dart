import 'dart:convert';

import 'package:youtube_downloader/models/models.dart';

class Audio extends AudioInfo {
  String path;
  List<Segment> sponsorsedSegments;

  Audio({
    required super.id,
    required super.url,
    required super.title,
    required super.channel,
    required super.duration,
    super.thumbnailMaxResUrl,
    super.thumbnailMinResUrl,
    required this.path,
    required this.sponsorsedSegments,
  });

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
      thumbnailMaxResUrl: json['thumbnailMaxResUrl'],
      thumbnailMinResUrl: json['thumbnailMinResUrl'],
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
      'thumbnailMaxResUrl': thumbnailMaxResUrl,
      'thumbnailMinResUrl': thumbnailMinResUrl,
      'path': path,
      'sponsorsedSegments':
          jsonEncode(sponsorsedSegments.map((s) => s.toJson()).toList())
    };
  }
}
