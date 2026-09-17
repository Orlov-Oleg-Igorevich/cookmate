import 'package:flutter/material.dart';
import 'design.dart';

/// Дизайн система для согласованного расположения эелементов в приложении
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// Дизайн система для согласованного закругления в приложении
abstract class AppRadius {
  static const double sm = 8.0;
  static const double md = 10.0;
  static const double lg = 15.0;
  static const double xl = 20.0;
  static const double round = 30.0;

  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get roundBorder => BorderRadius.circular(round);
}

/// Дизайн система для согласованного управления стелем текста в приложении
abstract class AppTextStyles {
  // Headings
  static TextStyle get heading1 => const TextStyle(
    color: AppColors.foreground,
    fontFamily: 'Lora',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 1.2,
  );

  static TextStyle get heading2 => const TextStyle(
    color: AppColors.primary,
    fontFamily: 'Lora',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 1.2,
  );

  static TextStyle get heading3 => const TextStyle(
    color: AppColors.foreground,
    fontSize: 18,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w600,
  );

  // Body text
  static TextStyle get bodyLarge => const TextStyle(
    color: AppColors.foreground,
    fontSize: 16,
    height: 1.5,
    fontFamily: 'Lora',
  );

  static TextStyle get bodyMedium => const TextStyle(
    color: AppColors.span,
    fontSize: 15,
    height: 1.3,
    fontFamily: 'DM_Sans',
  );

  static TextStyle get bodySmall => const TextStyle(
    color: AppColors.span,
    fontSize: 14,
    height: 1.3,
    fontFamily: 'DM_Sans',
  );

  // Button text
  static TextStyle get buttonPrimary => const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w600,
  );

  static TextStyle get buttonSecondary => const TextStyle(
    color: AppColors.foreground,
    fontSize: 15,
    fontFamily: 'Lora',
    fontWeight: FontWeight.w500,
  );

  // Caption/Hint text
  static TextStyle get caption => const TextStyle(
    color: AppColors.span,
    fontSize: 13,
    height: 1.3,
    fontFamily: 'DM_Sans',
  );

  // Label text
  static TextStyle get label => const TextStyle(
    color: AppColors.span,
    fontSize: 11,
    fontFamily: 'DM_Sans',
  );
}
