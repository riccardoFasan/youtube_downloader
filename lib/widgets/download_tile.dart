import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';
import 'package:yuotube_downloader/models/models.dart';

class DownloadTile extends StatelessWidget {
  final Download _download;
  final Function _cancelCallback;

  const DownloadTile({super.key, download, cancelCallback})
      : _download = download,
        _cancelCallback = cancelCallback;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: <SlidableAction>[
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.close,
            onPressed: (BuildContext _) => _cancelCallback(_download),
          )
        ],
      ),
      child: ListTile(
        leading: VideoThumbnail(url: _download.info?.thumbnailUrl),
        title: Text(
          _download.info?.title ?? '',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          _download.info?.channel ?? '',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color.fromARGB(185, 255, 255, 255)),
        ),
        trailing: const SizedBox(
          width: 25.0,
          height: 25.0,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFff0000),
              strokeWidth: 2.75,
            ),
          ),
        ),
      ),
    );
  }
}
