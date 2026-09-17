import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(thickness: 1, color: AppColors.span),
          ColoredBox(
            color: AppColors.base,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text('или', style: AppTextStyles.caption),
            ),
          ),
        ],
      ),
    );
  }
}
