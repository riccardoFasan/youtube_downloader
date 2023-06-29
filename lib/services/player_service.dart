import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:yuotube_downloader/models/audio_model.dart';

class PlayerService {
  final AudioPlayer _player = AudioPlayer();

  PlayerService() {
    _init();
  }

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
        artUri:
            audio.thumbnailUrl != null ? Uri.parse(audio.thumbnailUrl!) : null,
      ),
    );
    await _player.setAudioSource(source);
    await _player.pause(); // ! prevent auto play
  }

  Future<void> _init() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.richard.youtube_downloader.player',
      androidNotificationChannelName: 'YouTube Dowloader',
      androidNotificationOngoing: true,
      preloadArtwork: true,
    );
  }
}
