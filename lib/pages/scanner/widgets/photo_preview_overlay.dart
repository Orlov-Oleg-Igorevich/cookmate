import 'dart:ui';
import 'package:cookmate/pages/scanner/widgets/scanner_prime_button.dart';
import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';
import '../scanner_scope.dart';

/// Overlay с blur эффектом для предпросмотра фото и кнопкой сканирования
class PhotoPreviewOverlay extends StatelessWidget {
  const PhotoPreviewOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Подписываемся на аспект photo для получения актуального фото
    final scope = ScannerScope.of(context, aspect: ScannerAspect.photo);

    // Если фото нет, не показываем overlay
    if (scope.state.selectedPhoto == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Blur background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.black26),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                // Кнопка закрытия
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: scope.onPhotoReset,
                    icon: Icon(Icons.close, size: 30),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.all(AppSpacing.sm),
                      splashFactory: InkRipple.splashFactory,
                    ),
                  ),
                ),

                Spacer(),

                // Предпоказ фото - берем из scope
                Container(
                  constraints: BoxConstraints(maxHeight: 400),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.lgBorder,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    scope.state.selectedPhoto!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Кнопка сканирования
                const ScannerPrimeButton(),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'Нажмите кнопку выше для распознавания продуктов на фото',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withAlpha(210),
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
