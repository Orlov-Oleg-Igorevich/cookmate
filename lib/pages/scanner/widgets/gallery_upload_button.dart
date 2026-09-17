import 'package:flutter/material.dart';
import '../../../design.dart';
import '../../../design_system.dart';
import '../scanner_scope.dart';
import '../../../services/media-api.service.dart';

/// Кнопка загрузки фото из галереи
class GalleryUploadButton extends StatefulWidget {
  const GalleryUploadButton({super.key});

  @override
  State<GalleryUploadButton> createState() => _GalleryUploadButtonState();
}

class _GalleryUploadButtonState extends State<GalleryUploadButton> {
  final _camera = CameraService();

  Future<void> _loadPhoto() async {
    final image = await _camera.loadPhoto();
    if (image != null) {
      // Получаем доступ к ScannerScope и обновляем состояние
      final scope = ScannerScope.of(context);
      scope.onGalleryUpload(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _loadPhoto,
      borderRadius: AppRadius.lgBorder,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.lgBorder,
          color: AppColors.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_upload_outlined, color: AppColors.foreground),
            SizedBox(width: AppSpacing.xs),
            Text('Загрузить из галереи', style: AppTextStyles.buttonSecondary),
          ],
        ),
      ),
    );
  }
}
