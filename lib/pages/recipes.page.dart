import 'package:cookmate/components/card.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/pages/resipes/recipes_scope.dart';
import 'package:cookmate/pages/resipes/widgets/hint_line.dart';
import 'package:cookmate/pages/resipes/widgets/ingredient_edit_modal.dart';
import 'package:cookmate/pages/resipes/widgets/matched_products_row.dart';
import 'package:cookmate/pages/resipes/widgets/recipes_header.dart';
import 'package:cookmate/pages/scanner/scanner_widgets.dart';
import 'package:cookmate/pages/widgets/error_screen.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  final List<String>? initialProducts;
  final List<Recipe>? initialRecipes;

  const RecipesPage({super.key, this.initialProducts, this.initialRecipes});

  @override
  Widget build(BuildContext context) {
    return RecipesProvider(
      initialProducts: initialProducts,
      initialRecipes: initialRecipes,
      child: _RecipesPageContent(),
    );
  }
}

class _RecipesPageContent extends StatelessWidget {
  const _RecipesPageContent();

  @override
  Widget build(BuildContext context) {
    final scope = RecipesScope.of(context, 'isLoading');
    final state = scope.state;

    if (state.isLoadingPage) {
      return const LoadingScreen();
    }

    final scopeWithError = RecipesScope.of(context, 'error');
    if (scopeWithError.state.errorMessage != null) {
      return ErrorScreeen(errorMessage: scopeWithError.state.errorMessage!);
    }

    final scopeWithRecipes = RecipesScope.of(context, 'resipes');
    final resipesList = scopeWithRecipes.state.recipes;
    final isEditing = scopeWithRecipes.state.isEditingIngredients;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: const RecipesHeader()),
              SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.sm)),
              SliverToBoxAdapter(
                child: Text(
                  'Рекомендованные Рецепты',
                  style: AppTextStyles.heading1,
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.sm)),
              SliverToBoxAdapter(child: const HintLine()),
              SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.sm)),
              SliverPersistentHeader(
                delegate: _StickyHeaderDelegate(child: MatchedProductsRow()),
                pinned: true,
              ),
              SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.sm)),
              SliverList.separated(
                itemCount: resipesList.length,
                itemBuilder: (context, index) {
                  final Recipe recipe = resipesList[index];
                  return RecipeCard(recipe: recipe, key: ValueKey(recipe.id));
                },
                separatorBuilder: (context, index) => Container(height: 12),
              ),
            ],
          ),
        ),
        if (isEditing)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                final scope = RecipesScope.of(context, 'editingIngredients');
                scope.onToggleEditing();
              },
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        if (isEditing)
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return IngredientEditModal();
              },
            ),
          ),
      ],
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
