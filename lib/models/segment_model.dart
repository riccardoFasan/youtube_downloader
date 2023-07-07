class Segment {
  final Duration startPosition;
  final Duration endPosition;

  Segment({
    required this.startPosition,
    required this.endPosition,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      startPosition: Duration(milliseconds: json['startPosition']),
      endPosition: Duration(milliseconds: json['endPosition']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startPosition': startPosition.inMilliseconds,
      'endPosition': endPosition.inMilliseconds,
    };
  }
}
