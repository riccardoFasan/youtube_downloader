import "package:flutter/material.dart";
import "package:youtube_downloader/utils/utils.dart";

class MusicVisualizer extends StatelessWidget {
  final bool _active;

  const MusicVisualizer({
    super.key,
    required active,
  }) : _active = active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (_active) ...[
          const _VisualComponent(
            duration: 400,
          ),
          const _VisualComponent(
            duration: 700,
          ),
          const _VisualComponent(
            duration: 650,
          ),
        ],
        if (!_active) ...[
          const WaveBar(height: 2),
          const WaveBar(height: 2),
          const WaveBar(height: 2),
        ]
      ],
    );
  }
}

class _VisualComponent extends StatefulWidget {
  final int? duration;

  const _VisualComponent({
    required this.duration,
  });

  @override
  _VisualComponentState createState() => _VisualComponentState();
}

class _VisualComponentState extends State<_VisualComponent>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  bool _paused =
      false; // * prevent '_lifecycleState != _ElementLifecycle.defunct': is not true. error

  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    _paused = true;
    animation!.removeStatusListener((status) {});
    animation!.removeListener(() {});
    animationController!.stop();
    animationController!.reset();
    animationController!.dispose();
    super.dispose();
  }

  void animate() {
    animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration!), vsync: this);
    final curvedAnimation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInQuad,
    );
    animation = Tween<double>(begin: 0, end: 50).animate(curvedAnimation)
      ..addListener(() {
        update();
      });
    animationController!.repeat(reverse: true);
  }

  void update() {
    if (mounted && !_paused) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WaveBar(height: animation!.value);
  }
}

class WaveBar extends StatelessWidget {
  final double _height;

  const WaveBar({super.key, required double height}) : _height = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: 2.5,
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
