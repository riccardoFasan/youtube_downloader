import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/services/services.dart';

class PlayerController extends GetxController {
  final DownloadController _downloadController = Get.find<DownloadController>();
  final SettingsController _settingsController = Get.find<SettingsController>();
  final PlayerService _player = Get.find<PlayerService>();
  final Random _random = Random();

  final Rx<Duration> _currentPosition = Duration.zero.obs;
  Duration get currentPosition => _currentPosition.value;

  final Rx<bool> _playing = false.obs;
  bool get playing => _playing.value;

  final Rx<bool> _shuffle = false.obs;
  bool get shuffle => _shuffle.value;

  final Rx<bool> _loopOne = false.obs;
  bool get loopOne => _loopOne.value;

  final Rx<Audio> _selectedAudio = _placeholderAudio.obs;
  Audio get audio => _selectedAudio.value;

  bool get hasAudio => _selectedAudio.value.id != '';

  StreamSubscription<Duration>? _positionSinkSub;
  StreamSubscription<PlayerState>? _stateSinkSub;

  static final Audio _placeholderAudio = Audio(
      id: '',
      url: '',
      title: '',
      channel: '',
      duration: Duration.zero,
      path: '',
      sponsorsedSegments: []);

  static const int _seekDelta = 15000;

  @override
  void onInit() {
    super.onInit();

    _player.onSkipToNext = () async => playNext();
    _player.onSkipToPrevious = () async => playPrevious();

    _player.initialized.listen((bool initialized) {
      if (!initialized) {
        _disposeState();
        return;
      }
      _sinkState();
    });
  }

  @override
  void onClose() {
    super.onClose();
    _disposeState();
  }

  Future<void> setCurrentAudioAndPlay(Audio audio) async {
    final bool isNotSame = _selectedAudio.value.id != audio.id;

    if (isNotSame) {
      await _player.setSource(audio);
      _selectedAudio.value = audio;
    }

    _play();
  }

  void togglePlay() {
    if (!hasAudio) return;
    _playing.isTrue ? _pause() : _play();
  }

  void stop() {
    _player.stop();
    _disposePosition();
    _playing.value = false;
    _selectedAudio.value = _placeholderAudio;
    _currentPosition.value = Duration.zero;
  }

  void seekForward() {
    if (!hasAudio) return;
    final int milliseconds = _currentPosition.value.inMilliseconds + _seekDelta;
    final bool reachEnd =
        milliseconds > _selectedAudio.value.duration.inMilliseconds;
    final int target =
        reachEnd ? _selectedAudio.value.duration.inMilliseconds : milliseconds;
    seek(target);
  }

  void seekBackward() {
    if (!hasAudio) return;
    final int milliseconds = _currentPosition.value.inMilliseconds - _seekDelta;
    final bool reachStart = milliseconds < 0;
    final int target = reachStart ? 0 : milliseconds;
    seek(target);
  }

  void playPrevious() {
    if (!hasAudio) return;
    if (_loopOne.isTrue) {
      seek(0);
      return;
    }
    final Audio? targetAudio =
        _shuffle.isTrue ? _getRandomAudio() : _getPreviousAudio();
    if (targetAudio != null) setCurrentAudioAndPlay(targetAudio);
  }

  void playNext() {
    if (!hasAudio) return;
    if (_loopOne.isTrue) {
      seek(0);
      return;
    }
    final Audio? targetAudio =
        _shuffle.isTrue ? _getRandomAudio() : _getNextAudio();
    if (targetAudio != null) setCurrentAudioAndPlay(targetAudio);
  }

  void switchShuffle() {
    _shuffle.toggle();
  }

  void switchLoop() {
    _loopOne.toggle();
  }

  bool isSelected(Audio audio) {
    return _selectedAudio.value.id == audio.id;
  }

  Future<void> seek(int milliseconds) async {
    if (!hasAudio) return;
    final Duration position = Duration(milliseconds: milliseconds);
    if (_playing.isFalse) _currentPosition.value = position;
    await _player.seek(position);
  }

  void _play() {
    if (_playing.isTrue) return;
    _playing.value = true;
    _player.play();
    _sinkPosition();
  }

  void _pause() {
    if (_playing.isFalse) return;
    _playing.value = false;
    _player.pause();
    _disposePosition();
  }

  void _sinkState() {
    _stateSinkSub = _player.state?.listen((PlayerState event) {
      if (event.processingState != ProcessingState.completed) {
        _playing.value = event.playing;
        return;
      }
      playNext();
    });
  }

  void _sinkPosition() {
    _positionSinkSub = _player.position?.listen((Duration event) {
      if (_playing.isTrue) {
        if (_settingsController.shouldSkipSponsors) {
          final Segment? reachedSegment = _reachedASegment(event);
          if (reachedSegment != null) {
            seek(reachedSegment.endPosition.inMilliseconds);
            return;
          }
        }

        _currentPosition.value = event;
      }
    });
  }

  void _disposeState() {
    if (_stateSinkSub != null) {
      _stateSinkSub!.cancel();
      _stateSinkSub = null;
    }
  }

  void _disposePosition() {
    if (_positionSinkSub != null) {
      _positionSinkSub!.cancel();
      _positionSinkSub = null;
    }
  }

  Audio? _getPreviousAudio() {
    if (!hasAudio) return null;
    final int index = _downloadController.audios
        .indexWhere((Audio audio) => audio.id == _selectedAudio.value.id);
    return index == 0
        ? _downloadController.audios.last
        : _downloadController.audios[index - 1];
  }

  Audio? _getNextAudio() {
    if (!hasAudio) return null;
    final int index = _downloadController.audios
        .indexWhere((Audio audio) => audio.id == _selectedAudio.value.id);
    return index == _downloadController.audios.length - 1
        ? _downloadController.audios.first
        : _downloadController.audios[index + 1];
  }

  Audio _getRandomAudio() {
    final int width = _random.nextInt(_downloadController.audios.length);
    final Audio randomAudio = _downloadController.audios[width];
    if (randomAudio.id == _selectedAudio.value.id) return _getRandomAudio();
    return randomAudio;
  }

  Segment? _reachedASegment(Duration position) {
    return _selectedAudio.value.sponsorsedSegments
        .firstWhereOrNull((Segment segment) {
      return position.inMilliseconds >= segment.startPosition.inMilliseconds &&
          position.inMilliseconds <= segment.endPosition.inMilliseconds;
    });
  }
}
