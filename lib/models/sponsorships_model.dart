import 'package:yuotube_downloader/models/segment_model.dart';

class Sponsorships {
  final String videoId;
  final List<Segment> segments;

  Sponsorships({required this.videoId, required this.segments});
}
