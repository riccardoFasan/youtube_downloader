import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/utils/colors.dart';
import 'package:youtube_downloader/utils/icons.dart';

class SnackbarService {
  void showDownloadCompletd(String title) {
    Get.snackbar(
        'Download completed.', '"$title" has been downloaded successfully.',
        colorText: AppColors.green,
        backgroundColor: AppColors.darkGray,
        icon: const Icon(
          AppIcons.cloudDownload,
          color: AppColors.green,
        ),
        duration: const Duration(milliseconds: 1500),
        borderRadius: 12,
        overlayColor: AppColors.black.withValues(alpha: .5),
        overlayBlur: 8);
  }

  void showDownloadError() {
    Get.snackbar('Error during download.',
        'There was an error during downloading and saving.',
        colorText: AppColors.red,
        backgroundColor: AppColors.darkGray,
        icon: const Icon(
          AppIcons.cloudClose,
          color: AppColors.white,
        ),
        duration: const Duration(milliseconds: 1500),
        borderRadius: 12,
        overlayColor: AppColors.black.withValues(alpha: .5),
        overlayBlur: 8);
  }

  void showSearchError() {
    Get.snackbar('Error during search.', 'The search was unsuccessful.',
        colorText: AppColors.red,
        backgroundColor: AppColors.darkGray,
        icon: const Icon(
          AppIcons.cloudClose,
          color: AppColors.white,
        ),
        duration: const Duration(milliseconds: 1500),
        borderRadius: 12,
        overlayColor: AppColors.black.withValues(alpha: .5),
        overlayBlur: 8);
  }

  void showDownloadsQueueError() {
    Get.snackbar('Error before download.',
        'You have reached the maximum number of parallel downloads.',
        colorText: AppColors.red,
        backgroundColor: AppColors.darkGray,
        icon: const Icon(
          AppIcons.cloudClose,
          color: AppColors.white,
        ),
        duration: const Duration(milliseconds: 1500),
        borderRadius: 12,
        overlayColor: AppColors.black,
        overlayBlur: 8);
  }
}
