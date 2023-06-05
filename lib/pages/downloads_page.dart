import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  final AudiosViewModel _modelView = Get.find();

  DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Downloader'),
      ),
      body: AudiosAndDownloadsList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.download),
        onPressed: () => _openDownloadDialog(),
      ),
    );
  }

  void _openDownloadDialog() {
    final TextEditingController input = TextEditingController();
    Get.defaultDialog(
      title: 'Download',
      content: TextFormField(
        controller: input,
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Undo'),
        ),
        TextButton(
          onPressed: () {
            if (input.value.text == '') return;
            _modelView.download(input.value.text);
            Get.back();
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}
