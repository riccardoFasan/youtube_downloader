import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuotube_downloader/view_models/view_models.dart';
import 'package:yuotube_downloader/widgets/widgets.dart';

class DownloadsPage extends StatelessWidget {
  final AudiosViewModel _modelView = Get.find<AudiosViewModel>();

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
        actions: [
          IconButton(
            color: const Color.fromARGB(255, 156, 0, 0),
            onPressed: () => _openDownloadDialog(),
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: AudiosAndDownloadsList()),
          SizedBox(width: double.maxFinite, child: Player()),
        ],
      ),
    );
  }

  void _openDownloadDialog() {
    final TextEditingController input = TextEditingController();
    Get.defaultDialog(
      title: 'Paste YouTube URL here',
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFF222222),
      titleStyle: GoogleFonts.lato(
        color: Colors.white,
        fontSize: 16,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      content: TextFormField(
        controller: input,
        style: GoogleFonts.lato(
          color: Colors.white,
        ),
        cursorColor: const Color.fromARGB(255, 156, 0, 0),
        decoration: const InputDecoration(
          label: Text('YouTube URL'),
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 156, 0, 0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 156, 0, 0),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 156, 0, 0),
            ),
          ),
        ),
      ),
      actions: <TextButton>[
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              const Color.fromARGB(20, 156, 0, 0),
            ),
          ),
          onPressed: () => Get.back(),
          child: const Text(
            'Undo',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              const Color.fromARGB(20, 156, 0, 0),
            ),
          ),
          onPressed: () {
            if (input.value.text == '') return;
            _modelView.download(input.value.text);
            Get.back();
          },
          child: const Text(
            'Download',
            style: TextStyle(
              color: Color.fromARGB(255, 224, 3, 3),
            ),
          ),
        )
      ],
    );
  }
}
