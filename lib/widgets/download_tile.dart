import 'package:flutter/material.dart';
import 'package:yuotube_downloader/utils/utils.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';
import 'package:yuotube_downloader/models/models.dart';

class DownloadTile extends StatelessWidget {
  final AudioInfo _download;
  final Function _cancelCallback;

  const DownloadTile({super.key, download, cancelCallback})
      : _download = download,
        _cancelCallback = cancelCallback;

  @override
  Widget build(BuildContext context) {
    final String duration = printDuration(_download.duration);
    final String channel = _download.channel;
    return Dismissible(
      key: super.key!,
      onDismissed: (direction) => _cancelCallback(_download),
      background: _buildSlideBackground(),
      secondaryBackground: _buildSlideBackground(secondary: true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 65,
              width: 65,
              child: VideoThumbnail(
                radius: 5,
                url: _download.thumbnailUrl,
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
              width: 32.0,
              height: 32.0,
              margin: const EdgeInsets.fromLTRB(32.0, 0, 5.75, 0),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.red,
                  strokeWidth: 2.75,
                ),
              ),
            ),
          ],
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
      AppIcons.dismiss,
      color: Colors.white,
      size: 19,
    );
  }
}
