import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBackground extends StatelessWidget {
  final double _sigma;
  final Color _color;
  final double _radius;
  final double _opacity;
  final Widget _child;
  final BoxFit _fit;
  final double? _height;
  final String? _url;

  const BlurredBackground({
    super.key,
    required Widget child,
    double sigma = 32,
    Color color = Colors.black,
    double radius = 0,
    double opacity = .25,
    BoxFit fit = BoxFit.fill,
    double? height,
    String? url,
  })  : _sigma = sigma,
        _color = color,
        _radius = radius,
        _opacity = opacity,
        _child = child,
        _fit = fit,
        _height = height,
        _url = url;

  @override
  Widget build(BuildContext context) {
    if (_url == null) {
      return Container(
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          color: _color,
        ),
        child: _child,
      );
    }

    return Container(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        color: _color,
        image: DecorationImage(
          image: NetworkImage(
            _url!,
          ),
          fit: _fit,
          opacity: _opacity,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _sigma,
            sigmaY: _sigma,
          ),
          child: _child,
        ),
      ),
    );
  }
}
