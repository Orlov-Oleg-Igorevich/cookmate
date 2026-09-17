import 'package:cookmate/design.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/pages/resipes/recipes_scope.dart';
import 'package:flutter/material.dart';

class RecipesHeader extends StatelessWidget {
  const RecipesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RecipesScope.of(context, 'resipes');
    final recipesCount = scope.state.recipes.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 5,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.primary, size: 15),
        Text(
          'Количество найденных рецептов: $recipesCount',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
