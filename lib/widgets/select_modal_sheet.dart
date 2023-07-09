import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/utils/colors.dart';

class SelectModalSheet<T> extends StatelessWidget {
  final String _title;
  final List<Option<T>> _options;
  final Function _onSelected;
  final T _selected;

  late Rx<Option> _option;

  SelectModalSheet({
    super.key,
    required title,
    required options,
    required onSelected,
    required selected,
  })  : _title = title,
        _options = options,
        _onSelected = onSelected,
        _selected = selected;

  @override
  Widget build(BuildContext context) {
    _option = _getSelectedOption(_selected).obs;

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 22, left: 22, right: 22),
          margin: const EdgeInsets.only(bottom: 12),
          child: Text(
            _title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        ..._options.map((Option option) => _buildOption(option))
      ],
    );
  }

  Option _getSelectedOption(T value) {
    return _options.firstWhere((option) => option.value == value);
  }

  Widget _buildOption(Option option) {
    return Obx(
      () => RadioListTile(
        activeColor: AppColors.red,
        selected: _option.value.value == option.value,
        title: Text(
          option.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        groupValue: _option.value.value,
        value: option.value,
        onChanged: (dynamic value) {
          _option.value = option;
          _onSelected(value);
        },
      ),
    );
  }
}
