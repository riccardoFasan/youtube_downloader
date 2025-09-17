import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_downloader/models/models.dart';
import 'package:youtube_downloader/utils/colors.dart';

class SelectModalSheet<T> extends StatefulWidget {
  final String _title;
  final List<Option<T>> _options;
  final Function _onSelected;
  final T _selected;

  const SelectModalSheet({
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
  State<SelectModalSheet<T>> createState() => _SelectModalSheetState<T>();
}

class _SelectModalSheetState<T> extends State<SelectModalSheet<T>> {
  late Rx<Option> _option;

  @override
  void initState() {
    super.initState();
    _option = _getSelectedOption(widget._selected).obs;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 22, left: 22, right: 22),
          margin: const EdgeInsets.only(bottom: 12),
          child: Text(
            widget._title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        ...widget._options.map((Option option) => _buildOption(option))
      ],
    );
  }

  Option _getSelectedOption(T value) {
    return widget._options.firstWhere((option) => option.value == value);
  }

  Widget _buildOption(Option option) {
    return Obx(
      () => ListTile(
        // ignore: deprecated_member_use
        leading: Radio<dynamic>(
          activeColor: AppColors.red,
          value: option.value,
          // ignore: deprecated_member_use
          groupValue: _option.value.value,
          // ignore: deprecated_member_use
          onChanged: (dynamic value) {
            _option.value = option;
            widget._onSelected(value);
          },
        ),
        title: Text(
          option.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        selected: _option.value.value == option.value,
        onTap: () {
          _option.value = option;
          widget._onSelected(option.value);
        },
      ),
    );
  }
}
