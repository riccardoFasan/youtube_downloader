import 'package:flutter/material.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';
import 'package:youtube_downloader/models/models.dart';

class ResultTile extends StatelessWidget {
  final AudioInfo _result;
  final bool _saved;
  final Function _tapCallback;

  const ResultTile({super.key, result, saved, tapCallback})
      : _result = result,
        _saved = saved,
        _tapCallback = tapCallback;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_result.duration);
    final String channel = _result.channel;
    return InkWell(
        onTap: () => _tapCallback(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 65,
                width: 65,
                child: VideoThumbnail(
                  radius: 5,
                  url: _result.thumbnailMinResUrl,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _result.title,
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
              if (!_saved)
                Container(
                  height: 44,
                  width: 44,
                  margin: const EdgeInsets.only(left: 2),
                  child: const Icon(
                    AppIcons.download,
                    size: 22,
                    color: AppColors.lightGray,
                  ),
                ),
              if (_saved)
                Container(
                  height: 44,
                  width: 44,
                  margin: const EdgeInsets.only(left: 8, right: 2),
                  child: const Icon(
                    AppIcons.cloudCheck,
                    size: 22,
                    color: AppColors.gray,
                  ),
                ),
            ],
          ),
        ));
  }
}
