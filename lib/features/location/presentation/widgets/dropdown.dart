import 'package:flutter/material.dart';

class Dropdown<T> extends StatelessWidget {
  final List<T> dataSet;
  final String Function(T) labelBuilder;
  final ValueChanged<T?>? onSelected;
  final T? initialSelection;
  final bool? enabled;
  final String? hintText;
  final TextEditingController controller;

  const Dropdown({
    super.key,
    required this.controller,
    required this.dataSet,
    required this.labelBuilder,
    this.onSelected,
    this.initialSelection,
    this.enabled,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownMenu<T>(
        controller: controller,
        hintText: hintText,
        enabled: enabled ?? true,
        initialSelection: initialSelection,
        onSelected: onSelected,
        dropdownMenuEntries: dataSet
            .map(
              (item) =>
                  DropdownMenuEntry<T>(value: item, label: labelBuilder(item)),
            )
            .toList(),
      ),
    );
  }
}
