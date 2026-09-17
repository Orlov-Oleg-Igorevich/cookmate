import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../design.dart';
import '../../../design_system.dart';
import '../../../services/media-api.service.dart';
import '../scanner_scope.dart';

/// Область для захвата фото с камерой
class PhotoCaptureArea extends StatefulWidget {
  const PhotoCaptureArea({super.key});

  @override
  State<PhotoCaptureArea> createState() => _PhotoCaptureAreaState();
}

class _PhotoCaptureAreaState extends State<PhotoCaptureArea> {
  final _camera = CameraService();

  Future<void> _takePhoto() async {
    final photo = await _camera.takePhoto();
    if (photo != null) {
      // Получаем доступ к ScannerScope и обновляем состояние
      final scope = ScannerScope.of(context);
      scope.onPhotoCaptured(photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _takePhoto,
      borderRadius: AppRadius.lgBorder,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(AppRadius.lg),
          color: AppColors.primary,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.lgBorder,
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.roundBorder,
                  color: AppColors.base,
                ),
                padding: EdgeInsets.all(AppSpacing.md),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text('Сделать фото', style: AppTextStyles.bodyLarge),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Сфотографируйте внутреннюю часть своего холодильника или набор продуктов',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
