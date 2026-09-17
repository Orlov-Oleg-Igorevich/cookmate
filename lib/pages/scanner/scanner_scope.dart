import 'dart:io';
import 'package:cookmate/services/recipe-api.services.dart';
import 'package:flutter/material.dart';
import '../../models/recipe.model.dart';
import '../../services/product.service.dart';

/// State model for ScannerPage
class ScannerState {
  final List<String> lastProducts;
  final File? selectedPhoto;
  final bool isLoading;
  final bool isRecognizing;
  final String? errorMessage;

  const ScannerState({
    this.lastProducts = const [],
    this.selectedPhoto,
    this.isLoading = true,
    this.isRecognizing = false,
    this.errorMessage,
  });

  ScannerState copyWith({
    List<String>? lastProducts,
    File? selectedPhoto,
    bool? isLoading,
    bool? isRecognizing,
    String? errorMessage,
  }) {
    return ScannerState(
      lastProducts: lastProducts ?? this.lastProducts,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
      isLoading: isLoading ?? this.isLoading,
      isRecognizing: isRecognizing ?? this.isRecognizing,
      errorMessage: errorMessage,
    );
  }

  ScannerState resetPhoto() {
    return ScannerState(
      lastProducts: lastProducts,
      selectedPhoto: null,
      isLoading: isLoading,
      isRecognizing: isRecognizing,
      errorMessage: errorMessage,
    );
  }

  /// Проверка, что фото выбрано и готово для сканирования
  bool get hasSelectedPhoto => selectedPhoto != null;
}

/// Виды аспектов для выборочной перестройки элементов с помощью [InheritedModel]
abstract class ScannerAspect {
  static const String loading = 'loading';
  static const String products = 'products';
  static const String photo = 'photo';
  static const String recognizing = 'recognizing';
  static const String error = 'error';
}

/// [InheritedModel] для выборочной перестройки элементов на основе аспектов
class ScannerScope extends InheritedModel<String> {
  final ScannerState state;
  final VoidCallback? onFindRecipe;
  final Function(File) onPhotoCaptured;
  final Function(File) onGalleryUpload;
  final Function() onStartScanning;
  final Function() onPhotoReset;
  final Function(List<String>, List<Recipe>)? onScanComplete;

  const ScannerScope({
    super.key,
    required this.state,
    required this.onFindRecipe,
    required this.onPhotoCaptured,
    required this.onGalleryUpload,
    required this.onStartScanning,
    required this.onPhotoReset,
    this.onScanComplete,
    required super.child,
  });

  /// Доступ к [ScannerScope] из [BuildContext] с выборочной подпиской
  /// Выберите [aspect], чтобы перестраиваться только при его изменении
  static ScannerScope of(BuildContext context, {String? aspect}) {
    final scope = InheritedModel.inheritFrom<ScannerScope>(
      context,
      aspect: aspect,
    );
    if (scope == null) {
      throw FlutterError(
        'ScannerScope.of() вызывается с контекстом, в котором не содержится ScannerScope.\n'
        'Это может произойти, если используемый контекст не является потомком ScannerScope.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(ScannerScope oldWidget) {
    return state != oldWidget.state;
  }

  @override
  bool updateShouldNotifyDependent(
    ScannerScope oldWidget,
    Set<String> dependencies,
  ) {
    // Rebuild only if the depended-upon aspects have changed
    if (dependencies.contains(ScannerAspect.loading) &&
        state.isLoading != oldWidget.state.isLoading) {
      return true;
    }

    if (dependencies.contains(ScannerAspect.products) &&
        state.lastProducts != oldWidget.state.lastProducts) {
      return true;
    }
    if (dependencies.contains(ScannerAspect.photo) &&
        state.selectedPhoto != oldWidget.state.selectedPhoto) {
      return true;
    }

    if (dependencies.contains(ScannerAspect.recognizing) &&
        state.isRecognizing != oldWidget.state.isRecognizing) {
      return true;
    }

    if (dependencies.contains(ScannerAspect.error) &&
        state.errorMessage != oldWidget.state.errorMessage) {
      return true;
    }

    return false;
  }
}

/// [StatefulWidget] обёртка для управления состоянием [ScannerScope]
class ScannerProvider extends StatefulWidget {
  final Widget child;
  final Function(List<String>, List<Recipe>)? onScanComplete;

  const ScannerProvider({super.key, required this.child, this.onScanComplete});

  @override
  State<ScannerProvider> createState() => _ScannerProviderState();
}

class _ScannerProviderState extends State<ScannerProvider> {
  late ScannerState _state;
  final _productService = ProductService();
  final _recipeService = RecipeApiServices();

  @override
  void initState() {
    super.initState();
    _state = const ScannerState(isLoading: true);
    _initializeData();
  }

  /// Initialize page data (fetch last products)
  Future<void> _initializeData() async {
    try {
      setState(() {
        _state = _state.copyWith(isLoading: true, errorMessage: null);
      });

      final products = await _productService.fetchLastProducts();

      setState(() {
        _state = _state.copyWith(lastProducts: products, isLoading: false);
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: 'Не удалось загрузить данные. Попробуйте еще раз.',
        );
      });
    }
  }

  /// Handle photo capture from camera or gallery
  void _handlePhotoCaptured(File photo) {
    setState(() {
      _state = _state.copyWith(selectedPhoto: photo);
    });
  }

  /// Handle gallery upload button press
  void _handleGalleryUpload(File photo) {
    // TODO: Implement gallery picker
    // For now, just clear any existing photo
    _handlePhotoCaptured(photo);
  }

  /// Handle find recipe button press
  Future<void> _handleFindRecipe() async {
    // TODO: Navigate to recipe results page
    try {
      setState(() {
        _state = _state.copyWith(isRecognizing: true);
      });
      final recipes = await _recipeService.getRecipesByComponents(
        _state.lastProducts,
      );

      widget.onScanComplete?.call(_state.lastProducts, recipes.recipes);
    } catch (e) {}
  }

  void _handleResetPhoto() {
    setState(() {
      _state = _state.resetPhoto();
    });
  }

  /// Start product recognition process
  Future<void> _handleStartScanning() async {
    if (_state.selectedPhoto == null) return;
    print('Scanning');

    try {
      print('in try');
      setState(() {
        _state = _state.copyWith(isRecognizing: true, errorMessage: null);
      });

      final recognizedProducts = await _productService.recognizeProducts(
        _state.selectedPhoto!.path,
      );

      setState(() {
        _state = _state.copyWith(
          lastProducts: recognizedProducts.recognizedIngredients,
          selectedPhoto: null,
          isRecognizing: false,
        );
      });

      // Вызываем callback для навигации с данными
      widget.onScanComplete?.call(
        recognizedProducts.recognizedIngredients,
        recognizedProducts.recipes,
      );
    } catch (e) {
      setState(() {
        _state = _state.copyWith(
          isRecognizing: false,
          errorMessage: 'Ошибка распознавания. Попробуйте еще раз.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScannerScope(
      state: _state,
      onFindRecipe: _handleFindRecipe,
      onPhotoCaptured: _handlePhotoCaptured,
      onGalleryUpload: _handleGalleryUpload,
      onStartScanning: _handleStartScanning,
      onPhotoReset: _handleResetPhoto,
      onScanComplete: widget.onScanComplete,
      child: widget.child,
    );
  }
}
