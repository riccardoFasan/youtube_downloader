import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';
import 'package:yuotube_downloader/utils/utils.dart';

class AudioTile extends StatelessWidget {
  final Audio _audio;
  final Function _removeCallback;
  final Function _tapCallback;

  const AudioTile({super.key, audio, removeCallback, tapCallback})
      : _audio = audio,
        _removeCallback = removeCallback,
        _tapCallback = tapCallback;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_audio.duration);
    final String channel = _audio.channel;
    return Dismissible(
      key: super.key!,
      onDismissed: (DismissDirection _) => _removeCallback(_audio),
      background: _buildSlideBackground(),
      secondaryBackground: _buildSlideBackground(secondary: true),
      child: InkWell(
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
                  url: _audio.thumbnailUrl,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideBackground({bool secondary = false}) {
    final Alignment alignment =
        secondary ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.red,
      child: Align(
        alignment: alignment,
        child: _buildDismissableIcon(),
      ),
    );
  }

  Widget _buildDismissableIcon() {
    return const Icon(
      AppIcons.trash,
      color: Colors.white,
      size: 19,
    );
  }
}
