import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';

class TipSection extends StatelessWidget {
  const TipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdBorder,
        border: BoxBorder.all(
          color: AppColors.span,
          width: 1,
        )
      ),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lightbulb, color: AppColors.mediumOrange, size: 15),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Совет: для достижения наилучшего результата разложите ингредиенты на ровной, хорошо освещенной поверхности',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    ),
    );
  }
}
