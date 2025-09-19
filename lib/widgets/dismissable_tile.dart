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
              borderRadius: BorderRadius.all(Radius.circular(16))),
          title: const Text('Are you sure?', style: TextStyle(fontSize: 22)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text(
                  _snackbarText,
                  style: const TextStyle(height: 1.5, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 4),
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(result: true),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.red),
                    overlayColor:
                        WidgetStatePropertyAll<Color>(AppColors.darkGray),
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16)),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(result: false),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
                    overlayColor:
                        WidgetStatePropertyAll<Color>(AppColors.darkGray),
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 16)),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        barrierColor: AppColors.black.withValues(alpha: .85));
    return confirmation ?? false;
  }
}
