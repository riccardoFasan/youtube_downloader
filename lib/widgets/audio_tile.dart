import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: <SlidableAction>[
          SlidableAction(
            backgroundColor: Colors.red,
            icon: AppIcons.trash,
            onPressed: (BuildContext _) => _removeCallback(_audio),
          )
        ],
      ),
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
}
