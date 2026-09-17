import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookmate/const/mocked_products_list.dart';
import 'package:cookmate/dto/recipes_search.dto.dart';
import 'package:http/http.dart' as http;

import 'package:cookmate/const/config.dart';

/// Service for managing recently recognized products
class ProductService {
  static const baseUrl = Configs.baseUrl;
  final http.Client client;

  ProductService({http.Client? client}) : client = client ?? http.Client();

  Future<List<String>> fetchLastProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<String> shuffledList = List.from(mockProducts);
    shuffledList.shuffle();

    final List<String> selectedItems = shuffledList.sublist(0, 5);

    return selectedItems;
  }

  Future<RecipesSearchDto> recognizeProducts(String imagePath) async {
    // await Future.delayed(const Duration(seconds: 2));

    // final List<String> shuffledList = List.from(mockProducts);
    // shuffledList.shuffle();
    // final List<String> selectedItems = shuffledList.sublist(0, 5);

    // final recipes = mockRecipes.where(
    //   (recipe) => (recipe['components'] as List<String>).any(
    //     (product) => selectedItems.contains(product),
    //   ),
    // ).map((e) => Recipe.fromJson(e)).toList();

    // return RecipesSearchDto(
    //   recipesCount: recipes.length,
    //   recipes: recipes,
    //   recognizedIngredients: selectedItems,
    // );

    try {
      final file = File(imagePath);

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/recipes/recognize'),
      );

      // Add file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: http.MediaType('image', 'jpeg'),
        ),
      );

      // Send the request with timeout
      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Превышено время ожидания ответа от сервера');
        },
      );

      // Read the response body with timeout
      final responseBody = await response.stream.bytesToString().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Превышено время ожидания чтения ответа');
        },
      );
      print('Status code: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        print('Запрос выполнен успешно');
        final Map<String, dynamic> json = jsonDecode(responseBody);
        final data = RecipesSearchDto.fromJson(json);
        return data;
      }

      throw Exception(
        'Распознавание продуктов провалилось. Ответ сервера: ${response.statusCode}.',
      );
    } catch (e) {
      throw Exception('Не удалось распознать продукты по картинке - $e');
    }
  }
}
