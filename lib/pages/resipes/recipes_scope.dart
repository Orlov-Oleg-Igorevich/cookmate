import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/services/product.service.dart';
import 'package:cookmate/services/recipe-api.services.dart';
import 'package:flutter/material.dart';

class RecipesState {
  final List<Recipe> recipes;
  final List<String> matchedIngrediens;
  final bool isLoadingPage;
  final bool isLoadingRecipes;
  final String? errorMessage;
  final bool isEditingIngredients;

  const RecipesState({
    this.recipes = const [],
    this.matchedIngrediens = const [],
    this.isLoadingPage = true,
    this.isLoadingRecipes = false,
    this.errorMessage,
    this.isEditingIngredients = false,
  });

  RecipesState copyWith({
    List<Recipe>? recipes,
    List<String>? matchedIngrediens,
    bool? isLoadingPage,
    bool? isLoadingRecipes,
    String? errorMessage,
    bool? isEditingIngredients,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      matchedIngrediens: matchedIngrediens ?? this.matchedIngrediens,
      isLoadingPage: isLoadingPage ?? this.isLoadingPage,
      isLoadingRecipes: isLoadingPage ?? this.isLoadingRecipes,
      errorMessage: errorMessage,
      isEditingIngredients: isEditingIngredients ?? this.isEditingIngredients,
    );
  }
}

abstract class RecipesAspect {
  static const String recipes = 'resipes';
  static const String ingrediens = 'ingrediens';
  static const String isLoadingPage = 'isLoadingPage';
  static const String isLoadingRecipes = 'isLoadingRecipes';
  static const String error = 'error';
  static const String editingIngredients = 'editingIngredients';
}

class RecipesScope extends InheritedModel<String> {
  final RecipesState state;
  final Function(String) onDeleteProduct;
  final Function(String) onAddProduct;
  final VoidCallback onToggleEditing;

  const RecipesScope({
    required this.state,
    required this.onAddProduct,
    required this.onDeleteProduct,
    required this.onToggleEditing,
    super.key,
    required super.child,
  });

  static RecipesScope of(BuildContext context, String aspect) {
    final scope = InheritedModel.inheritFrom<RecipesScope>(context);
    if (scope == null) {
      throw FlutterError(
        'RecipesScope.of() вызывается с контекстом, в котором не содержится RecipesScope.\n'
        'Это может произойти, если используемый контекст не является потомком RecipesScope.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(RecipesScope oldWidget) {
    return state != oldWidget.state;
  }

  @override
  bool updateShouldNotifyDependent(
    RecipesScope oldWidget,
    Set<String> dependencies,
  ) {
    if (dependencies.contains(RecipesAspect.isLoadingPage) &&
        state.isLoadingPage != oldWidget.state.isLoadingPage) {
      return true;
    }

    if (dependencies.contains(RecipesAspect.error) &&
        state.errorMessage != oldWidget.state.errorMessage) {
      return true;
    }

    if (dependencies.contains(RecipesAspect.ingrediens) &&
        state.matchedIngrediens != oldWidget.state.matchedIngrediens) {
      return true;
    }

    if (dependencies.contains(RecipesAspect.recipes) &&
        state.recipes != oldWidget.state.recipes) {
      return true;
    }

    if (dependencies.contains(RecipesAspect.isLoadingRecipes) &&
        state.isLoadingRecipes != oldWidget.state.isLoadingRecipes) {
      return true;
    }

    if (dependencies.contains(RecipesAspect.editingIngredients) &&
        state.isEditingIngredients != oldWidget.state.isEditingIngredients) {
      return true;
    }

    return false;
  }
}

class RecipesProvider extends StatefulWidget {
  final Widget child;
  final List<String>? initialProducts;
  final List<Recipe>? initialRecipes;

  const RecipesProvider({
    required this.child,
    this.initialProducts,
    this.initialRecipes,
    super.key,
  });

  @override
  State<RecipesProvider> createState() => _RecipesProviderState();
}

class _RecipesProviderState extends State<RecipesProvider> {
  late RecipesState _state;
  final RecipeApiServices api = RecipeApiServices();
  final _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _state = RecipesState(isLoadingPage: true);

    // Если есть начальные данные (от сканера), используем их
    if (widget.initialProducts != null && widget.initialRecipes != null) {
      _state = _state.copyWith(
        isLoadingPage: false,
        matchedIngrediens: widget.initialProducts!,
        recipes: widget.initialRecipes!,
      );
    } else {
      initializeData();
    }
  }

  Future<void> initializeData() async {
    try {
      setState(() {
        _state = _state.copyWith(isLoadingPage: true, errorMessage: null);
      });

      final lastProducts = await _productService.fetchLastProducts();

      setState(() {
        _state = _state.copyWith(
          isLoadingPage: false,
          isLoadingRecipes: true,
          matchedIngrediens: lastProducts,
        );
      });

      final recipes = await api.getRecipesByComponents(lastProducts);

      setState(() {
        _state = _state.copyWith(
          isLoadingPage: false,
          recipes: recipes.recipes,
        );
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          isLoadingPage: false,
          isLoadingRecipes: false,
          errorMessage: 'Не удалось загрузить данные, попробуйте ещё раз',
        );
      });
    }
  }

  Future<void> _handleDeleteIngrediens(String ingredient) async {
    try {
      final List<String> newIngrediensList = _state.matchedIngrediens
          .where((e) => e != ingredient)
          .toList();

      setState(() {
        _state = _state.copyWith(
          matchedIngrediens: newIngrediensList,
          isLoadingRecipes: true,
        );
      });

      final newRecipesList = await api.getRecipesByComponents(
        newIngrediensList,
      );

      setState(() {
        _state = _state.copyWith(
          recipes: newRecipesList.recipes,
          isLoadingRecipes: false,
        );
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          isLoadingRecipes: false,
          errorMessage: 'Не удалось обновить список рецептов, поробуйте позже.',
        );
      });
    }
  }

  void _handleAddIngredient(String ingredient) async {
    try {
      final List<String> newIngrediensList = [
        ..._state.matchedIngrediens,
        ingredient,
      ];

      setState(() {
        _state = _state.copyWith(
          matchedIngrediens: newIngrediensList,
          isLoadingRecipes: true,
        );
      });

      final newRecipesList = await api.getRecipesByComponents(
        newIngrediensList,
      );

      setState(() {
        _state = _state.copyWith(
          recipes: newRecipesList.recipes,
          isLoadingRecipes: false,
        );
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          isLoadingRecipes: false,
          errorMessage: 'Не удалось обновить список рецептов, поробуйте позже.',
        );
      });
    }
  }

  void _handleToggleEditing() {
    setState(() {
      _state = _state.copyWith(
        isEditingIngredients: !_state.isEditingIngredients,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecipesScope(
      state: _state,
      onAddProduct: _handleAddIngredient,
      onDeleteProduct: _handleDeleteIngrediens,
      onToggleEditing: _handleToggleEditing,
      child: widget.child,
    );
  }
}
