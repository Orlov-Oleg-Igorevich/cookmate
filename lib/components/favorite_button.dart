import 'package:cookmate/components/card_scope.dart';
import 'package:cookmate/design.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CardScope.of(context, aspect: CardAspect.isFavorite);
    final isFavorite = scope.state.isFavorite;

    return GestureDetector(
      onTap: scope.onToggleFavorite,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? AppColors.love : AppColors.span,
      ),
    );
  }
}