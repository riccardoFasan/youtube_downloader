import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarService {
  void showError() {
    Get.snackbar(
      'Error during download',
      'Check your connection, remember that live videos are not supported.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error),
    );
  }
}
