import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/utils/colors.dart';

class DismissableTile extends StatelessWidget {
  final Function _dismissCallback;
  final IconData _icon;
  final String _snackbarText;
  final Widget _child;

  const DismissableTile({super.key, dismissCallback, icon, snackbarText, child})
      : _dismissCallback = dismissCallback,
        _icon = icon,
        _snackbarText = snackbarText,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: super.key!,
      confirmDismiss: (DismissDirection _) async => await _askConfirmation(),
      onDismissed: (DismissDirection _) => _dismissCallback(),
      background: _buildSlideBackground(),
      secondaryBackground: _buildSlideBackground(secondary: true),
      child: _child,
    );
  }

  Widget _buildSlideBackground({bool secondary = false}) {
    final Alignment alignment =
        secondary ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.darkRed,
      child: Align(
        alignment: alignment,
        child: Icon(
          _icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Future<bool> _askConfirmation() async {
    final bool? confirmation = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: const Text('Are you sure?'),
        content: Text(
          _snackbarText,
          style: const TextStyle(
            height: 1.5,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: false),
            style: const ButtonStyle(
              overlayColor: WidgetStatePropertyAll<Color>(AppColors.darkGray),
            ),
            child: const Text(
              'No',
              style: TextStyle(color: AppColors.white),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: const ButtonStyle(
              overlayColor: WidgetStatePropertyAll<Color>(AppColors.darkGray),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
    return confirmation ?? false;
  }
}
