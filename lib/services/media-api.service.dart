import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }

    } catch (e) {
      print('Ошибка при съёмке фото: $e');
    }

    return null;
  }

  Future<File?> loadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Не удалось загрузить фото из галереи: $e');
    }
    return null;
  }
}