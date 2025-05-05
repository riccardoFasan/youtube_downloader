import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:youtube_downloader/models/audio_model.dart';

class PlayerService {
  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;

  Stream<Duration> get position => _player.positionStream;
  Stream<PlayerState> get state => _player.playerStateStream;

  void play() {
    _player.play();
  }

  void pause() {
    _player.pause();
  }

  void stop() {
    _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setSource(Audio audio) async {
    final AudioSource source = AudioSource.uri(
      Uri.parse(audio.path),
      tag: MediaItem(
        id: audio.id,
        album: audio.title,
        title: audio.title,
        artUri: audio.thumbnailMaxResUrl != null
            ? Uri.parse(audio.thumbnailMaxResUrl!)
            : null,
      ),
    );
    await _player.setAudioSource(source);
    await _player.pause(); // ! prevent auto play
  }

  Future<void> init() async {
    if (_initialized) return;
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.richard.youtube_downloader.player',
      androidNotificationChannelName: 'YouTube Downloader',
      androidNotificationOngoing: true,
      preloadArtwork: true,
    );
    _initialized = true;
  }
}
