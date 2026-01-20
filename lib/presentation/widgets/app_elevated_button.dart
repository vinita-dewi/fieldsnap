import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;

  const AppElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: AppTextStyles.textTheme.labelLarge?.copyWith(
          color: AppColors.onPrimary,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );

    if (!isFullWidth) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
