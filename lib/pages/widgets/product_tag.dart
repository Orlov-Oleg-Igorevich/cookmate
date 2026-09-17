import 'package:cookmate/design.dart';
import 'package:cookmate/design_system.dart';
import 'package:flutter/material.dart';

class ProductTag extends StatelessWidget {
  final String product;
  final TextStyle? textStyle;

  const ProductTag({required this.product, super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: AppRadius.xlBorder,
      ),
      child: Text(product, style: textStyle ?? AppTextStyles.bodySmall),
    );
  }
}
