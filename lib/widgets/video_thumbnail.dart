import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  Widget _buildImage() {
    if (_url == null) return _buildPlaceholderImage();
    return _buildNetworkImage();
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: _url!,
      placeholder: (BuildContext context, String url) => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Color(0xFFff0000),
            strokeWidth: 2.75,
          ),
        ),
      ),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          _buildPlaceholderImage(),
      fit: BoxFit.cover,
    );
  }

  Widget _buildPlaceholderImage() {
    return const Image(
      image: AssetImage(_placeholderPath),
      fit: BoxFit.cover,
    );
  }
}
