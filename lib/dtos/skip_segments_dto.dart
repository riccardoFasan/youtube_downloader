class SkipSegmentDTO {
  final String uuid;
  final List<double> segment;
  final String category;
  final double videoDuration;
  final String actionType;
  final int locked;
  final int votes;
  final String description;

  SkipSegmentDTO({
    required this.uuid,
    required this.segment,
    required this.category,
    required this.videoDuration,
    required this.actionType,
    required this.locked,
    required this.votes,
    required this.description,
  });

  factory SkipSegmentDTO.fromJson(Map<String, dynamic> json) {
    return SkipSegmentDTO(
      uuid: json['UUID'],
      segment: List<double>.from(json['segment'].map((dynamic x) => x)),
      category: json['category'],
      videoDuration: json['videoDuration'],
      actionType: json['actionType'],
      locked: json['locked'],
      votes: json['votes'],
      description: json['description'],
    );
  }
}
