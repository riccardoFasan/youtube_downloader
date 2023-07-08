import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/utils/colors.dart';

class SettingsModalSheet extends StatelessWidget {
  final SettingsController _settingsController = Get.find<SettingsController>();

  SettingsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 22, left: 22, right: 22),
          margin: const EdgeInsets.only(bottom: 12),
          child: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        Obx(
          () => SwitchListTile(
            activeTrackColor: AppColors.red,
            trackOutlineColor: MaterialStateProperty.all(AppColors.red),
            contentPadding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            value: _settingsController.shouldSkipSponsors,
            onChanged: (bool value) =>
                _settingsController.setShouldSkipSponsors(value),
            title: const Text(
              'Skip sponsors',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 22,
              right: 22,
              bottom: 22,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Max concurrent downloads',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _settingsController.downloadsQueueSize.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
