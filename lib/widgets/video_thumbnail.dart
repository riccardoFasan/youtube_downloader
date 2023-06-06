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
          borderRadius: BorderRadius.circular(8.0), child: _buildImage()),
    );
  }

  Image _buildImage() {
    if (_url == null) return _buildPlaceholderImage();
    return _buildNetworkImage();
  }

  Image _buildNetworkImage() {
    return Image(
      image: NetworkImage(_url!),
      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      fit: BoxFit.cover,
    );
  }

  Image _buildPlaceholderImage() {
    return const Image(
      image: AssetImage(_placeholderPath),
      fit: BoxFit.cover,
    );
  }
}
