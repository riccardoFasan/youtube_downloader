import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/controllers/controllers.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/utils/colors.dart';
import 'package:youtube_downloader/widgets/widgets.dart';

class SettingsModalSheet extends StatelessWidget {
  final SettingsController _settingsController = Get.find<SettingsController>();
  final InfoController _infoController = Get.find<InfoController>();

  final List<Option> _concurrentDownloadsOptions = [
    Option<int>(label: '1', value: 1),
    Option<int>(label: '2', value: 2),
    Option<int>(label: '3', value: 3),
    Option<int>(label: '4', value: 4),
    Option<int>(label: '5', value: 5),
    Option<int>(label: '6', value: 6),
  ];

  SettingsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding:
              const EdgeInsets.only(top: 22, left: 22, right: 22, bottom: 11),
          child: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    activeTrackColor: AppColors.red,
                    trackOutlineColor: WidgetStateProperty.all(AppColors.red),
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
                  onTap: () => Get.bottomSheet(
                      SelectModalSheet(
                        title: 'Max concurrent downloads',
                        options: _concurrentDownloadsOptions,
                        onSelected: (int value) =>
                            _settingsController.setDownloadsQueueSize(value),
                        selected: _settingsController.downloadsQueueSize,
                      ),
                      barrierColor: Colors.black.withValues(alpha: .85),
                      backgroundColor: AppColors.black,
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 150),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 150)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 22,
                      right: 22,
                      bottom: 12,
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
                        Obx(
                          () => Text(
                            _settingsController.downloadsQueueSize.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 22,
                    right: 22,
                    bottom: 12,
                  ),
                  child: Center(
                    child: Text(
                      'YouTube Downloader - version ${_infoController.version}',
                      style: const TextStyle(
                        color: AppColors.lightGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
