import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
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
        expandedInsets: EdgeInsets.zero,
        hintText: hintText,
        enabled: enabled ?? true,
        initialSelection: initialSelection,
        onSelected: onSelected,
        textStyle: AppTextStyles.textTheme.bodyLarge,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: AppTextStyles.textTheme.bodyLarge!(
            color: AppColors.textSecondary,
          ),
        ),
        trailingIcon: Icon(Icons.keyboard_arrow_down),
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
