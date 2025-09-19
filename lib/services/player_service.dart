import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_downloader/models/audio_model.dart';
import 'package:youtube_downloader/services/audio_handler_service.dart';

class PlayerService {
  AudioHandlerService? _audioHandler;
  final Rx<bool> initialized = false.obs;

  Future<void> Function()? onSkipToNext;
  Future<void> Function()? onSkipToPrevious;

  Stream<Duration>? get position => _audioHandler?.positionStream;
  Stream<PlayerState>? get state => _audioHandler?.playerStateStream;
  Stream<Duration?>? get duration => _audioHandler?.durationStream;

  void play() {
    _audioHandler?.play();
  }

  void pause() {
    _audioHandler?.pause();
  }

  void stop() {
    _audioHandler?.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioHandler?.seek(position);
  }

  Future<void> setSource(Audio audio) async {
    final AudioSource source = AudioSource.uri(
      Uri.parse(audio.path),
      tag: MediaItem(
        id: audio.id,
        album: audio.channel,
        title: audio.title,
        artist: audio.channel,
        duration: audio.duration,
        artUri: audio.thumbnailMaxResUrl != null
            ? Uri.parse(audio.thumbnailMaxResUrl!)
            : null,
      ),
    );
    await _audioHandler?.setAudioSource(source);
    await _audioHandler?.seek(Duration.zero);
    await _audioHandler?.pause(); // ! prevent auto play
  }

  Future<void> init() async {
    if (initialized.isTrue) return;

    _audioHandler = await AudioService.init(
      builder: () => AudioHandlerService(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.richard.youtube_downloader.player',
        androidNotificationChannelName: 'YouTube Downloader',
        androidNotificationOngoing: false,
        preloadArtwork: true,
        androidStopForegroundOnPause: false,
        androidNotificationChannelDescription: 'YouTube Downloader controls',
        androidNotificationIcon: 'mipmap/ic_launcher',
        fastForwardInterval: const Duration(seconds: 15),
        rewindInterval: const Duration(seconds: 15),
        androidResumeOnClick: true,
        androidNotificationClickStartsActivity: true,
      ),
    );

    _audioHandler?.setSkipCallbacks(
      onNext: () async => onSkipToNext?.call(),
      onPrevious: () async => onSkipToPrevious?.call(),
    );

    initialized.value = true;
  }
}
