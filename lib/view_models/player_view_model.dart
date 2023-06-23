import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yuotube_downloader/models/audio_model.dart';
import 'package:yuotube_downloader/services/services.dart';
import 'package:yuotube_downloader/utils/colors.dart';
import 'package:yuotube_downloader/view_models/audios_view_model.dart';

class PlayerViewModel extends GetxController {
  final AudiosViewModel _audios = Get.find<AudiosViewModel>();
  final PlayerService _player = Get.find<PlayerService>();
  final ColorService _colors = Get.find<ColorService>();
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

  final Rx<Color> _backgroundColor = AppColors.darkGray.obs;
  Color get backgroundColor => _backgroundColor.value;

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
    if (_selectedAudio.value.id != audio.id) {
      await _player.setSource(audio);
      _selectedAudio.value = audio;
      _backgroundColor.value =
          await _colors.generateColorFromImage(audio.thumbnailUrl);
    }
    if (_selectedAudio.value.id != audio.id || !_playing.value) {
      _play();
    }
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
      playNext();
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

  Audio? _getPreviousAudio() {
    if (!hasAudio) return null;
    final int index = _audios.audios
        .indexWhere((Audio audio) => audio.id == _selectedAudio.value.id);
    return index == 0 ? _audios.audios.last : _audios.audios[index - 1];
  }

  Audio? _getNextAudio() {
    if (!hasAudio) return null;
    final int index = _audios.audios
        .indexWhere((Audio audio) => audio.id == _selectedAudio.value.id);
    return index == _audios.audios.length - 1
        ? _audios.audios.first
        : _audios.audios[index + 1];
  }

  Audio _getRandomAudio() {
    final int width = _random.nextInt(_audios.audios.length);
    final Audio randomAudio = _audios.audios[width];
    if (randomAudio.id == _selectedAudio.value.id) return _getRandomAudio();
    return randomAudio;
  }
}
