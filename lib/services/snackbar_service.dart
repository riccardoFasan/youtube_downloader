import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuotube_downloader/utils/colors.dart';
import 'package:yuotube_downloader/utils/icons.dart';

class SnackbarService {
  void showDownloadCompletd(String title) {
    Get.snackbar(
      'Download completed.',
      '"$title" has been downloaded successfully.',
      colorText: AppColors.white,
      backgroundColor: AppColors.green,
      icon: const Icon(
        AppIcons.cloudDownload,
        color: AppColors.white,
      ),
      onTap: (GetSnackBar snack) => Get.toNamed('/home'),
    );
  }

  void showDownloadError() {
    Get.snackbar(
      'Error during download.',
      'There was an error during downloading and saving.',
      colorText: AppColors.white,
      backgroundColor: AppColors.red,
      icon: const Icon(
        AppIcons.cloudClose,
        color: AppColors.white,
      ),
    );
  }

  void showSearchError() {
    Get.snackbar(
      'Error during search.',
      'The search was unsuccessful.',
      colorText: Colors.white,
      backgroundColor: AppColors.red,
      icon: const Icon(
        AppIcons.cloudClose,
        color: AppColors.white,
      ),
    );
  }
}
