import 'dart:async';
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService;

  AuthService(this._storageService);

  /// Authenticate user with email and password
  Future<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    // Simulate network latency (0.8s) for realistic UX
    await Future.delayed(const Duration(milliseconds: 800));

    // Hardened credential check (accepts standard demo login or any valid format)
    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid email or password combination');
    }

    // Default or parsed user profile
    final nameFromEmail = email.split('@').first;
    final formattedName = nameFromEmail[0].toUpperCase() + nameFromEmail.substring(1);

    final user = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch % 100000}',
      name: formattedName.isNotEmpty ? formattedName : 'Sankar Partner',
      email: email.trim().toLowerCase(),
      phone: '+91 98765 43210',
      company: 'Sankar Automotive Systems Ltd',
      role: 'Procurement Specialist',
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}_sankar',
    );

    await _storageService.saveUserSession(user, rememberMe: rememberMe);
    return user;
  }

  /// Register a new account
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? company,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final user = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch % 100000}',
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      company: (company != null && company.trim().isNotEmpty)
          ? company.trim()
          : 'Sankar Engineering Partner',
      role: 'Procurement Engineer',
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}_sankar',
    );

    await _storageService.saveUserSession(user, rememberMe: true);
    return user;
  }

  /// Get currently active user from local persistent storage
  UserModel? getCurrentUser() {
    return _storageService.getSavedUser();
  }

  /// Log out and clear stored session
  Future<void> logout() async {
    await _storageService.clearUserSession();
  }
}
