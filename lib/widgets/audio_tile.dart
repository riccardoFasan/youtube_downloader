import 'package:flutter/material.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/widgets/widgets.dart';
import 'package:youtube_downloader/utils/utils.dart';

class AudioTile extends StatelessWidget {
  final Audio _audio;
  final Function _removeCallback;
  final Function _tapCallback;
  final bool _current;
  final bool _playing;

  const AudioTile(
      {super.key, audio, removeCallback, tapCallback, current, playing})
      : _audio = audio,
        _removeCallback = removeCallback,
        _tapCallback = tapCallback,
        _current = current,
        _playing = playing;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_audio.duration);
    final String channel = _audio.channel;
    return DismissableTile(
      key: super.key!,
      snackbarText: 'Are you sure you want to delete this file?',
      dismissCallback: () => _removeCallback(_audio),
      icon: AppIcons.trash,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () => _tapCallback(_audio),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 65,
                width: 65,
                child: VideoThumbnail(
                  radius: 5,
                  url: _audio.thumbnailMinResUrl,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _audio.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        channel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        duration,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (_current)
                Container(
                  width: 22.0,
                  height: 22.0,
                  margin: const EdgeInsets.fromLTRB(32.0, 0, 5.75, 0),
                  child: Center(
                    child: MusicVisualizer(active: _playing),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
