import 'package:cookmate/design.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/pages/resipes/recipes_scope.dart';
import 'package:cookmate/pages/resipes/widgets/ingredient_edit_modal.dart';
import 'package:cookmate/pages/widgets/product_tag.dart';
import 'package:flutter/material.dart';

class MatchedProductsRow extends StatelessWidget {
  const MatchedProductsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RecipesScope.of(context, 'ingrediens');
    final ingrediens = scope.state.matchedIngrediens;
    final onToggleEditing = scope.onToggleEditing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          TextButton.icon(
            onPressed: onToggleEditing,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              splashFactory: InkRipple.splashFactory,
            ),
            label: Text('Редактировать'),
            icon: Icon(Icons.edit, size: 15),
          ),
          ...ingrediens.map((e) => ProductTag(product: e)),
        ],
      ),
    );
  }
}
