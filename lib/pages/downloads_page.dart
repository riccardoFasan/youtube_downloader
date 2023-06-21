import 'package:flutter/material.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YouTube Downloader',
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: AudiosList()),
          SizedBox(width: double.maxFinite, child: Player()),
        ],
      ),
    );
  }
}
