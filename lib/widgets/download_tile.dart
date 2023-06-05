import 'package:flutter/material.dart';
import 'package:yuotube_downloader/models/download_model.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadTile extends StatelessWidget {
  final Download _download;

  const DownloadTile({super.key, download}) : _download = download;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: VideoThumbnail(url: _download.info?.thumbnailUrl),
      title:
          _download.info == null ? const Text('') : Text(_download.info!.title),
      trailing: const CircularProgressIndicator(),
    );
  }
}
