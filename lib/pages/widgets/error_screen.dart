import 'package:cookmate/design.dart';
import 'package:flutter/material.dart';

class ErrorScreeen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreeen({required this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
