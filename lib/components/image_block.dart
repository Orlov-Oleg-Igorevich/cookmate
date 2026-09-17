import 'package:cookmate/design.dart';
import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  final String? image;

  const CardImage({this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = image;
    final Widget imageWidget;
    
    if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          final total = loadingProgress.expectedTotalBytes;
          final loaded = loadingProgress.cumulativeBytesLoaded;

          return Center(
            child: CircularProgressIndicator(
              value: total != null ? loaded / total : null,
              color: AppColors.primary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return FittedBox(
            fit: BoxFit.contain,
            child: Icon(Icons.fastfood_outlined),
          );
        },
      );
    } else {
      imageWidget = FittedBox(
        fit: BoxFit.contain,
        child: Icon(Icons.fastfood_outlined),
      );
    }
    return SizedBox(width: 80, height: 80, child: imageWidget);
  }
}