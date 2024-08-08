import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:youtube_downloader/utils/utils.dart';

class SeekerBar extends StatelessWidget {
  final Function _searchCallback;
  final Function _clearCallback;

  const SeekerBar({super.key, searchCallback, clearCallback})
      : _searchCallback = searchCallback,
        _clearCallback = clearCallback;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) focusNode.unfocus();
    });

    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      onChanged: (String query) => _searchCallback(query),
      backgroundColor:
          const WidgetStatePropertyAll<Color>(AppColors.darkGray),
      overlayColor: const WidgetStatePropertyAll<Color>(AppColors.darkGray),
      surfaceTintColor:
          const WidgetStatePropertyAll<Color>(AppColors.darkGray),
      elevation: const WidgetStatePropertyAll<double>(0),
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: const Icon(
        AppIcons.search,
        size: 18,
        color: AppColors.lightGray,
      ),
      constraints: const BoxConstraints(
        minHeight: 40,
        maxHeight: 50,
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.only(left: 16),
      ),
      side: WidgetStateProperty.all<BorderSide?>(
        const BorderSide(
          color: AppColors.gray,
          width: 1,
        ),
      ),
      trailing: [
        IconButton(
          padding: const EdgeInsets.all(16),
          icon: const Icon(
            AppIcons.dismiss,
            size: 12,
          ),
          onPressed: () {
            controller.clear();
            _clearCallback();
          },
        ),
      ],
    );
  }
}
