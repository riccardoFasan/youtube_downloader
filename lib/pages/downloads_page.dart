import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/services/services.dart';

class DownloadsPage extends StatelessWidget {
  final YouTubeService _yt = Get.find();

  DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Download'),
          onPressed: () async {
            await _yt.getInfo('https://www.youtube.com/watch?v=5qap5aO4i9A');
          },
        ),
      ),
    );
  }
}
