import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  final AudiosViewModel _modelView = Get.find();

  DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YouTube Downloader',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: AudiosAndDownloadsList(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 156, 0, 0),
        onPressed: () => _openDownloadDialog(),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
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
