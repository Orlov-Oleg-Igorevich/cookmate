import 'package:cookmate/design.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/pages/resipes/recipes_scope.dart';
import 'package:flutter/material.dart';

class IngredientEditModal extends StatefulWidget {
  const IngredientEditModal({super.key});

  @override
  State<IngredientEditModal> createState() => _IngredientEditModalState();
}

class _IngredientEditModalState extends State<IngredientEditModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = RecipesScope.of(context, 'editingIngredients');
    final ingredients = scope.state.matchedIngrediens;
    final onAddProduct = scope.onAddProduct;
    final onDeleteProduct = scope.onDeleteProduct;
    final onToggleEditing = scope.onToggleEditing;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Редактировать ингредиенты',
                    style: AppTextStyles.heading2.copyWith(fontSize: 22),
                  ),
                ),
                
                IconButton(
                  onPressed: onToggleEditing,
                  icon: Icon(Icons.close),
                  color: AppColors.foreground,
                ),
              ],
            ),
          ),
          Divider(height: 1),

          // Input field for adding new ingredient
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите ингредиент',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        onAddProduct(value.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      onAddProduct(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                  icon: Icon(Icons.arrow_forward),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // List of current ingredients
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return ListTile(
                  title: Text(ingredient),
                  trailing: IconButton(
                    icon: Icon(Icons.close, size: 20),
                    color: AppColors.hardRed,
                    onPressed: () => onDeleteProduct(ingredient),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
