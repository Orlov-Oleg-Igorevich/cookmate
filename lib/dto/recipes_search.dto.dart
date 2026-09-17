import 'package:cookmate/models/recipe.model.dart';

class RecipesSearchDto {
  final int recipeCount;
  final List<Recipe> recipes;
  final List<String> recognizedIngredients;

  RecipesSearchDto({
    required this.recipeCount,
    required this.recipes,
    required this.recognizedIngredients,
  });

  factory RecipesSearchDto.fromJson(Map<String, dynamic> json) {
    return RecipesSearchDto(
      recipeCount: json['recipeCount'] is int
          ? json['recipeCount']
          : int.tryParse(json['recipeCount'].toString()) ?? 0,
      recipes:
          (json['recipes'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => Recipe.fromJson(e))
              .toList() ??
          [],
      recognizedIngredients:
          (json['recognizedIngredients'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'recipesCount': recipeCount, 'recipes': recipes};
  }
}
