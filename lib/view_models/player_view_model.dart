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

  @override
  void onClose() {
    super.onClose();
    _dispose();
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
    _playing.isTrue ? _pause() : _play();
  }

  Future<void> seekForward() async {
    final int milliseconds = _currentPosition.value.inMilliseconds + 15000;
    if (milliseconds > _currentAudio.value.duration.inMilliseconds) return;
    final Duration position = Duration(milliseconds: milliseconds);
    await _player.seek(position);
  }

  Future<void> seekBackward() async {
    final int milliseconds = _currentPosition.value.inMilliseconds - 15000;
    if (milliseconds < 0) return;
    final Duration position = Duration(milliseconds: milliseconds);
    await _player.seek(position);
  }

  bool get _shouldStop =>
      _currentPosition.value.inMilliseconds >=
      _currentAudio.value.duration.inMilliseconds;

  void _play() {
    if (_playing.isTrue) return;
    _player.play();
    _playing.toggle();
    _sink();
  }

  void _pause() {
    if (_playing.isFalse) return;
    _player.pause();
    _playing.toggle();
    _dispose();
  }

  void _sink() {
    _positionSinkSub = _player.position.listen((Duration event) {
      if (_playing.isTrue) _currentPosition.value = event;
    });
    _stateSinkSub = _player.onComplete.listen((PlayerState event) {
      _playing.value = false;
      _currentAudio.value = _placeholderAudio;
      _currentPosition.value = Duration.zero;
    });
  }

  void _dispose() {
    if (_positionSinkSub != null) {
      _positionSinkSub!.cancel();
      _positionSinkSub = null;
    }
    if (_stateSinkSub != null) {
      _stateSinkSub!.cancel();
      _stateSinkSub = null;
    }
  }
}
