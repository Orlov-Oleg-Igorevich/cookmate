import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage storage = GetStorage('userFavoriteRecipe');

  void writeToStorage({required String key, required String value}) {
    storage.write(key, value);
  }

  String? getFromStorage(String key) {
    return storage.read(key);
  }

  void removeFromStorage(String key) {
    storage.remove(key);
  }

  List<String> getAllFavorite() {
    final List<String> keys = storage.getValues();
    return keys;
  }
}
