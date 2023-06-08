import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yuotube_downloader/models/models.dart';

class TrimmerService {
  Future<void> removeSegments(
    Audio audio,
    List<Segment> segmentsToRemove,
  ) async {
    if (segmentsToRemove.isEmpty) return;

    final List<Segment> segmentsToSave = _getSegmentsToSave(segmentsToRemove);

    final String localPath = await _localPath;
    final String temporaryDir = "$localPath/ffmpeg_tmp/${audio.id}";
    await Directory(temporaryDir).create(recursive: true);

    String command =
        _buildTrimmingCommand(segmentsToSave, temporaryDir, audio.id);

    final FFmpegSession session =
        await FFmpegKit.execute('-i ${audio.path} $command');
    final ReturnCode? code = await session.getReturnCode();

    if (ReturnCode.isSuccess(code)) {
      final String summaryPath =
          await _writeSummary(segmentsToSave, temporaryDir, audio.id);

      final String trimmedFilePath = "$temporaryDir/${audio.id}_trimmed.mp3";
      final FFmpegSession session = await FFmpegKit.execute(
        '-f concat -safe 0 -i $summaryPath -c copy $trimmedFilePath',
      );

      final ReturnCode? code = await session.getReturnCode();

      if (ReturnCode.isSuccess(code)) {
        final File trimmedFile = File(trimmedFilePath);
        final File originalFile = File(audio.path);
        await originalFile.delete();
        await trimmedFile.rename(audio.path);
      }
    }

    await Directory(temporaryDir).delete(recursive: true);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  List<Segment> _getSegmentsToSave(List<Segment> segments) {
    final List<Segment> sortedSegments = [...segments];
    sortedSegments.sort((a, b) => a.start.compareTo(b.start));

    final List<Segment> segmentsToSave = [];

    sortedSegments.asMap().forEach((int index, Segment segment) {
      final int target = index - 1;
      final int start = index > 0 || sortedSegments.asMap().containsKey(target)
          ? sortedSegments.elementAt(target).end
          : 0;
      final int end = segment.start;
      segmentsToSave.add(Segment(start: start, end: end));
    });

    final Segment lastSegment = sortedSegments.last;
    segmentsToSave.add(Segment(start: lastSegment.end, end: 0));

    return segmentsToSave;
  }

  String _buildTrimmingCommand(
      List<Segment> segments, String directory, String audioId) {
    String command = '';
    segments.asMap().forEach((int index, Segment segment) async {
      final String tmpPath = "$directory/${audioId}_$index.mp3";
      if (segment.end == 0) {
        command += '-ss ${segment.start} $tmpPath ';
      } else {
        command += '-ss ${segment.start} -to ${segment.end} $tmpPath ';
      }
    });
    return command;
  }

  Future<String> _writeSummary(
      List<Segment> segments, String directory, String audioId) async {
    String content = '';
    segments.asMap().forEach((int index, Segment segment) async {
      final String tmpPath = "$directory/${audioId}_$index.mp3";
      content += 'file \'$tmpPath\'\n';
    });
    final String summaryPath = "$directory/${audioId}_summary.txt";
    final File summaryFile = File(summaryPath);
    await summaryFile.writeAsString(content);
    return summaryPath;
  }
}
