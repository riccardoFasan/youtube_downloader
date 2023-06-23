import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:yuotube_downloader/utils/colors.dart';

class ColorService {
  Future<Color> generateColorFromImage(String? imageUrl) async {
    if (imageUrl == null) return AppColors.darkGray;
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    return paletteGenerator.dominantColor?.color ?? AppColors.darkGray;
  }
}
