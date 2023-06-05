import 'package:flutter/widgets.dart';

class VideoThumbnail extends StatelessWidget {
  static const String _placeholderPath = 'assets/images/placeholder.png';
  static const double _aspectRatio = 1 / 1;
  final String? _url;

  const VideoThumbnail({super.key, url}) : _url = url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: _url != null
            ? Image(
                image: NetworkImage(_url!),
                fit: BoxFit.cover,
              )
            : const Image(
                image: AssetImage(_placeholderPath),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
