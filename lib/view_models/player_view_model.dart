import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yuotube_downloader/models/audio_model.dart';
import 'package:yuotube_downloader/services/player_service.dart';

class PlayerViewModel extends GetxController {
  final PlayerService _player = Get.find<PlayerService>();

  final Rx<Duration> _currentPosition = Duration.zero.obs;
  Duration get currentPosition => _currentPosition.value;

  final Rx<bool> _playing = false.obs;
  bool get playing => _playing.value;

  final Rx<Audio> _currentAudio = _placeholderAudio.obs;
  Audio get audio => _currentAudio.value;

  StreamSubscription<Duration>? _positionSinkSub;
  StreamSubscription<PlayerState>? _stateSinkSub;

  static final Audio _placeholderAudio = Audio(
    id: '',
    url: '',
    title: '',
    channel: '',
    duration: Duration.zero,
    path: '',
  );

  static const int _seekDelta = 15000;

  @override
  void onInit() {
    super.onInit();
    _sinkState();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeState();
  }

  Future<void> setCurrentAudioAndPlay(Audio audio) async {
    if (_currentAudio.value.id != audio.id) {
      await _player.setSource(audio);
      _currentAudio.value = audio;
    }
    if (_currentAudio.value.id != audio.id || !_playing.value) {
      _play();
    }
  }

  void togglePlay() {
    if (_currentAudio.value.id == '') return;
    _playing.isTrue ? _pause() : _play();
  }

  void seekForward() {
    if (_currentAudio.value.id == '') return;
    final int milliseconds = _currentPosition.value.inMilliseconds + _seekDelta;
    final bool reachEnd =
        milliseconds > _currentAudio.value.duration.inMilliseconds;
    final int target =
        reachEnd ? _currentAudio.value.duration.inMilliseconds : milliseconds;
    _seek(target);
  }

  void seekBackward() {
    if (_currentAudio.value.id == '') return;
    final int milliseconds = _currentPosition.value.inMilliseconds - _seekDelta;
    final bool reachStart = milliseconds < 0;
    final int target = reachStart ? 0 : milliseconds;
    _seek(target);
  }

  Future<void> _seek(int milliseconds) async {
    final Duration position = Duration(milliseconds: milliseconds);
    if (_playing.isFalse) _currentPosition.value = position;
    await _player.seek(position);
  }

  void _play() {
    if (_playing.isTrue) return;
    _playing.toggle();
    _player.play();
    _sinkPosition();
  }

  void _pause() {
    if (_playing.isFalse) return;
    _playing.toggle();
    _player.pause();
    _disposePosition();
  }

  void _sinkState() {
    _stateSinkSub = _player.state.listen((PlayerState event) {
      if (event.processingState != ProcessingState.completed) {
        _playing.value = event.playing;
        return;
      }
      _disposePosition();
      _playing.value = false;
      _currentAudio.value = _placeholderAudio;
      _currentPosition.value = Duration.zero;
    });
  }

  void _sinkPosition() {
    _positionSinkSub = _player.position.listen((Duration event) {
      if (_playing.isTrue) _currentPosition.value = event;
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
}
