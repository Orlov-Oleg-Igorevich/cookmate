import 'dart:async';
import 'dart:convert';
import 'package:cookmate/const/mocked_recipes_list.dart';
import 'package:cookmate/dto/recipes_search.dto.dart';

import '../const/config.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.model.dart';

class RecipeApiServices {
  static const baseUrl = '${Configs.baseUrl}/recipes';

  final http.Client client;

  RecipeApiServices({http.Client? client}) : client = client ?? http.Client();

  Future<RecipesSearchDto> getRecipesByComponents(
    List<String> components,
  ) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/search'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'ingredients': components}),
          )
          .timeout(
            const Duration(seconds: 4),
            onTimeout: () => throw TimeoutException(
              'Превышено время ожидания ответа от сервера.',
            ),
          );

      print('Тело ответа: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final answer = RecipesSearchDto.fromJson(data);
        return answer;
      } else {
        throw Exception(
          'Поиск рецептов провалился. Ответ сервера: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Не удалось выполнить загрузку рецептов - $e');
    }

    // await Future.delayed(Duration(seconds: 2));

    // final recipes = mockRecipes
    //     .where(
    //       (recipe) => (recipe['components'] as List<String>).any(
    //         (product) => components.contains(product),
    //       ),
    //     )
    //     .map((e) => Recipe.fromJson(e))
    //     .toList();

    // return RecipesSearchDto(
    //   recipeCount: recipes.length,
    //   recipes: recipes,
    //   recognizedIngredients: components,
    // );
  }

  Future<RecipeDetails> getFullRecipeById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application-json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return RecipeDetails.fromJson(data);
      } else {
        throw Exception(
          'Failed to load recipe with id=$id: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed fetching recipe with id=$id: $e');
    }
  }

  Future<FavoriteRecipes> getFavoriteRecipe(String userId) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return FavoriteRecipes.fromJson(data);
      } else {
        throw Exception(
          'Failed to load favorite recipe: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed fetching favorite recipe: $e');
    }
  }

  Future<void> addFavoriteRecipe(String userId, recipeId) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/favorite/$recipeId'),
        headers: {'Content-Type': 'application/json'},
        body: {'userId': userId, 'recipeId': recipeId},
      );

      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Failed adding a new favorite recipe: $e');
    }
  }
}
