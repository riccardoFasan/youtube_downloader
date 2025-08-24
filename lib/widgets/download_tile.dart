import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class DownloadTile extends StatelessWidget {
  final Download _download;

  const DownloadTile({super.key, download}) : _download = download;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_download.duration);
    final String channel = _download.channel;

    return InkWell(
      key: super.key!,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 65,
              width: 65,
              child: VideoThumbnail(
                radius: 5,
                url: _download.thumbnailMinResUrl,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _download.title,
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
            Container(
              width: 34.5,
              height: 34.5,
              margin: const EdgeInsets.fromLTRB(32.0, 0, 5.75, 0),
              child: Center(
                child: Obx(
                  () => Stack(
                    children: <Widget>[
                      CircularProgressIndicator(
                        value: _download.progress.value > 0
                            ? _download.progress.value.toDouble() / 100
                            : null,
                        color: AppColors.red,
                        strokeWidth: 2.75,
                      ),
                      if (_download.progress.value > 0)
                        Center(
                          child: Text(
                            '${_download.progress.value}%',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
