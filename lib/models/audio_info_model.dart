class AudioInfo {
  String id;
  String url;
  String title;
  String channel;
  Duration duration;
  String? thumbnailMaxResUrl;
  String? thumbnailMinResUrl;

  AudioInfo({
    required this.id,
    required this.url,
    required this.title,
    required this.channel,
    required this.duration,
    this.thumbnailMaxResUrl,
    this.thumbnailMinResUrl,
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
      thumbnailMaxResUrl: json['thumbnailMaxResUrl'],
      thumbnailMinResUrl: json['thumbnailMinResUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'channel': channel,
      'duration': duration.inMilliseconds,
      'thumbnailMaxResUrl': thumbnailMaxResUrl,
      'thumbnailMinResUrl': thumbnailMinResUrl,
    };
  }
}
