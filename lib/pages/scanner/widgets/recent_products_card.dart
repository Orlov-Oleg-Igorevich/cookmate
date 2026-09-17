import 'package:cookmate/pages/widgets/product_tag.dart';
import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';
import '../scanner_scope.dart';

/// Карточка с последними распознанными продуктами
class RecentProductsCard extends StatelessWidget {
  const RecentProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Подписываемся только на аспект products
    final scope = ScannerScope.of(context, aspect: ScannerAspect.products);
    final scopeWithRecognizing = ScannerScope.of(
      context,
      aspect: ScannerAspect.recognizing,
    );
    final isRecognizing = scopeWithRecognizing.state.isRecognizing;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.lgBorder,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 15),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Последние распознанные продукты',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: scope.state.lastProducts
                .map((product) => ProductTag(product: product))
                .toList(),
          ),
          SizedBox(height: AppSpacing.md),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.primary,
              disabledForegroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
              splashFactory: InkRipple.splashFactory,
            ),
            onPressed: isRecognizing ? null : scope.onFindRecipe,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isRecognizing
                  ? [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Icon(Icons.cookie_outlined, size: 18),
                      SizedBox(width: AppSpacing.xs),
                      Text('Найти рецепт', style: AppTextStyles.buttonPrimary),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
