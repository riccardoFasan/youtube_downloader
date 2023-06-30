import 'dart:math';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/utils/utils.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class SkeletonTile extends StatelessWidget {
  final Random _random = Random();

  SkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        children: <Widget>[
          ShimmerWrapper(
            child: Container(
              height: 65,
              width: 65,
              decoration: const BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSkeletonText(12, 325, 75, true),
                  _buildSkeletonText(10, 325, 75, true),
                  _buildSkeletonText(10, 75, 50, false)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonText(
      double height, int maxWidth, int minWidth, bool hasMargin) {
    final int width = minWidth + _random.nextInt(maxWidth - minWidth);
    return ShimmerWrapper(
      child: Container(
        height: height,
        width: width.toDouble(),
        margin: EdgeInsets.only(bottom: hasMargin ? 8 : 0),
        decoration: const BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
      ),
    );
  }
}
