import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarService {
  void showDownloadError() {
    Get.snackbar(
      'Error during download.',
      'There was an error during downloading and saving.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error),
    );
  }

  void showSearchError() {
    Get.snackbar(
      'Error during search.',
      'The search was unsuccessful.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error),
    );
  }
}
