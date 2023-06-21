import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yuotube_downloader/view_models/player_view_model.dart';
import 'package:yuotube_downloader/utils/utils.dart';

class Player extends StatelessWidget {
  final PlayerViewModel _viewModel = Get.find<PlayerViewModel>();

  Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xFF222222),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 6, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildAudioTitle(),
                  _buildAudioChannelName()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: _buildTimeIndicator(),
            ),
            SizedBox(
              height: 38,
              width: 38,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                color: const Color.fromARGB(255, 156, 0, 0),
                onPressed: () => _viewModel.seekBackward(),
                icon: const Icon(
                  Icons.undo,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 38,
              width: 38,
              child: _buildPlayPauseButton(),
            ),
            SizedBox(
              height: 38,
              width: 38,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                color: const Color.fromARGB(255, 156, 0, 0),
                onPressed: () => _viewModel.seekForward(),
                icon: const Icon(
                  Icons.redo,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioTitle() {
    return Obx(
      () => Text(
        _viewModel.audio.title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAudioChannelName() {
    return Obx(
      () => Text(
        _viewModel.audio.channel,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color.fromARGB(185, 255, 255, 255),
        ),
      ),
    );
  }

  Widget _buildTimeIndicator() {
    return Obx(
      () => Text(
        '${printDuration(_viewModel.audio.id != '' ? _viewModel.currentPosition : Duration.zero)} /\n ${printDuration(_viewModel.audio.duration)}',
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color.fromARGB(185, 255, 255, 255),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      color: const Color.fromARGB(255, 156, 0, 0),
      onPressed: () => _viewModel.togglePlay(),
      icon: Obx(
        () => Icon(
          _viewModel.playing == true ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
