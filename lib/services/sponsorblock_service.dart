import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_downloader/dtos/skip_segments_dto.dart';
import 'package:youtube_downloader/models/models.dart';

class SponsorblockService {
  static const String _endpoint = 'https://sponsor.ajay.app';

  Future<Sponsorships> getSponsorships(String videoId) async {
    final response = await http
        .get(Uri.parse('$_endpoint/api/skipSegments?videoID=$videoId'));

    if (response.statusCode != 200) {
      return Sponsorships(
        videoId: videoId,
        segments: [],
      );
    }

    final List<SkipSegmentDTO> segments = _parseBody(response.body);

    return Sponsorships(
      videoId: videoId,
      segments: segments
          .map(
            (SkipSegmentDTO segment) => Segment(
              start: segment.segment[0].toInt(),
              end: segment.segment[1].toInt(),
            ),
          )
          .toList(),
    );
  }

  List<SkipSegmentDTO> _parseBody(String body) {
    return List<SkipSegmentDTO>.from(
      jsonDecode(body).cast<Map<String, dynamic>>().map(
            (dynamic json) => SkipSegmentDTO.fromJson(json),
          ),
    );
  }
}
