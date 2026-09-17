import 'package:flutter/material.dart';
import '../../design.dart';
import '../../design_system.dart';

/// Loading screen displayed while data is being fetched
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Загрузка...',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.span),
          ),
        ],
      ),
    );
  }
}
