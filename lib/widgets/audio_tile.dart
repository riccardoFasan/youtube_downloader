import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yuotube_downloader/models/models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

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
    return Slidable(
      // key: ValueKey(_todo.description),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: <SlidableAction>[
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (BuildContext _) => _removeCallback(_audio),
          )
        ],
      ),
      child: ListTile(
        leading: VideoThumbnail(url: _audio.thumbnailUrl),
        title: Text(
          _audio.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _audio.channel,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _tapCallback(_audio),
        ),
        onTap: () => _tapCallback(_audio),
      ),
    );
  }
}
