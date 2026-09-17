import 'package:cookmate/design.dart';
import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/pages/recipes.page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'pages/scanner.page.dart';

void main() async {
  await GetStorage.init('userFavoriteRecipe');
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppNavigation(),
    );
  }
}

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentPageIndex = 1;

  // Храним данные от сканера для передачи на страницу рецептов
  List<String>? scannedProducts;
  List<Recipe>? scannedRecipes;

  /// Обработчик завершения сканирования - переключает на страницу рецептов
  void _handleScanComplete(List<String> products, List<Recipe> recipes) {
    setState(() {
      scannedProducts = products;
      scannedRecipes = recipes;
      currentPageIndex = 1; // Переключаем на страницу рецептов
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      // floatingActionButton: FloatingActionButton(
      //   mini: true,
      //   backgroundColor: AppColors.primary,
      //   splashColor: AppColors.deepPrimary,
      //   foregroundColor: AppColors.white,
      //   onPressed: () {},
      //   child: Icon(Icons.history),
      // ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.secondary,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner, color: AppColors.span),
            selectedIcon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
            label: 'Сканировать',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_dining_outlined, color: AppColors.span),
            selectedIcon: Icon(Icons.local_dining, color: AppColors.primary),
            label: 'Рецепты',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border, color: AppColors.span),
            selectedIcon: Icon(Icons.favorite, color: AppColors.primary),
            label: 'Избранное',
          ),
        ],
      ),
      body: SafeArea(
        child: <Widget>[
          ScannerPage(onScanComplete: _handleScanComplete),
          RecipesPage(
            initialProducts: scannedProducts,
            initialRecipes: scannedRecipes,
          ),
          const Center(child: Text('Избранное')),
        ][currentPageIndex],
      ),
    );
  }
}
