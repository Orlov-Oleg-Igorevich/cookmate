import 'package:cookmate/design_system.dart';
import 'package:cookmate/pages/resipes/recipes_scope.dart';
import 'package:flutter/material.dart';

class HintLine extends StatelessWidget {
  const HintLine({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = RecipesScope.of(context, 'ingrediens');
    final productsCount = scope.state.matchedIngrediens.length;

    return Text(
      'На основе вашего сканирования · Количество учтенных ингредиентов: $productsCount',
      style: AppTextStyles.caption,
    );
  }
}
