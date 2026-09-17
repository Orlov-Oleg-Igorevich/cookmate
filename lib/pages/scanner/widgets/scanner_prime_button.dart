import 'package:flutter/material.dart';
import '../scanner_scope.dart';
import '../../../design.dart';
import '../../../design_system.dart';

class ScannerPrimeButton extends StatelessWidget {
  const ScannerPrimeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ScannerScope.of(context, aspect: ScannerAspect.recognizing);

    return SizedBox(
      width: double.infinity, // Растягиваем на всю ширину
      height: 56, // Фиксируем высоту
      child: ElevatedButton(
        onPressed: scope.state.isRecognizing
            ? null
            : () => scope.onStartScanning(),

        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
              splashFactory: InkRipple.splashFactory,
              // Настраиваем стиль для disabled состояния
              disabledBackgroundColor: AppColors.primary,
              disabledForegroundColor: AppColors.white,
            ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scope.state.isRecognizing
              ? [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                ]
              : [
                  Icon(Icons.auto_awesome, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Начать сканирование',
                    style: AppTextStyles.buttonPrimary,
                  ),
                ],
        ),
      ),
    );
  }
}
