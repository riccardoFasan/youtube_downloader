import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/utils/utils.dart';

class VideoThumbnail extends StatelessWidget {
  static const String _placeholderPath = 'assets/images/placeholder.jpg';
  final String? _url;
  final double _radius;

  const VideoThumbnail({
    super.key,
    String? url,
    required double radius,
  })  : _url = url,
        _radius = radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: _buildImage(),
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
            color: AppColors.red,
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
