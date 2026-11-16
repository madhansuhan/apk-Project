import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, authenticating, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _rememberMe = true;
  String _savedEmail = '';

  AuthProvider(this._authService, this._storageService) {
    _initializeAuth();
  }

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.authenticating;
  bool get rememberMe => _rememberMe;
  String get savedEmail => _savedEmail;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void _initializeAuth() {
    _rememberMe = _storageService.isRememberMeEnabled();
    _savedEmail = _storageService.getSavedEmail() ?? '';
    
    final savedUser = _authService.getCurrentUser();
    if (savedUser != null) {
      _user = savedUser;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(
        email: email,
        password: password,
        rememberMe: _rememberMe,
      );
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? company,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        company: company,
      );
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
