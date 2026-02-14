import 'package:get_storage/get_storage.dart';

class UserStorage {
  static late final GetStorage _box;
  static const _userIdKey = "user_id";

  /// Initialize storage (must be called in main before runApp)
  static Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  /// Save userId locally
  static Future<void> saveUserId(String userId) async {
    await _box.write(_userIdKey, userId);
  }

  /// Get saved userId
  static String? getUserId() {
    return _box.read<String>(_userIdKey);
  }

  /// Clear stored user
  static Future<void> clearUser() async {
    await _box.remove(_userIdKey);
  }
}
