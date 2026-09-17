import 'package:cookmate/components/card_scope.dart';
import 'package:cookmate/components/favorite_button.dart';
import 'package:cookmate/components/image_block.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/pages/widgets/product_tag.dart';
import 'package:flutter/material.dart';
import '../design.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return CardProvider(child: _CardRecipeContent(recipe), recipe: recipe);
  }
}

class _CardRecipeContent extends StatelessWidget {
  final Recipe recipeData;

  const _CardRecipeContent(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return _CardStyleBox(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: [
          CardImage(image: recipeData.image),
          Expanded(
            child: CardInfo(
              title: recipeData.title,
              description: recipeData.description,
              tags: recipeData.tags,
              approximateTime: recipeData.approximateTime,
              calories: recipeData.calories,
              difficulty: recipeData.difficulty,
            ),
          ),
        ],
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String? image;
  final String? approximateTime;
  final int? calories;
  final String? difficulty;

  const CardInfo({
    required this.title,
    required this.description,
    required this.tags,
    this.image,
    this.approximateTime,
    this.calories,
    this.difficulty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cookTime = approximateTime ?? '-';
    final calorieContent = calories is int ? calories.toString() : '-';
    String difficultyLevel = '-';
    if (difficulty != null) {
      difficultyLevel = difficulty!;
    } else if (approximateTime != null) {
      final time = int.tryParse(approximateTime!.split(' ')[0]);
      if (time != null) {
        if (time < 30) {
          difficultyLevel = 'Easy';
        } else if (time < 90) {
          difficultyLevel = 'Medium';
        } else {
          difficultyLevel = 'Hard';
        }
      }
    }
    final difficultyColor = difficultyLevel == 'Easy'
        ? AppColors.easyGreen
        : difficultyLevel == 'Medium'
        ? AppColors.mediumOrange
        : difficultyLevel == 'Hard'
        ? AppColors.hardRed
        : AppColors.span;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: 373,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title)),
              FavoriteButton(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              TextSpan(text: cookTime, icon: Icons.watch_later_outlined),
              TextSpan(
                text: calorieContent,
                icon: Icons.local_fire_department_outlined,
              ),
              TextSpan(
                text: difficultyLevel,
                icon: Icons.circle,
                spanColor: difficultyColor,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: tags
                .map(
                  (elem) =>
                      ProductTag(product: elem, textStyle: AppTextStyles.label),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// class TagSpan extends StatelessWidget {
//   final String title;

//   const TagSpan({required this.title, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: AppColors.secondary,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//         child: Text(
//           title,
//           style: TextStyle(fontSize: 11, color: AppColors.span),
//         ),
//       ),
//     );
//   }
// }

class TextSpan extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color spanColor;
  final double space;

  const TextSpan({
    required this.text,
    required this.icon,
    this.spanColor = AppColors.span,
    this.space = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 3,
      children: [
        Icon(icon, size: 12, color: spanColor),
        Text(text, style: TextStyle(fontSize: 12, color: spanColor)),
      ],
    );
  }
}

class _CardStyleBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _CardStyleBox({required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
