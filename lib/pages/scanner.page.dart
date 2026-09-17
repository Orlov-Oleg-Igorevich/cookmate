import 'package:cookmate/design.dart';
import 'package:cookmate/design_system.dart';
import 'package:cookmate/models/recipe.model.dart';
import 'package:cookmate/pages/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'scanner/scanner_widgets.dart';

/// Главная страница для управлением состояния с помощью ScannerScope
class ScannerPage extends StatelessWidget {
  final Function(List<String>, List<Recipe>)? onScanComplete;

  const ScannerPage({super.key, this.onScanComplete});

  @override
  Widget build(BuildContext context) {
    return ScannerProvider(
      child: _ScannerPageContent(),
      onScanComplete: onScanComplete,
    );
  }
}

/// Внутренний виджет, имеющий доступ к ScannerScope
class _ScannerPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Подписка только на загрузку
    final scope = ScannerScope.of(context, aspect: ScannerAspect.loading);
    final state = scope.state;

    // Показ экрана загрузки, когда данные обновляются
    if (state.isLoading) {
      return const LoadingScreen();
    }

    // Подписка на ошибку
    final scopeWithError = ScannerScope.of(
      context,
      aspect: ScannerAspect.error,
    );

    // Показываем экран ошибки, если возникла ошибка
    if (scopeWithError.state.errorMessage != null) {
      return ErrorScreeen(errorMessage: scopeWithError.state.errorMessage!);
    }

    return Stack(
      children: [
        // Осноная страницы - статический контент
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScannerHeader(),

                const SizedBox(height: 10),

                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Что же мы будем",
                      style: TextStyle(
                        color: AppColors.foreground,
                        fontSize: 28,
                        height: 0,
                      ),
                    ),
                    Text(
                      "готовить сегодня?",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        height: 0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "Сфотографируйте свои ингредиенты и мы предложим вам лучшие рецепты.",
                  style: AppTextStyles.bodyMedium,
                ),

                const SizedBox(height: 16),

                // PhotoCaptureArea сам подписывается на ScannerScope
                const PhotoCaptureArea(),

                const SectionDivider(),

                // GalleryUploadButton сам подписывается на ScannerScope
                const GalleryUploadButton(),

                const SizedBox(height: 24),

                // RecentProductsCard сам подписывается на ScannerScope
                const RecentProductsCard(),

                const SizedBox(height: 20),

                const TipSection(),
              ],
            ),
          ),
        ),

        // Верхний слой когда пользователь выбрал фото - подписываемся только на изменение аспекта фотографии
        PhotoPreviewOverlay(),
      ],
    );
  }
}
