class AudioInfo {
  String id;
  String url;
  String title;
  String channel;
  Duration duration;
  String? thumbnailUrl;

  AudioInfo({
    required this.id,
    required this.url,
    required this.title,
    required this.channel,
    required this.duration,
    this.thumbnailUrl,
  });

  factory AudioInfo.fromJson(Map<String, dynamic> json) {
    return AudioInfo(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      channel: json['channel'],
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : Duration.zero,
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'channel': channel,
      'duration': duration.inMilliseconds,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
