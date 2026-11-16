import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/cart_item_model.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // --- Authentication Session ---
  Future<bool> saveUserSession(UserModel user, {bool rememberMe = true}) async {
    await _prefs?.setString(AppConstants.keyUserToken, user.token);
    await _prefs?.setString(AppConstants.keyUserData, user.toJson());
    await _prefs?.setBool(AppConstants.keyRememberMe, rememberMe);
    if (rememberMe) {
      await _prefs?.setString(AppConstants.keySavedEmail, user.email);
    }
    return true;
  }

  UserModel? getSavedUser() {
    final userData = _prefs?.getString(AppConstants.keyUserData);
    if (userData != null && userData.isNotEmpty) {
      try {
        return UserModel.fromJson(userData);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  String? getUserToken() {
    return _prefs?.getString(AppConstants.keyUserToken);
  }

  bool isRememberMeEnabled() {
    return _prefs?.getBool(AppConstants.keyRememberMe) ?? false;
  }

  String? getSavedEmail() {
    return _prefs?.getString(AppConstants.keySavedEmail);
  }

  Future<void> clearUserSession() async {
    await _prefs?.remove(AppConstants.keyUserToken);
    await _prefs?.remove(AppConstants.keyUserData);
    final rememberMe = isRememberMeEnabled();
    if (!rememberMe) {
      await _prefs?.remove(AppConstants.keySavedEmail);
      await _prefs?.remove(AppConstants.keyRememberMe);
    }
  }

  // --- Favorites Persistence ---
  Future<bool> saveFavorites(List<String> favoriteIds) async {
    return await _prefs?.setStringList(AppConstants.keyFavorites, favoriteIds) ?? false;
  }

  List<String> getFavorites() {
    return _prefs?.getStringList(AppConstants.keyFavorites) ?? [];
  }

  // --- Cart / RFQ Persistence ---
  Future<bool> saveCartItems(List<CartItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    return await _prefs?.setStringList(AppConstants.keyCartItems, jsonList) ?? false;
  }

  List<CartItemModel> getCartItems() {
    final rawList = _prefs?.getStringList(AppConstants.keyCartItems);
    if (rawList == null) return [];
    try {
      return rawList.map((item) => CartItemModel.fromJson(item)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Theme Mode Persistence ---
  Future<bool> saveDarkMode(bool isDark) async {
    return await _prefs?.setBool(AppConstants.keyDarkMode, isDark) ?? false;
  }

  bool isDarkMode() {
    return _prefs?.getBool(AppConstants.keyDarkMode) ?? false;
  }
}
