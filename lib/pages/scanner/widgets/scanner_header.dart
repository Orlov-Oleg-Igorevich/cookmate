import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';

class ScannerHeader extends StatelessWidget {
  const ScannerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdBorder,
            color: AppColors.primary,
          ),
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Icon(Icons.gesture_rounded, color: AppColors.white, size: 14),
        ),
        Text('PantryAI', style: AppTextStyles.heading3),
      ],
    );
  }
}
