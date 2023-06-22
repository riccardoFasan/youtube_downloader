import 'package:flutter/material.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';
import 'package:yuotube_downloader/models/models.dart';

class ResultTile extends StatelessWidget {
  final AudioInfo _result;
  final Function _downloadCallback;

  const ResultTile({super.key, result, downloadCallback})
      : _result = result,
        _downloadCallback = downloadCallback;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_result.duration);
    final String channel = _result.channel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 65,
            width: 65,
            child: VideoThumbnail(url: _result.thumbnailUrl),
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
                      color: AppColors.lightgray,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    duration,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.lightgray,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            color: AppColors.white,
            onPressed: () => _downloadCallback(),
            icon: const Icon(
              AppIcons.download,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
