interface class Recipe {
  final String id;
  final String title;
  final bool favorite;
  final String description;
  final List<String> tags;
  final List<String> components;
  final String? image;
  final String? approximateTime;
  final int? calories;
  final String? difficulty;

  const Recipe({
    required this.id,
    required this.title,
    required this.favorite,
    required this.description,
    required this.tags,
    required this.components,
    this.image,
    this.approximateTime,
    this.calories,
    this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      title: json['title'] as String,
      favorite: json['favorite'] as bool? ?? false,
      description: json['description'] as String,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      components:
          (json['components'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      image: json['image'] as String?,
      approximateTime: json['approximateTime'] as String?,
      calories: json['calories'] is int
          ? json['calories']
          : int.tryParse(json['calories'].toString()),
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'favorite': favorite,
      'description': description,
      'tags': tags,
      'components': components,
      if (image != null) 'image': image,
      if (approximateTime != null) 'approximateTime': approximateTime,
      if (calories != null) 'calories': calories,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }

  Recipe copyWidth({
    String? id,
    String? title,
    bool? favorite,
    String? description,
    List<String>? tags,
    List<String>? components,
    String? image,
    String? approximateTime,
    int? calories,
    String? difficulty,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      favorite: favorite ?? this.favorite,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      components: components ?? this.components,
      image: image ?? this.image,
      approximateTime: approximateTime ?? this.approximateTime,
      calories: calories ?? this.calories,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

interface class FavoriteRecipes {
  final int recipeNumber;
  final List<Recipe> recipes;

  FavoriteRecipes({required this.recipeNumber, required this.recipes});

  factory FavoriteRecipes.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipes(
      recipeNumber: json['recipeNumber'] as int,

      recipes:
          (json['recipes'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => Recipe.fromJson(e))
              .toList() ??
          [],
    );
  }
}

interface class PFC {
  final int? protein;
  final int? fat;
  final int? carbohydrates;

  PFC({this.protein, this.fat, this.carbohydrates});

  static PFC? _parsePFC(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      try {
        return PFC.fromJson(value);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  factory PFC.fromJson(Map<String, dynamic> json) {
    return PFC(
      protein: json['protein'] is int
          ? json['proteint']
          : int.tryParse(json['protein'].toString()),

      fat: json['fat'] is int
          ? json['fat']
          : int.tryParse(json['fat'].toString()),

      carbohydrates: json['carbohydrates'] is int
          ? json['carbohydrates']
          : int.tryParse(json['carbohydrates'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'protein': protein, 'fat': fat, 'carbohydrates': carbohydrates};
  }
}

interface class RecipeStep {
  final int num;
  final String stepTitle;
  final String stepInstruction;
  final String? imageUrl;

  RecipeStep({
    required this.num,
    required this.stepTitle,
    required this.stepInstruction,
    this.imageUrl,
  });

  static RecipeStep? _parseRecipeStep(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      try {
        return RecipeStep.fromJson(value);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      num: json['num'] is int
          ? json['num']
          : int.tryParse(json['num'].toString()),
      stepTitle: json['stepTitle'] as String? ?? '',
      stepInstruction: json['stepInstruction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'stepTitle': stepTitle,
      'stepInstruction': stepInstruction,
      'imageUrl': imageUrl,
    };
  }
}

interface class RecipeDetails {
  final String id;
  final String title;
  final bool favorite;
  final String description;
  final List<String> tags;
  final List<String> components;
  final List<RecipeStep> content;
  final String? image;
  final int? approximateTime;
  final int? calories;
  final String? difficulty;
  final PFC? pfc;

  const RecipeDetails({
    required this.id,
    required this.title,
    required this.favorite,
    required this.description,
    required this.tags,
    required this.components,
    required this.content,
    this.image,
    this.approximateTime,
    this.calories,
    this.difficulty,
    this.pfc,
  });

  factory RecipeDetails.fromJson(Map<String, dynamic> json) {
    return RecipeDetails(
      id: json['id'].toString(),
      title: json['title'] as String,
      favorite: json['favorite'] as bool? ?? false,
      description: json['description'] as String,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      components:
          (json['components'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      content:
          (json['content'] as List?)
              ?.map((e) => RecipeStep._parseRecipeStep(e))
              .whereType<RecipeStep>()
              .toList() ??
          [],
      image: json['image'] as String?,
      approximateTime: json['approximateTime'] is int
          ? json['approximateTime']
          : int.tryParse(json['approximateTime'].toString()),
      calories: json['calories'] is int
          ? json['calories']
          : int.tryParse(json['calories'].toString()),
      difficulty: json['difficulty'] as String?,
      pfc: PFC._parsePFC(json['pfc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'favorite': favorite,
      'description': description,
      'tags': tags,
      'components': components,
      'content': content,
      if (image != null) 'image': image,
      if (approximateTime != null) 'approximateTime': approximateTime,
      if (calories != null) 'calories': calories,
      if (difficulty != null) 'difficulty': difficulty,
      if (pfc != null) 'pfc': pfc,
    };
  }

  RecipeDetails copyWidth({
    String? id,
    String? title,
    bool? favorite,
    String? description,
    List<String>? tags,
    List<String>? components,
    List<RecipeStep>? content,
    String? image,
    int? approximateTime,
    int? calories,
    String? difficulty,
    PFC? pfc,
  }) {
    return RecipeDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      favorite: favorite ?? this.favorite,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      components: components ?? this.components,
      content: content ?? this.content,
      image: image ?? this.image,
      approximateTime: approximateTime ?? this.approximateTime,
      calories: calories ?? this.calories,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
