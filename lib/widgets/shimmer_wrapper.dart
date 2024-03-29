import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:youtube_downloader/utils/colors.dart';

class ShimmerWrapper extends StatelessWidget {
  final Widget _child;

  const ShimmerWrapper({super.key, child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1500),
      color: AppColors.mediumGray,
      colorOpacity: .075,
      direction: const ShimmerDirection.fromLeftToRight(),
      child: _child,
    );
  }
}
